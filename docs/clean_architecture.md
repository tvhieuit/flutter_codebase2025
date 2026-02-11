# Clean Architecture Rules

## ❌ NEVER INJECT - Repository Directly in BLoCs

```dart
// ❌ WRONG - Direct repository injection violates Clean Architecture
@injectable
class MyBloc extends Bloc<MyEvent, MyState> with SafetyNetworkMixin {
  final MyRepository _repository; // VIOLATION - Skip Use Case layer
}
```

## ✅ ALWAYS INJECT - Use Cases in BLoCs

```dart
// ✅ CORRECT - Use Case injection follows Clean Architecture
@injectable
class MyBloc extends Bloc<MyEvent, MyState> with SafetyNetworkMixin {
  final MyUseCase _useCase; // CORRECT - Use Case layer
}
```

## Layer Dependencies

### Presentation Layer (BLoCs)
- ✅ CAN depend on: Use Cases
- ❌ CANNOT depend on: Repositories, Data Sources

### Business Logic Layer (Use Cases)
- ✅ CAN depend on: Repository Interfaces
- ❌ CANNOT depend on: BLoCs, UI, Data Sources directly

### Data Layer (Repository Implementations)
- **Location**: `packages/data/`
- ✅ CAN depend on: Domain interfaces, Data Sources (Dio, SharedPreferences)
- ❌ CANNOT depend on: BLoCs, Use Cases

### Domain Layer (Pure Business Logic)
- **Location**: `packages/domain/`
- Contains: Entities and Repository Interfaces ONLY
- ❌ CANNOT depend on: Dio, SharedPreferences, or any infrastructure
- ❌ CANNOT depend on: Use Cases (Use cases are now in their own package)

## Dependency Injection Requirements

### BLoC Registration
```dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc(this._loginUseCase) : super(AuthState.initial());
}
```

### Use Case Registration (in `packages/use_cases/`)
```dart
@injectable
class LoginUseCase implements UseCaseWithParams<AuthToken, AuthCredentials> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<Result<AuthToken>> call(AuthCredentials params) async {
    return await _authRepository.login(params);
  }
}
```

### Repository Interface (in `packages/domain/`)
```dart
abstract class AuthRepository {
  Future<Result<AuthToken>> login({required String email, required String password});
}
```

### Repository Implementation (in `packages/data/`)
```dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Result<AuthToken>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return Result.success(AuthToken.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    }
  }
}
```

## Package Responsibilities

| Package | Contains | Does NOT contain |
|---------|----------|------------------|
| `domain` | Entities, Repository Interfaces | Use Cases, Dio, SharedPreferences |
| `use_cases` | Core Business Use Cases | UI, Dio, SharedPreferences |
| `data` | Repository Implementations, Network (Dio), Storage (SharedPrefs) | BLoCs, Use Cases, UI |
| `feature/*` | BLoCs, Pages, Feature-specific Use Cases | Repository implementations |
| `app_core` | Result, Failure, Annotations, Base Services | Business logic |

## Summary

### ✅ MUST DO
- Inject Use Cases in BLoCs
- Implement abstract interfaces for all layers
- Use @injectable, @lazySingleton annotations
- Handle errors at appropriate layers
- Keep repository interfaces in `domain`, implementations in `data`

### ❌ NEVER DO
- Inject Repositories directly in BLoCs
- Skip abstract interfaces
- Mix presentation logic with business logic
- Put infrastructure dependencies (Dio, SharedPreferences) in domain

### 🎯 Architecture Goals
- Separation of concerns
- Testability
- Maintainability
- Clean dependencies flow

