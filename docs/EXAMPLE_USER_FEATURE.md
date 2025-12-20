# User Feature Example - Clean Architecture

This is a complete example demonstrating Clean Architecture implementation with:
- **Entity**: `UserModel`
- **Repositories**: `RemoteRepository`, `LocalRepository`
- **Use Case**: `UserUseCase`
- **BLoC**: `UserBloc` (Event, State, BLoC)
- **UI**: `UserPage`

## Architecture Flow

```
UI (UserPage)
    ↓
BLoC (UserBloc)
    ↓
Use Case (UserUseCase)
    ↓
Repositories (RemoteRepository, LocalRepository)
    ↓
Data Sources (API, SharedPreferences)
```

## Files Structure

```
lib/
├── entities/
│   └── user_model.dart                 # Data model with @freezed
├── repository/
│   ├── remote_repository.dart          # API calls (interface + implementation)
│   └── local_repository.dart           # Local storage (interface + implementation)
├── use_case/
│   └── user_use_case.dart              # Business logic (interface + implementation)
├── screen/
│   └── user/
│       ├── user_event.dart             # BLoC events
│       ├── user_state.dart             # BLoC state
│       ├── user_bloc.dart              # BLoC logic
│       └── user_page.dart              # UI
└── di/
    └── di_module.dart                  # DI module for Dio, SharedPreferences
```

## 1. Entity Layer

### `lib/entities/user_model.dart`

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
}
```

**Key Points:**
- Uses `@freezed` for immutability
- JSON serialization with `@JsonKey` for API field mapping
- Auto-generated `fromJson` and `toJson`

## 2. Repository Layer

### Remote Repository (API)

```dart
/// Interface
abstract class RemoteRepository {
  Future<UserModel> getUserProfile(int userId);
  Future<List<UserModel>> getUsers();
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
}

/// Implementation
@Injectable(as: RemoteRepository)
class RemoteRepositoryImpl implements RemoteRepository {
  final Dio _dio;

  RemoteRepositoryImpl(this._dio);

  @override
  Future<UserModel> getUserProfile(int userId) async {
    final response = await _dio.get('/users/$userId');
    return UserModel.fromJson(response.data);
  }
  // ... other methods
}
```

### Local Repository (Cache/Storage)

```dart
/// Interface
abstract class LocalRepository {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> saveUserList(List<UserModel> users);
  Future<List<UserModel>> getUserList();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

/// Implementation
@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferences _prefs;

  LocalRepositoryImpl(this._prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _prefs.setString('user', json);
  }
  // ... other methods
}
```

**Key Points:**
- Abstract interfaces for testability
- `@Injectable(as: Interface)` for DI
- Remote repository handles API calls
- Local repository handles caching/storage

## 3. Use Case Layer

### `lib/use_case/user_use_case.dart`

```dart
/// Interface
abstract class UserUseCase {
  Future<UserModel> getUserProfile(int userId);
  Future<List<UserModel>> getUsers({bool forceRefresh = false});
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
  Future<UserModel?> getCachedUser();
  Future<void> logout();
}

/// Implementation
@Injectable(as: UserUseCase)
class UserUseCaseImpl implements UserUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  UserUseCaseImpl(
    this._remoteRepository,
    this._localRepository,
  );

  @override
  Future<UserModel> getUserProfile(int userId) async {
    // Fetch from API
    final user = await _remoteRepository.getUserProfile(userId);
    
    // Cache locally
    await _localRepository.saveUser(user);
    
    return user;
  }

  @override
  Future<List<UserModel>> getUsers({bool forceRefresh = false}) async {
    // Try cache first
    if (!forceRefresh) {
      final cachedUsers = await _localRepository.getUserList();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers;
      }
    }
    
    // Fetch from API
    final users = await _remoteRepository.getUsers();
    
    // Cache locally
    await _localRepository.saveUserList(users);
    
    return users;
  }

  @override
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data) async {
    // Validation
    if (data['name']?.toString().isEmpty ?? true) {
      throw Exception('Name is required');
    }
    
    // Update via API
    final updatedUser = await _remoteRepository.updateUserProfile(userId, data);
    
    // Update cache
    await _localRepository.saveUser(updatedUser);
    
    return updatedUser;
  }
}
```

**Key Points:**
- Contains business logic and validation
- Coordinates between remote and local repositories
- Implements caching strategy
- Handles data transformation

## 4. BLoC Layer

### Events

```dart
@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadUsers({@Default(false) bool forceRefresh}) = _LoadUsers;
  const factory UserEvent.loadUserProfile(int userId) = _LoadUserProfile;
  const factory UserEvent.updateProfile(int userId, Map<String, dynamic> data) = _UpdateProfile;
  const factory UserEvent.deleteUser(int userId) = _DeleteUser;
  const factory UserEvent.logout() = _Logout;
}
```

### State

```dart
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default([]) List<UserModel> users,
    UserModel? currentUser,
    String? error,
  }) = _UserState;

  factory UserState.initial() => const UserState();
}
```

### BLoC

```dart
@injectable
class UserBloc extends Bloc<UserEvent, UserState> with SafetyNetworkMixin {
  final UserUseCase _useCase;

  UserBloc(this._useCase) : super(UserState.initial()) {
    on(_onStarted);
    on(_onLoadUsers);
    on(_onLoadUserProfile);
    on(_onUpdateProfile);
    on(_onDeleteUser);
    on(_onLogout);

    // Auto-start initialization
    add(const UserEvent.started());
  }

  Future<void> _onLoadUsers(_LoadUsers event, emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      () async {
        final users = await _useCase.getUsers(forceRefresh: event.forceRefresh);
        emit(state.copyWith(isLoading: false, users: users));
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false, error: error.toString()));
      },
    );
  }
  // ... other event handlers
}
```

**Key Points:**
- Uses `SafetyNetworkMixin` for error handling
- Auto-starts with `add(const UserEvent.started())`
- Each event has its own handler
- Emits new states based on use case results

## 5. UI Layer

### `lib/screen/user/user_page.dart`

```dart
@RoutePage()
class UserPage extends StatelessWidget implements AutoRouteWrapper {
  const UserPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen: (previous, current) => 
          previous.error != current.error && current.error != null,
      listener: (context, state) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('User List')),
        body: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading ||
              previous.users != current.users,
          builder: (context, state) {
            if (state.isLoading && state.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.name ?? 'Unknown'),
                  subtitle: Text(user.email ?? ''),
                  onTap: () {
                    context.read<UserBloc>().add(
                      UserEvent.loadUserProfile(user.id!),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
```

**Key Points:**
- Implements `AutoRouteWrapper` for BLoC provision
- Uses `BlocListener` for side effects (errors, navigation)
- Uses `BlocBuilder` with `buildWhen` for UI updates
- Dispatches events via `context.read<UserBloc>().add()`

## 6. Dependency Injection

### `lib/di/di_module.dart`

```dart
@module
abstract class DiModule {
  @lazySingleton
  Dio get dio {
    return Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

**Key Points:**
- `@module` for third-party dependencies
- `@lazySingleton` for single instance
- `@preResolve` for async initialization

## Usage Flow

### 1. User opens UserPage
```
UserPage created
    ↓
AutoRouteWrapper provides BLoC
    ↓
UserBloc initialized
    ↓
Auto-starts with UserEvent.started()
    ↓
Loads cached user from LocalRepository
```

### 2. User pulls to refresh
```
User swipes down
    ↓
UserPage dispatches UserEvent.loadUsers(forceRefresh: true)
    ↓
UserBloc calls UserUseCase.getUsers(forceRefresh: true)
    ↓
UserUseCase calls RemoteRepository.getUsers()
    ↓
UserUseCase caches result in LocalRepository
    ↓
UserBloc emits new state with users
    ↓
UserPage rebuilds with new data
```

### 3. User updates profile
```
User clicks edit button
    ↓
UserPage shows dialog
    ↓
User enters data and clicks save
    ↓
UserPage dispatches UserEvent.updateProfile(userId, data)
    ↓
UserBloc calls UserUseCase.updateUserProfile(userId, data)
    ↓
UserUseCase validates data
    ↓
UserUseCase calls RemoteRepository.updateUserProfile(userId, data)
    ↓
UserUseCase updates LocalRepository cache
    ↓
UserBloc emits new state with updated user
    ↓
UserPage rebuilds with updated data
```

## Testing

### Unit Test - Use Case
```dart
void main() {
  late UserUseCase useCase;
  late MockRemoteRepository mockRemoteRepository;
  late MockLocalRepository mockLocalRepository;

  setUp(() {
    mockRemoteRepository = MockRemoteRepository();
    mockLocalRepository = MockLocalRepository();
    useCase = UserUseCaseImpl(mockRemoteRepository, mockLocalRepository);
  });

  test('getUserProfile should fetch from API and cache locally', () async {
    // Arrange
    final user = UserModel(id: 1, name: 'John');
    when(() => mockRemoteRepository.getUserProfile(1))
        .thenAnswer((_) async => user);

    // Act
    final result = await useCase.getUserProfile(1);

    // Assert
    expect(result, user);
    verify(() => mockRemoteRepository.getUserProfile(1)).called(1);
    verify(() => mockLocalRepository.saveUser(user)).called(1);
  });
}
```

### BLoC Test
```dart
void main() {
  late UserBloc bloc;
  late MockUserUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUserUseCase();
    bloc = UserBloc(mockUseCase);
  });

  blocTest<UserBloc, UserState>(
    'emits users when loadUsers succeeds',
    build: () {
      when(() => mockUseCase.getUsers())
          .thenAnswer((_) async => [UserModel(id: 1, name: 'John')]);
      return bloc;
    },
    act: (bloc) => bloc.add(const UserEvent.loadUsers()),
    expect: () => [
      UserState(isLoading: true),
      UserState(isLoading: false, users: [UserModel(id: 1, name: 'John')]),
    ],
  );
}
```

## Key Principles

### ✅ DO
- Inject Use Cases in BLoCs (not Repositories)
- Use abstract interfaces for all layers
- Implement caching strategy in Use Cases
- Validate data in Use Cases
- Use `SafetyNetworkMixin` for error handling
- Use `buildWhen` and `listenWhen`
- Auto-start BLoCs with initial event

### ❌ DON'T
- Inject Repositories directly in BLoCs
- Put business logic in BLoCs
- Put validation in Repositories
- Skip abstract interfaces
- Skip error handling
- Skip caching strategy

## Summary

This example demonstrates:
1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Inversion**: Depend on abstractions, not implementations
3. **Testability**: Easy to mock and test each layer
4. **Maintainability**: Clear structure and consistent patterns
5. **Scalability**: Easy to add new features following the same pattern

Use this as a template for creating new features in your Flutter app!

