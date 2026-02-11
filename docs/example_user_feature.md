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
packages/domain/lib/src/
├── entities/
│   └── user_entity.dart               # Business entity with @modelFreezed
├── repositories/
│   ├── user_repository.dart           # Remote repository interface (in domain)
│   └── local/
│       └── user_local_repository.dart  # Local repository interface (in domain)
└── use_cases/
    └── user/
        ├── get_user_use_case.dart      # Single responsibility use case
        ├── get_users_use_case.dart
        └── ...

packages/data/lib/src/
├── repositories/
│   ├── user_repository_impl.dart      # Remote implementation (in data)
│   └── user_local_repository_impl.dart # Local implementation (in data)
└── di/
    └── data_module.dart               # DI module for Dio, SharedPreferences

apps/flutter_app/lib/
└── screen/
    └── user/
        ├── user_event.dart            # BLoC events
        ├── user_state.dart            # BLoC state
        ├── user_bloc.dart             # BLoC logic (injects use cases only)
        └── user_page.dart             # UI
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

### Repository Interface (in `packages/domain/`)

```dart
/// Remote repository interface - defined in domain, implemented in data
abstract class UserRepository {
  Future<Result<UserEntity>> getUserById(int id);
  Future<Result<List<UserEntity>>> getUsers({int? page, int? limit});
  Future<Result<UserEntity>> createUser({required String name, required String email, String? phone});
  Future<Result<UserEntity>> updateUser({required int id, String? name, String? email, String? phone});
  Future<Result<void>> deleteUser(int id);
  Future<Result<List<UserEntity>>> searchUsers(String query);
}
```

### Repository Implementation (in `packages/data/`)

```dart
/// Implementation with Dio for network calls
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final Dio _dio;
  final LocalStorage _localStorage;

  UserRepositoryImpl(this._dio, this._localStorage);

  @override
  Future<Result<UserEntity>> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = UserEntity.fromJson(response.data);
      return Result.success(user);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    }
  }
  // ... other methods
}
```

**Key Points:**
- Interfaces live in `packages/domain/` (pure Dart, no infrastructure)
- Implementations live in `packages/data/` (depends on Dio, SharedPreferences)
- `@Injectable(as: Interface)` for DI registration
- Use `Result<T>` for error handling (no exceptions)

## 3. Use Case Layer (in `packages/domain/`)

Each use case has a single responsibility:

```dart
/// Get a single user by ID
@injectable
class GetUserUseCase implements UseCaseWithParams<UserEntity, int> {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  @override
  Future<Result<UserEntity>> call(int userId) async {
    if (userId <= 0) {
      return const Result.failure(Failure.validation(message: 'Invalid user ID'));
    }
    return await _userRepository.getUserById(userId);
  }
}

/// Get cached users from local storage
@injectable
class GetCachedUsersUseCase implements UseCase<List<UserEntity>> {
  final UserLocalRepository _userLocalRepository;

  GetCachedUsersUseCase(this._userLocalRepository);

  @override
  Future<Result<List<UserEntity>>> call() async {
    return await _userLocalRepository.getCachedUsers();
  }
}

/// Clear all user data (for logout)
@injectable
class ClearUserDataUseCase implements UseCase<void> {
  final UserLocalRepository _userLocalRepository;

  ClearUserDataUseCase(this._userLocalRepository);

  @override
  Future<Result<void>> call() async {
    return await _userLocalRepository.clearAllUserData();
  }
}
```

**Key Points:**
- Single Responsibility: one use case = one operation
- Returns `Result<T>` (no exceptions)
- Validation happens in the use case
- Injects repository interfaces (implementations are in `data` package)

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
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsersUseCase;
  final GetCachedUsersUseCase _getCachedUsersUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final ClearUserDataUseCase _clearUserDataUseCase;
  final AppToast _toast;

  UserBloc(
    this._getUsersUseCase,
    this._getCachedUsersUseCase,
    this._deleteUserUseCase,
    this._clearUserDataUseCase,
    this._toast,
  ) : super(UserState.initial()) {
    on(_onStarted);
    on(_onLoadUsers);
    on(_onDeleteUser);
    on(_onLogout);

    add(const UserEvent.started());
  }

  Future<void> _onLoadUsers(_LoadUsers event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Try cache first
      final cacheResult = await _getCachedUsersUseCase();
      final cached = cacheResult.dataOrNull;
      if (cached != null && cached.isNotEmpty && !event.forceRefresh) {
        emit(state.copyWith(isLoading: false, users: cached));
        return;
      }

      // Fetch from API
      final result = await _getUsersUseCase();
      final failure = result.failureOrNull;
      if (failure != null) {
        emit(state.copyWith(isLoading: false));
        _toast.error(failure.message);
        return;
      }

      emit(state.copyWith(isLoading: false, users: result.dataOrThrow));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }
  // ... other event handlers
}
```

**Key Points:**
- Injects **use cases** only (never repositories directly)
- Each use case handles one operation
- Uses `try/catch` + `AppToast` for error handling
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

Infrastructure dependencies (Dio, SharedPreferences) are provided by `packages/data`:

```dart
// packages/data/lib/src/di/data_module.dart
@module
abstract class DataModule {
  @lazySingleton
  SharedPreferencesAsync get prefs => SharedPreferencesAsync();

  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    return Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ))..interceptors.add(authInterceptor);
  }
}
```

In the app's DI setup:

```dart
// apps/flutter_app/lib/di/injection.dart
Future<void> configureDependencies() async {
  initCorePackage();
  initWidgetPackage();
  initDataPackage();     // Registers Dio, SharedPrefs, repo impls
  initDomainPackage();   // Registers use cases
  initAuthPackage();
  getIt.init();          // Registers app-level BLoCs
}
```

**Key Points:**
- `@module` for third-party dependencies (in `data` package)
- `@lazySingleton` for single instance
- Package init order matters: `data` before `domain`

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

