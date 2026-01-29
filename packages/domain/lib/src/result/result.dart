import 'package:freezed_annotation/freezed_annotation.dart';

import '../annotations/annotations.dart';
import '../failures/failure.dart';

part 'result.freezed.dart';

/// Result type for handling success/failure without exceptions.
///
/// Usage:
/// ```dart
/// Future<Result<UserEntity>> getUser(int id) async {
///   try {
///     final user = await repository.getUserById(id);
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(ServerFailure(message: e.toString()));
///   }
/// }
///
/// // Handling the result
/// final result = await getUser(1);
/// result.when(
///   success: (user) => print('User: ${user.name}'),
///   failure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
@resultFreezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  const factory Result.success(T data) = ResultSuccess<T>;

  const factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Returns true if this is a success result
  bool get isSuccess => this is ResultSuccess<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is ResultFailure<T>;

  /// Gets the data if success, otherwise returns null
  T? get data => switch (this) {
    ResultSuccess(:final data) => data,
    ResultFailure() => null,
  };

  /// Alias for [data] - Gets the data if success, otherwise returns null
  T? get dataOrNull => data;

  /// Gets the failure if failure, otherwise returns null
  Failure? get failureOrNull => whenOrNull(failure: (failure) => failure);

  /// Gets the data if success, otherwise throws the failure
  T get dataOrThrow => when(
    success: (data) => data,
    failure: (failure) => throw Exception(failure.message),
  );

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T data) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Flat maps the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return when(
      success: (data) => mapper(data),
      failure: (failure) => Result.failure(failure),
    );
  }
}
