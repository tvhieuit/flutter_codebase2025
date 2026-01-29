# Auth Feature Package

Authentication feature package providing login, register, and logout functionality.

## Features

- Login with email/password
- User registration with validation
- Logout with token cleanup
- Authentication status checking
- Password visibility toggle
- Form validation

## Structure

```
lib/
├── auth.dart                    # Main export
└── src/
    ├── bloc/                    # Auth BLoC
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── di/                      # Dependency Injection
    │   └── auth_module.dart
    ├── models/                  # Auth models
    │   ├── auth_credentials.dart
    │   └── auth_token.dart
    ├── page/                    # UI Pages
    │   ├── login_page.dart
    │   └── register_page.dart
    ├── repository/              # Repository interface
    │   └── auth_repository.dart
    └── use_case/                # Use cases
        ├── login_use_case.dart
        ├── register_use_case.dart
        ├── logout_use_case.dart
        └── check_auth_use_case.dart
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  feature_auth: any  # Uses workspace resolution
```

## Setup

### 1. Implement AuthRepository

Create an implementation of `AuthRepository` in your main app:

```dart
// lib/repository/auth_repository_impl.dart
import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  
  AuthRepositoryImpl(this._dio);
  
  @override
  Future<Result<AuthToken>> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': credentials.email,
        'password': credentials.password,
      });
      return Result.success(AuthToken.fromJson(response.data));
    } catch (e) {
      return Result.failure(Failure.server(message: e.toString()));
    }
  }
  
  // ... implement other methods
}
```

### 2. Register DI Module

```dart
// lib/di/injection.dart
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(DomainModule),
    ExternalModule(AuthModule),
  ],
)
void configureDependencies() => getIt.init();
```

### 3. Add Routes

```dart
// lib/app/app_router.dart
import 'package:feature_auth/auth.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    // ... other routes
  ];
}
```

### 4. Run Code Generation

```bash
fvm dart run melos run brd
```

## Usage

### Check Auth Status

```dart
// In splash screen or app initialization
final authBloc = getIt<AuthBloc>();

// Auth is checked automatically on bloc creation
authBloc.stream.listen((state) {
  if (state.isAuthenticated) {
    // Navigate to home
  } else if (state.isUnauthenticated) {
    // Navigate to login
  }
});
```

### Login

```dart
context.read<AuthBloc>().add(
  AuthEvent.login(
    email: 'user@example.com',
    password: 'password123',
  ),
);
```

### Register

```dart
context.read<AuthBloc>().add(
  AuthEvent.register(
    name: 'John Doe',
    email: 'user@example.com',
    password: 'Password123',
    confirmPassword: 'Password123',
    phone: '+1234567890', // optional
  ),
);
```

### Logout

```dart
context.read<AuthBloc>().add(const AuthEvent.logout());
```

### Listen to Auth State

```dart
BlocListener<AuthBloc, AuthState>(
  listenWhen: (previous, current) => previous.status != current.status,
  listener: (context, state) {
    if (state.isAuthenticated) {
      context.router.replace(const HomeRoute());
    } else if (state.isUnauthenticated) {
      context.router.replace(const LoginRoute());
    }
  },
  child: child,
)
```

## Validation Rules

### Login
- Email: Required, valid email format
- Password: Required, minimum 6 characters

### Register
- Name: Required, 2-100 characters
- Email: Required, valid email format
- Password: Required, minimum 8 characters, must contain:
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one number
- Confirm Password: Must match password
- Phone: Optional, 10-15 digits if provided

## AuthState

```dart
AuthState(
  status: AuthStatus.authenticated,  // initial, checking, authenticated, unauthenticated
  isLoading: false,
  user: UserEntity(...),
  accessToken: 'token',
  error: null,
  fieldError: null,  // Field name for validation errors
)
```

## Custom Annotations Used

- `@eventFreezed` - For AuthEvent
- `@stateFreezed` - For AuthState
- `@paramsFreezed` - For LoginCredentials, RegisterCredentials
- `@modelFreezed` - For AuthToken
