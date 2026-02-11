# Domain Package Guide

## Overview

The `packages/domain` package contains the core business logic following Clean Architecture principles. It's a pure Dart package with Freezed for immutability.

## Installation

The domain package is already included in the workspace. To use it in other packages:

```yaml
# In your package's pubspec.yaml
dependencies:
  domain: any  # Uses workspace resolution
```

## Package Structure

```
packages/domain/
├── lib/
│   ├── domain.dart                    # Main export file
│   └── src/
│       ├── di/                        # Dependency Injection (use cases only)
│       │   ├── di.dart
│       │   └── injection.dart
│       ├── entities/                  # Business models (@modelFreezed)
│       │   ├── entities.dart
│       │   ├── user_entity.dart
│       │   ├── product_entity.dart
│       │   └── auth/
│       │       ├── auth_token.dart
│       │       └── auth_credentials.dart
│       ├── repositories/              # Repository interfaces ONLY (no implementations)
│       │   ├── repositories.dart
│       │   ├── user_repository.dart
│       │   ├── product_repository.dart
│       │   ├── auth_repository.dart
│       │   └── local/
│       │       ├── local.dart
│       │       ├── local_storage.dart
│       │       ├── user_local_repository.dart
│       │       └── app_settings_repository.dart
│       └── use_cases/                 # Business logic
│           ├── use_cases.dart
│           ├── base_use_case.dart
│           ├── auth/
│           ├── user/
│           └── product/
├── pubspec.yaml
└── readme.md
```

> **Note**: Repository implementations, network code (AuthInterceptor), storage keys,
> and infrastructure DI (Dio, SharedPreferences) live in `packages/data/`.
> See [data_package.md](./data_package.md).

## Custom Freezed Annotations

Located in `lib/src/annotations/annotations.dart`:

```dart
import 'package:domain/domain.dart';

// For BLoC Events - minimal generation
@eventFreezed  // copyWith: false, equal: false, fromJson: false, toJson: false

// For BLoC States - with copyWith only  
@stateFreezed  // copyWith: true, equal: false, fromJson: false, toJson: false

// For Models/Entities - with JSON serialization
@modelFreezed  // copyWith: false, equal: false, fromJson: true, toJson: true

// For Result/Failure types
@resultFreezed // copyWith: false, equal: false, fromJson: false, toJson: false

// For Use Case Parameters
@paramsFreezed // copyWith: false, equal: false, fromJson: false, toJson: false
```

### Usage Examples

```dart
// Entity with JSON
@modelFreezed
sealed class UserEntity with _$UserEntity { ... }

// BLoC Event
@eventFreezed
sealed class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadUser(int id) = _LoadUser;
}

// BLoC State
@stateFreezed
sealed class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    UserEntity? user,
    String? error,
  }) = _UserState;
}

// Use Case Params
@paramsFreezed
sealed class GetUsersParams with _$GetUsersParams {
  const factory GetUsersParams({
    @Default(1) int page,
    @Default(20) int limit,
  }) = _GetUsersParams;
}
```

## Result Type

Type-safe error handling without exceptions:

```dart
import 'package:domain/domain.dart';

// Creating results
final success = Result.success(user);
final failure = Result.failure(Failure.noConnection());

// Explicit handling
final error = result.failureOrNull;
if (error != null) {
  print('Error: ${error.message}');
  return;
}

final user = result.dataOrThrow;
print('User: ${user.name}');

// Convenience methods
result.isSuccess;     // bool
result.dataOrNull;    // T?
result.failureOrNull; // Failure?
result.dataOrThrow;   // T (throws on failure)

// Mapping
final nameResult = result.map((user) => user.name);
final flatResult = result.flatMap((user) => getUserDetails(user.id));
```

## Failures

Sealed failure types for comprehensive error handling:

```dart
import 'package:domain/domain.dart';

// Create failures
final serverError = Failure.server(message: 'Server error', statusCode: 500);
final networkError = Failure.noConnection();
final validationError = Failure.required('Email');
final authError = Failure.invalidCredentials();

// From HTTP status code
final httpError = Failure.fromStatusCode(404);

// Pattern matching
failure.when(
  server: (msg, code, status) => handleServer(),
  network: (msg, code) => handleNetwork(),
  cache: (msg, code) => handleCache(),
  validation: (msg, code, field) => handleValidation(),
  auth: (msg, code) => handleAuth(),
  unknown: (msg, code, ex) => handleUnknown(),
);
```

## Local Storage

### LocalStorage Interface

Abstract interface for key-value storage (defined here, implemented in `packages/data/`):

```dart
import 'package:domain/domain.dart';

// Inject LocalStorage
@injectable
class MyUseCase {
  final LocalStorage _storage;

  MyUseCase(this._storage);

  Future<void> saveData() async {
    // String
    await _storage.setString('key', 'value');
    final value = await _storage.getString('key');

    // JSON Object
    await _storage.setJson('user', user.toJson());
    final json = await _storage.getJson('user');

    // JSON List
    await _storage.setJsonList('users', users.map((u) => u.toJson()).toList());
    final jsonList = await _storage.getJsonList('users');

    // Other types
    await _storage.setInt('count', 42);
    await _storage.setBool('enabled', true);
    await _storage.setDouble('price', 99.99);
    await _storage.setStringList('tags', ['a', 'b']);

    // Utilities
    final exists = await _storage.containsKey('key');
    await _storage.remove('key');
    await _storage.clear();
    final keys = await _storage.getKeys();
  }
}
```

> **Note**: `StorageKeys` constants and `LocalStorageImpl` are in `packages/data/`.

### UserLocalRepository

Pre-built repository for user data caching:

```dart
import 'package:domain/domain.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLocalRepository _userLocalRepo;
  
  AuthBloc(this._userLocalRepo) : super(AuthState.initial());
  
  Future<void> checkAuth() async {
    // Get cached user
    final result = await _userLocalRepo.getCurrentUser();
    final failure = result.failureOrNull;
    if (failure != null) {
      handleError(failure);
      return;
    }

    final currentUser = result.dataOrThrow;
    if (currentUser != null) {
      // User is logged in
    }
    
    // Save user
    await _userLocalRepo.saveCurrentUser(currentUser);
    
    // Token management
    await _userLocalRepo.saveAccessToken(token);
    final tokenResult = await _userLocalRepo.getAccessToken();
    
    // Cache users list with expiry
    await _userLocalRepo.cacheUsers(users);
    final isValid = await _userLocalRepo.isUsersCacheValid(
      maxAge: Duration(hours: 1),
    );
    final cachedUsers = await _userLocalRepo.getCachedUsers();
    
    // Logout - clear all user data
    await _userLocalRepo.clearAllUserData();
  }
}
```

### AppSettingsRepository

Pre-built repository for app settings:

```dart
import 'package:domain/domain.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppSettingsRepository _settingsRepo;
  
  SettingsBloc(this._settingsRepo) : super(SettingsState.initial());
  
  Future<void> loadSettings() async {
    // Theme
    final themeResult = await _settingsRepo.getThemeMode();
    // Returns AppThemeMode.light, .dark, or .system
    
    await _settingsRepo.setThemeMode(AppThemeMode.dark);
    
    // Language
    final langResult = await _settingsRepo.getLanguageCode();
    await _settingsRepo.setLanguageCode('ko');
    
    // First launch & onboarding
    final isFirst = await _settingsRepo.isFirstLaunch();
    await _settingsRepo.setFirstLaunchCompleted();
    
    final onboardingDone = await _settingsRepo.isOnboardingCompleted();
    await _settingsRepo.setOnboardingCompleted();
    
    // Notifications
    final pushEnabled = await _settingsRepo.isPushNotificationEnabled();
    await _settingsRepo.setPushNotificationEnabled(false);
  }
}
```

## Use Cases

### Base Use Case Interfaces

```dart
import 'package:domain/domain.dart';

// Without parameters
abstract class UseCase<T> {
  Future<Result<T>> call();
}

// With parameters
abstract class UseCaseWithParams<T, Params> {
  Future<Result<T>> call(Params params);
}

// Stream-based
abstract class StreamUseCase<T> {
  Stream<Result<T>> call();
}
```

### Creating Use Cases

```dart
import 'package:domain/domain.dart';

// Use case with validation
class GetUserUseCase implements UseCaseWithParams<UserEntity, int> {
  final UserRepository _repository;
  
  GetUserUseCase(this._repository);
  
  @override
  Future<Result<UserEntity>> call(int userId) async {
    // Validation
    if (userId <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid user ID'),
      );
    }
    
    return await _repository.getUserById(userId);
  }
}

// Use case with Freezed params
@paramsFreezed
sealed class CreateUserParams with _$CreateUserParams {
  const factory CreateUserParams({
    required String name,
    required String email,
    String? phone,
  }) = _CreateUserParams;
}

class CreateUserUseCase implements UseCaseWithParams<UserEntity, CreateUserParams> {
  final UserRepository _repository;
  
  CreateUserUseCase(this._repository);
  
  @override
  Future<Result<UserEntity>> call(CreateUserParams params) async {
    // Validate name
    if (params.name.trim().isEmpty) {
      return Result.failure(Failure.required('Name'));
    }
    
    // Validate email
    if (!params.email.contains('@')) {
      return Result.failure(Failure.invalidEmail());
    }
    
    return await _repository.createUser(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(),
      phone: params.phone?.trim(),
    );
  }
}
```

## Dependency Injection Setup

### 1. Register Packages in Main App

```dart
// lib/di/injection.dart
import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:feature_app_settings/app_settings.dart';
import 'package:feature_auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(...)
Future<void> configureDependencies() async {
  initCorePackage();
  initWidgetPackage();
  initDataPackage();        // Registers repo impls, Dio, SharedPrefs
  initDomainPackage();      // Registers use cases
  initAuthPackage();
  initAppSettingsPackage();
  getIt.init();
}
```

### 2. Run Code Generation

```bash
# Generate injectable config
fvm dart run melos run brd
```

### 3. Use in BLoCs

```dart
import 'package:domain/domain.dart';

// BLoCs inject USE CASES only, never repositories directly
@injectable
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUsersUseCase _getUsersUseCase;
  final GetCachedUsersUseCase _getCachedUsersUseCase;

  UserBloc(
    this._getCurrentUserUseCase,
    this._getUsersUseCase,
    this._getCachedUsersUseCase,
  ) : super(UserState.initial()) {
    on(_onLoadUser);
  }

  Future<void> _onLoadUser(_LoadUser event, emit) async {
    emit(state.copyWith(isLoading: true));

    // Try cache first
    final cacheResult = await _getCachedUsersUseCase();
    final cachedUsers = cacheResult.dataOrNull;

    if (cachedUsers != null && cachedUsers.isNotEmpty) {
      emit(state.copyWith(users: cachedUsers, isLoading: false));
      return;
    }

    // Fetch from API
    final result = await _getUsersUseCase();
    final failure = result.failureOrNull;
    if (failure != null) {
      emit(state.copyWith(error: failure.message, isLoading: false));
      return;
    }

    emit(state.copyWith(users: result.dataOrThrow, isLoading: false));
  }
}
```

## Complete Example: Feature Implementation

### 1. Define State with Custom Annotation

```dart
// lib/screen/profile/profile_state.dart
import 'package:domain/domain.dart';

part 'profile_state.freezed.dart';

@stateFreezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    UserEntity? user,
    String? error,
  }) = _ProfileState;
  
  factory ProfileState.initial() => const ProfileState();
}
```

### 2. Define Event with Custom Annotation

```dart
// lib/screen/profile/profile_event.dart
import 'package:domain/domain.dart';

part 'profile_event.freezed.dart';

@eventFreezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;
  const factory ProfileEvent.refresh() = _Refresh;
  const factory ProfileEvent.logout() = _Logout;
}
```

### 3. Implement BLoC

```dart
// lib/screen/profile/profile_bloc.dart
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ClearUserDataUseCase _clearUserDataUseCase;
  final AppToast _toast;

  ProfileBloc(
    this._getCurrentUserUseCase,
    this._clearUserDataUseCase,
    this._toast,
  ) : super(ProfileState.initial()) {
    on(_onStarted);
    on(_onRefresh);
    on(_onLogout);

    add(const ProfileEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    await _loadUser(emit);
  }

  Future<void> _onRefresh(_Refresh event, emit) async {
    await _loadUser(emit);
  }

  Future<void> _onLogout(_Logout event, emit) async {
    await _clearUserDataUseCase();
    emit(ProfileState.initial());
  }

  Future<void> _loadUser(Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await _getCurrentUserUseCase();
      final failure = result.failureOrNull;
      if (failure != null) {
        emit(state.copyWith(isLoading: false));
        _toast.error(failure.message);
        return;
      }

      emit(state.copyWith(user: result.dataOrThrow, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      _toast.error('An unexpected error occurred');
    }
  }
}
```

### 4. Run Code Generation

```bash
fvm dart run melos run brd
```

## Summary

### Key Imports

```dart
// Import everything from domain
import 'package:domain/domain.dart';

// This gives you access to:
// - Entities: UserEntity, ProductEntity, AuthToken, AuthCredentials
// - Repository Interfaces: UserRepository, LocalStorage, UserLocalRepository, etc.
// - Use Cases: GetUserUseCase, LoginUseCase, GetCachedUsersUseCase, etc.
// - DI Init: initDomainPackage()

// From app_core (re-exported by domain):
// - Custom annotations: @eventFreezed, @stateFreezed, @modelFreezed, etc.
// - Result type: Result.success(), Result.failure()
// - Failures: Failure.server(), Failure.network(), etc.

// NOT in domain (in packages/data instead):
// - Repository implementations (AuthRepositoryImpl, UserRepositoryImpl, etc.)
// - StorageKeys constants
// - AuthInterceptor
// - DataModule (Dio, SharedPreferences providers)
```

### Commands

```bash
# Get dependencies
fvm dart run melos run pg

# Generate code (freezed, injectable)
fvm dart run melos run brd

# Format code
fvm dart run melos run fm
```
