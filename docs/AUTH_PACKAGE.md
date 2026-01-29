# Authentication Package (feature_auth)

The `feature_auth` package provides a complete authentication solution including login, registration, and session management.

## Overview

```
packages/feature/auth/
├── lib/
│   ├── auth.dart                 # Main export
│   └── src/
│       ├── bloc/
│       │   ├── login_bloc.dart   # Login BLoC
│       │   └── register_bloc.dart # Registration BLoC
│       ├── page/
│       │   ├── login_page.dart   # Login UI
│       │   └── register_page.dart # Registration UI
│       ├── models/
│       │   ├── auth_credentials.dart
│       │   └── auth_token.dart
│       ├── repository/
│       │   └── auth_repository.dart
│       ├── navigation/
│       │   └── auth_navigation.dart
│       ├── l10n/                 # Localization
│       └── di/                   # Dependency injection
├── l10n/
│   └── auth_en.arb
├── pubspec.yaml
└── l10n.yaml
```

## Features

- ✅ Login with email/password
- ✅ User registration
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Localization support
- ✅ Navigation abstraction
- ✅ BLoC state management

## Installation

### 1. Add to Workspace

Ensure `feature_auth` is in root `pubspec.yaml`:
```yaml
workspace:
  - packages/feature/auth
```

### 2. Add Dependency

In your app's `pubspec.yaml`:
```yaml
dependencies:
  feature_auth: any
```

### 3. Run Pub Get

```bash
fvm dart run melos run pg
```

## Usage

### 1. Initialize DI

In your app's `di/injection.dart`:

```dart
import 'package:feature_auth/auth.dart' as auth;

Future<void> configureDependencies() async {
  // Initialize SharedPreferences first
  final prefs = SharedPreferencesAsync();
  getIt.registerSingleton<SharedPreferencesAsync>(prefs);

  // Initialize domain package
  domain.initDomainPackage(getIt: getIt);

  // Initialize auth package
  auth.initAuthPackage(getIt: getIt);

  // Initialize your app's DI
  getIt.init();
}
```

### 2. Implement AuthRepository

Create an implementation in your app's `di/modules.dart`:

```dart
import 'package:feature_auth/auth.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthModule {
  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;
}

@Injectable()
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final String _baseUrl;

  AuthRepositoryImpl(this._dio, @Named('baseUrl') this._baseUrl);

  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: {
          'email': credentials.email,
          'password': credentials.password,
        },
      );

      return Result.success(AuthToken.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(Failure.server(
        message: e.response?.data['message'] ?? 'Login failed',
        code: e.response?.statusCode?.toString(),
      ));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> register(RegisterCredentials credentials) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/register',
        data: {
          'name': credentials.name,
          'email': credentials.email,
          'password': credentials.password,
          'phone': credentials.phone,
        },
      );

      return Result.success(AuthToken.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(Failure.server(
        message: e.response?.data['message'] ?? 'Registration failed',
      ));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dio.post('$_baseUrl/auth/logout');
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<AuthToken>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return Result.success(AuthToken.fromJson(response.data));
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    // Check if token exists and is valid
    return const Result.success(false);
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    // Get token from storage
    return const Result.success(null);
  }

  @override
  Future<Result<void>> forgotPassword(String email) async {
    try {
      await _dio.post('$_baseUrl/auth/forgot-password', data: {'email': email});
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _dio.post('$_baseUrl/auth/reset-password', data: {
        'token': token,
        'password': newPassword,
      });
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> verifyEmail(String otp) async {
    try {
      await _dio.post('$_baseUrl/auth/verify-email', data: {'otp': otp});
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resendVerificationEmail(String email) async {
    try {
      await _dio.post('$_baseUrl/auth/resend-verification', data: {'email': email});
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }
}
```

### 3. Implement AuthNavigation

```dart
import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../app/app_router.dart' show AppRouter, HomeRoute;
import '../app/auth_routes.dart';

@module
abstract class NavigationModule {
  @LazySingleton(as: AuthNavigation)
  AuthNavigationImpl get authNavigation;
}

@Injectable()
class AuthNavigationImpl implements AuthNavigation {
  final AppRouter _router;

  AuthNavigationImpl(this._router);

  @override
  void goToRegister() {
    _router.push(const RegisterRoute());
  }

  @override
  void goToLogin() {
    _router.push(const LoginRoute());
  }

  @override
  void goToHome() {
    _router.replaceAll([const HomeRoute()]);
  }

  @override
  void goToForgotPassword() {
    // Implement when you have a forgot password screen
    // _router.push(const ForgotPasswordRoute());
  }

  @override
  void goBack() {
    _router.maybePop();
  }
}
```

### 4. Create Route Definitions

Since feature_auth pages use `@RoutePage()` but are in a different package, you need to create manual route definitions:

**lib/app/auth_routes.dart:**
```dart
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/auth.dart';

class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => const WrappedRoute(child: LoginPage()),
  );
}

class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => const WrappedRoute(child: RegisterPage()),
  );
}
```

### 5. Add Routes to Router

**lib/app/app_router.dart:**
```dart
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/home/home_page.dart';
import '../screen/splash/splash_page.dart';
import 'auth_routes.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page),
        // Auth routes
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
      ];
}
```

### 6. Add Localization Delegate

**lib/app/app.dart:**
```dart
import 'package:feature_auth/auth.dart';

MaterialApp.router(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    AuthLocalizations.delegate,  // Add this
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  // ...
)
```

## API Reference

### Models

#### LoginCredentials
```dart
@freezed
class LoginCredentials with _$LoginCredentials {
  const factory LoginCredentials({
    required String email,
    required String password,
  }) = _LoginCredentials;
}
```

#### RegisterCredentials
```dart
@freezed
class RegisterCredentials with _$RegisterCredentials {
  const factory RegisterCredentials({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = _RegisterCredentials;
}
```

#### AuthToken
```dart
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
    String? tokenType,
  }) = _AuthToken;
}
```

### Repository Interface

```dart
abstract class AuthRepository {
  Future<Result<AuthToken>> login(LoginCredentials credentials);
  Future<Result<AuthToken>> register(RegisterCredentials credentials);
  Future<Result<void>> logout();
  Future<Result<AuthToken>> refreshToken(String refreshToken);
  Future<Result<bool>> isAuthenticated();
  Future<Result<String?>> getAccessToken();
  Future<Result<void>> forgotPassword(String email);
  Future<Result<void>> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<Result<void>> verifyEmail(String otp);
  Future<Result<void>> resendVerificationEmail(String email);
}
```

### Navigation Interface

```dart
abstract class AuthNavigation {
  void goToRegister();
  void goToLogin();
  void goToHome();
  void goToForgotPassword();
  void goBack();
}
```

### BLoC Events

#### LoginEvent
```dart
@freezed
sealed class LoginEvent with _$LoginEvent {
  const factory LoginEvent.submit({
    required String email,
    required String password,
  }) = LoginEventSubmit;
  const factory LoginEvent.clearError() = LoginEventClearError;
}
```

#### RegisterEvent
```dart
@freezed
sealed class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = RegisterEventSubmit;
  const factory RegisterEvent.clearError() = RegisterEventClearError;
}
```

### BLoC States

#### LoginState
```dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _LoginState;
}
```

#### RegisterState
```dart
@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _RegisterState;
}
```

## Localization

The package provides localization for all UI text. Available keys:

| Key | Description |
|-----|-------------|
| `loginTitle` | Login page title |
| `loginButton` | Login button text |
| `registerTitle` | Register page title |
| `registerButton` | Register button text |
| `emailLabel` | Email field label |
| `emailHint` | Email field hint |
| `emailRequired` | Email validation message |
| `passwordLabel` | Password field label |
| `passwordHint` | Password field hint |
| `passwordRequired` | Password validation message |
| `passwordHelper` | Password requirements text |
| `confirmPasswordLabel` | Confirm password label |
| `confirmPasswordHint` | Confirm password hint |
| `confirmPasswordRequired` | Confirm password validation |
| `passwordsDoNotMatch` | Passwords mismatch error |
| `fullNameLabel` | Full name field label |
| `fullNameHint` | Full name field hint |
| `fullNameRequired` | Full name validation message |
| `phoneLabel` | Phone field label |
| `phoneHint` | Phone field hint |
| `forgotPassword` | Forgot password link |
| `noAccount` | "Don't have account?" text |
| `alreadyHaveAccount` | "Already have account?" text |

### Adding Additional Languages

Create new ARB files in `packages/feature/auth/l10n/`:

**auth_ko.arb** (Korean):
```json
{
  "@@locale": "ko",
  "loginTitle": "로그인",
  "loginButton": "로그인",
  // ... other translations
}
```

Then regenerate:
```bash
cd packages/feature/auth && fvm flutter gen-l10n
```

## Testing

### Mock Repository

```dart
class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    if (credentials.email == 'test@test.com' && 
        credentials.password == 'password') {
      return const Result.success(AuthToken(
        accessToken: 'mock_token',
        refreshToken: 'mock_refresh',
      ));
    }
    return Result.failure(Failure.auth(message: 'Invalid credentials'));
  }
  
  // ... implement other methods
}
```

### BLoC Test

```dart
void main() {
  late LoginBloc bloc;
  late MockAuthRepository mockRepo;
  late MockUserLocalRepository mockLocalRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockLocalRepo = MockUserLocalRepository();
    bloc = LoginBloc(mockRepo, mockLocalRepo);
  });

  blocTest<LoginBloc, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () => bloc,
    act: (bloc) => bloc.add(const LoginEvent.submit(
      email: 'test@test.com',
      password: 'password',
    )),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(isLoading: false, isSuccess: true, token: someToken),
    ],
  );
}
```

## See Also

- [FEATURE_PACKAGES.md](./FEATURE_PACKAGES.md) - Creating feature packages
- [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md) - Monorepo structure
- [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md) - Creating apps with auth
