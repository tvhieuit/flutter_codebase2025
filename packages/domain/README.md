# Domain Package

The domain layer of the application following Clean Architecture principles with custom Freezed annotations.

## Overview

This package contains pure Dart code with Freezed for immutability and code generation.
It defines the core business logic of the application.

## Custom Freezed Annotations

Located in `lib/src/annotations/annotations.dart`:

```dart
// For Events - minimal generation
@eventFreezed  // copyWith: false, equal: false, fromJson: false, toJson: false

// For States - with copyWith only
@stateFreezed  // copyWith: true, equal: false, fromJson: false, toJson: false

// For Models/Entities - with JSON serialization
@modelFreezed  // copyWith: false, equal: false, fromJson: true, toJson: true

// For Result/Failure types
@resultFreezed // copyWith: false, equal: false, fromJson: false, toJson: false

// For Use Case Parameters
@paramsFreezed // copyWith: false, equal: false, fromJson: false, toJson: false
```

## Structure

```
lib/
├── domain.dart              # Main library export
└── src/
    ├── annotations/         # Custom Freezed annotations
    │   └── annotations.dart
    ├── entities/            # @modelFreezed entities
    │   ├── user_entity.dart
    │   └── product_entity.dart
    ├── failures/            # @resultFreezed failures
    │   └── failure.dart
    ├── repositories/        # Repository interfaces
    │   ├── user_repository.dart
    │   └── product_repository.dart
    ├── result/              # @resultFreezed Result type
    │   └── result.dart
    └── use_cases/           # @paramsFreezed params
        ├── base_use_case.dart
        ├── user/
        └── product/
```

## Usage Examples

### Entities (@modelFreezed)

```dart
import 'package:domain/domain.dart';

// With JSON serialization (fromJson/toJson)
final user = UserEntity(
  id: 1,
  name: 'John Doe',
  email: 'john@example.com',
);

// From JSON
final userFromJson = UserEntity.fromJson(json);

// To JSON
final json = user.toJson();

// Business logic methods
print(user.hasValidEmail); // true
```

### Failures (@resultFreezed)

```dart
import 'package:domain/domain.dart';

// Create failures
final serverError = Failure.server(message: 'Server error', statusCode: 500);
final networkError = Failure.noConnection();
final validationError = Failure.required('Email');

// Pattern matching
failure.when(
  server: (msg, code, status) => handleServer(),
  network: (msg, code) => handleNetwork(),
  validation: (msg, code, field) => handleValidation(),
  cache: (msg, code) => handleCache(),
  auth: (msg, code) => handleAuth(),
  unknown: (msg, code, ex) => handleUnknown(),
);
```

### Result (@resultFreezed)

```dart
import 'package:domain/domain.dart';

// Pattern matching
result.when(
  success: (user) => print('User: ${user.name}'),
  failure: (failure) => print('Error: ${failure.message}'),
);

// Convenience methods
print(result.isSuccess);
print(result.dataOrNull);
print(result.failureOrNull);

// Mapping
final nameResult = result.map((user) => user.name);
```

### Use Case Params (@paramsFreezed)

```dart
import 'package:domain/domain.dart';

// Immutable params - no copyWith, no JSON
final params = GetUsersParams(page: 1, limit: 20);

// Use with use case
final result = await getUsersUseCase(params);
```

## Usage in BLoCs

### Event (@eventFreezed)

```dart
@eventFreezed
sealed class UserEvent with _$UserEvent {
  const factory UserEvent.started() = _Started;
  const factory UserEvent.loadUser(int id) = _LoadUser;
}
```

### State (@stateFreezed)

```dart
@stateFreezed
sealed class UserState with _$UserState {
  const factory UserState({
    @Default(false) bool isLoading,
    UserEntity? user,
    String? error,
  }) = _UserState;

  factory UserState.initial() => const UserState();
}
```

### BLoC Implementation

```dart
@injectable
class UserBloc extends Bloc<UserEvent, UserState> with SafetyNetworkMixin {
  final GetUserUseCase _getUserUseCase;

  UserBloc(this._getUserUseCase) : super(UserState.initial()) {
    on(_onLoadUser);
  }

  Future<void> _onLoadUser(_LoadUser event, emit) async {
    await safeNetworkCall(() async {
      emit(state.copyWith(isLoading: true));
      
      final result = await _getUserUseCase(event.id);
      
      result.when(
        success: (user) => emit(state.copyWith(
          user: user,
          isLoading: false,
        )),
        failure: (failure) => emit(state.copyWith(
          error: failure.message,
          isLoading: false,
        )),
      );
    });
  }
}
```

## Code Generation

After modifying any `@freezed` classes, run:

```bash
fvm dart run melos run brd
```

## Key Principles

1. **Custom annotations**: Use appropriate annotation for each type
2. **Minimal generation**: Only generate what's needed
3. **Pattern matching**: Use `when`/`maybeWhen` for type-safe handling
4. **Result type**: No exceptions, use `Result<T>` for error handling
5. **Immutability**: All objects are immutable
