# Authentication Package (feature_auth)

The `feature_auth` package provides a complete authentication solution including login, registration, and session management.

## Overview

```
packages/feature/auth/
├── lib/
│   ├── auth.dart                 # Main export
│   └── src/
│       ├── di/                   # Dependency injection (feature-specific)
│       ├── l10n/                 # Localization
│       ├── navigation/           # Navigation interface/implementation
│       ├── screen/
│       │   ├── login/
│       │   │   ├── login_bloc.dart
│       │   │   └── login_page.dart
│       │   └── register/
│       │       ├── register_bloc.dart
│       │       └── register_page.dart
│       └── use_case/             # Feature-specific use cases or re-exports
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
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';

Future<void> configureDependencies() async {
  initCorePackage();
  initWidgetPackage();
  initDataPackage();        // Registers AuthRepositoryImpl, Dio, SharedPrefs
  initDomainPackage();      // Registers repository interfaces
  initUseCasesPackage();    // Registers core use cases (Login, Register etc.)
  initAuthPackage();        // Registers auth BLoCs
  initAppSettingsPackage();
  getIt.init();
}
```

> **Note**: `AuthRepositoryImpl` is already provided by `packages/data/`.
> You do NOT need to implement it in your app.

### 2. Implement AuthNavigation

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
  final StackRouter _router;

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

### 3. Create Route Definitions

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

### 4. Add Routes to Router

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

### 5. Add Localization Delegate

**lib/app/app.dart:**
```dart
import 'package:feature_auth/auth.dart';

MaterialApp.router(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    AuthLocalizationsFallback.delegate, // Add this (falls back to en)
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

### Navigation Contract

```dart
class AppRoute {
  final PageRouteInfo login;
  final PageRouteInfo register;
  final PageRouteInfo home;

  const AppRoute({
    required this.login,
    required this.register,
    required this.home,
  });
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
  const factory LoginEvent.register() = _LoginEventRegister;
  const factory LoginEvent.forgotPassword() = _LoginEventForgotPassword;
  const factory LoginEvent.obscurePasswordToggle() =
      _LoginEventObscurePasswordToggle;
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
  const factory RegisterEvent.login() = _RegisterEventLogin;
  const factory RegisterEvent.obscurePasswordToggle() =
      _RegisterEventObscurePasswordToggle;
  const factory RegisterEvent.obscureConfirmPasswordToggle() =
      _RegisterEventObscureConfirmPasswordToggle;
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
    @Default(true) bool obscurePassword,
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
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _RegisterState;
}
```

### Result Handling Pattern

```dart
final result = await _loginUseCase(credentials);
assert(result.isSuccess, result.failureOrNull);

final failure = result.failureOrNull;
if (failure != null) {
  emit(state.copyWith(isLoading: false, error: failure.message));
  _toast.show(failure.message, type: AppToastType.error);
  return;
}

final token = result.dataOrThrow;
emit(state.copyWith(isLoading: false, isSuccess: true, token: token));
_router.replaceAll([_appRoute.home]);
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

### Mock Use Case

```dart
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockStackRouter extends Mock implements StackRouter {}
class MockAppToast extends Mock implements AppToast {}
```

### BLoC Test

```dart
void main() {
  late LoginBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockStackRouter mockRouter;
  late MockAppToast mockToast;
  late AppRoute appRoute;
  late AuthToken token;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRouter = MockStackRouter();
    mockToast = MockAppToast();
    token = const AuthToken(accessToken: 'mock_token');
    appRoute = AppRoute(
      login: const LoginRoute(),
      register: const RegisterRoute(),
      home: const HomeRoute(),
    );

    when(() => mockLoginUseCase(any())).thenAnswer((_) async => Result.success(token));
    bloc = LoginBloc(mockLoginUseCase, mockRouter, appRoute, mockToast);
  });

  blocTest<LoginBloc, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () => bloc,
    act: (bloc) => bloc.add(const LoginEvent.submit(
      email: 'test@test.com',
      password: 'password',
    )),
    expect: () => [
      const LoginState(isLoading: true, obscurePassword: true),
      LoginState(
        isLoading: false,
        isSuccess: true,
        obscurePassword: true,
        token: token,
      ),
    ],
  );
}
```

## See Also

- [feature_packages.md](./feature_packages.md) - Creating feature packages
- [monorepo_guide.md](./monorepo_guide.md) - Monorepo structure
- [new_app_guide.md](./new_app_guide.md) - Creating apps with auth
