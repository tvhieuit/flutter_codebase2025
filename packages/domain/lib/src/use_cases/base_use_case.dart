import '../result/result.dart';

/// Base use case interface for use cases without parameters.
///
/// Example:
/// ```dart
/// class GetCurrentUserUseCase implements UseCase<UserEntity> {
///   @override
///   Future<Result<UserEntity>> call() async {
///     return await repository.getCurrentUser();
///   }
/// }
/// ```
abstract class UseCase<T> {
  Future<Result<T>> call();
}

/// Base use case interface for use cases with parameters.
///
/// Example:
/// ```dart
/// class GetUserByIdUseCase implements UseCaseWithParams<UserEntity, int> {
///   @override
///   Future<Result<UserEntity>> call(int userId) async {
///     return await repository.getUserById(userId);
///   }
/// }
/// ```
abstract class UseCaseWithParams<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Base use case interface for stream-based use cases.
///
/// Useful for real-time data like notifications or chat messages.
abstract class StreamUseCase<T> {
  Stream<Result<T>> call();
}

/// Base use case interface for stream-based use cases with parameters.
abstract class StreamUseCaseWithParams<T, Params> {
  Stream<Result<T>> call(Params params);
}

/// No parameters marker class.
///
/// Use when a UseCaseWithParams doesn't need any parameters
/// but you want consistent API.
class NoParams {
  const NoParams();
}
