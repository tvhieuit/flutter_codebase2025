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

### Data Layer (Repositories)
- ✅ CAN depend on: Data Sources, External APIs
- ❌ CANNOT depend on: BLoCs, Use Cases

## Dependency Injection Requirements

### BLoC Registration
```dart
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> with SafetyNetworkMixin {
  final AuthUseCase _authUseCase;
  
  AuthBloc(this._authUseCase) : super(AuthState.initial());
}
```

### Use Case Registration
```dart
abstract class AuthUseCase {
  Future<UserEntity> login(String email, String password);
}

@Injectable(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  final RemoteRepository _remoteRepository;
  
  AuthUseCaseImpl(this._remoteRepository);
  
  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _remoteRepository.login(email, password);
    return UserEntity.fromResponse(response);
  }
}
```

### Repository Registration
```dart
abstract class RemoteRepository {
  Future<LoginResponse> login(String email, String password);
}

@Injectable(as: RemoteRepository)
class RemoteRepositoryImpl implements RemoteRepository {
  final Dio _dio;
  
  RemoteRepositoryImpl(this._dio);
  
  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return LoginResponse.fromJson(response.data);
  }
}
```

## Summary

### ✅ MUST DO
- Inject Use Cases in BLoCs
- Implement abstract interfaces for all layers
- Use @injectable, @lazySingleton annotations
- Handle errors at appropriate layers

### ❌ NEVER DO
- Inject Repositories directly in BLoCs
- Skip abstract interfaces
- Mix presentation logic with business logic

### 🎯 Architecture Goals
- Separation of concerns
- Testability
- Maintainability
- Clean dependencies flow

