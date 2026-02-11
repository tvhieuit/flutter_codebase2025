# Data Package Guide

## Overview

The `packages/data` package contains the data layer following Clean Architecture principles. It implements the repository interfaces defined in `packages/domain/` using infrastructure dependencies (Dio, SharedPreferences).

## Installation

The data package is already included in the workspace. To use it in apps:

```yaml
# In your app's pubspec.yaml
dependencies:
  data: any  # Uses workspace resolution
```

## Package Structure

```
packages/data/
├── lib/
│   ├── data.dart                      # Main export (DI init only)
│   └── src/
│       ├── di/                        # Dependency Injection
│       │   ├── di.dart
│       │   ├── data_module.dart       # Dio, SharedPreferences providers
│       │   ├── injection.dart         # Injectable init
│       │   └── injection.config.dart  # Generated
│       ├── network/                   # Network layer
│       │   └── auth_interceptor.dart  # Adds Bearer token to requests
│       ├── repositories/              # Repository implementations
│       │   ├── auth_repository_impl.dart
│       │   ├── user_repository_impl.dart
│       │   ├── local_storage_impl.dart
│       │   ├── app_setting_repository_impl.dart
│       │   └── user_local_repository_impl.dart
│       └── storage/                   # Storage constants
│           └── storage_keys.dart
├── pubspec.yaml
└── analysis_options.yaml
```

## What Lives Here

| Component | Description |
|-----------|-------------|
| `DataModule` | Provides Dio and SharedPreferencesAsync instances via `@module` |
| `AuthInterceptor` | Dio interceptor that adds Bearer token from AuthRepository |
| `AuthRepositoryImpl` | Implements `AuthRepository` (login, register, logout, token refresh) |
| `UserRepositoryImpl` | Implements `UserRepository` (CRUD operations with cache fallback) |
| `LocalStorageImpl` | Implements `LocalStorage` using SharedPreferencesAsync |
| `UserLocalRepositoryImpl` | Implements `UserLocalRepository` (user cache, token management) |
| `AppSettingRepositoryImpl` | Implements `AppSettingsRepository` (theme, language, first launch) |
| `StorageKeys` | Constants for all SharedPreferences key names |

## What Does NOT Live Here

- Entity definitions (in `domain`)
- Repository interfaces (in `domain`)
- Use cases (in `domain`)
- BLoCs and UI (in `feature/*` or `apps/*`)

## Dependency Injection

### DI Init Function

```dart
import 'package:data/data.dart';

// Call in app's DI setup
initDataPackage();
```

### DI Initialization Order

The data package must be initialized **before** domain (since domain's use cases depend on repository implementations registered by data):

```dart
Future<void> configureDependencies() async {
  initCorePackage();       // Result, Failure, annotations
  initWidgetPackage();     // Shared widgets
  initDataPackage();       // Repo implementations, Dio, SharedPrefs
  initDomainPackage();     // Use cases (depend on repo interfaces)
  initAuthPackage();       // Auth feature BLoCs
  initAppSettingsPackage(); // App settings BLoCs
  getIt.init();            // App-level BLoCs
}
```

### DataModule

Provides infrastructure dependencies:

```dart
@module
abstract class DataModule {
  @lazySingleton
  SharedPreferencesAsync get prefs => SharedPreferencesAsync();

  @Named('auth_dio')
  @lazySingleton
  Dio get authDio => Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    return Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ))..interceptors.add(authInterceptor);
  }
}
```

Two Dio instances are provided:
- **Main Dio** - with `AuthInterceptor` for authenticated requests
- **`auth_dio`** - without interceptor, used by `AuthRepositoryImpl` to avoid circular dependency

## Storage Keys

Type-safe constants for SharedPreferences keys:

```dart
import 'package:data/data.dart'; // Not exported - internal to data package

StorageKeys.accessToken        // 'access_token'
StorageKeys.refreshToken       // 'refresh_token'
StorageKeys.currentUser        // 'current_user'
StorageKeys.themeMode          // 'theme_mode'
StorageKeys.languageCode       // 'language_code'
StorageKeys.isFirstLaunch      // 'is_first_launch'
StorageKeys.cachedUsers        // 'cached_users'
StorageKeys.cachedUsersTimestamp // 'cached_users_timestamp'

// Helper methods
StorageKeys.cacheKey('products')     // 'cache_products'
StorageKeys.timestampKey('users')    // 'users_timestamp'
```

## Repository Implementations

### UserRepositoryImpl

Implements `UserRepository` with network-first strategy and cache fallback:

```dart
@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final Dio _dio;
  final LocalStorage _localStorage;

  // Remote methods with internal cache fallback:
  // - getUserById: fetches from API, caches result, falls back to cache on error
  // - getUsers: fetches from API, caches list, falls back to cache on error
  // - createUser, updateUser: API only (updates cache on success)
  // - deleteUser: API + clears cache
  // - searchUsers: API only (no cache)
}
```

### AuthRepositoryImpl

Implements `AuthRepository` using a separate Dio instance (`@Named('auth_dio')`) to avoid circular dependency with `AuthInterceptor`:

```dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @Named('auth_dio')
  final Dio _dio;
  final LocalStorage _localStorage;

  // login, register: API call + save token locally
  // logout: clear local token
  // refreshToken: API call + update local token
  // getToken, isLoggedIn: read from local storage
}
```

## Adding New Repository Implementations

1. Define the interface in `packages/domain/lib/src/repositories/`
2. Create the implementation in `packages/data/lib/src/repositories/`
3. Use `@Injectable(as: InterfaceName)` annotation
4. Run build_runner: `cd packages/data && fvm dart run build_runner build -d`

## Commands

```bash
# Generate DI config
cd packages/data && fvm dart run build_runner build -d

# Analyze
cd packages/data && fvm dart analyze lib

# Get dependencies
fvm dart run melos run pg
```

## See Also

- [domain_package.md](./domain_package.md) - Domain package (interfaces this package implements)
- [project_structure.md](./project_structure.md) - Full project structure
- [shared_preferences_async.md](./shared_preferences_async.md) - SharedPreferencesAsync usage
- [clean_architecture.md](./clean_architecture.md) - Architecture rules
