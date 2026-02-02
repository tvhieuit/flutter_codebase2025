import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base failure class for domain layer error handling.
@resultFreezed
sealed class Failure with _$Failure {
  const Failure._();

  /// Server-related failures (API errors)
  const factory Failure.server({
    required String message,
    String? code,
    int? statusCode,
  }) = ServerFailure;

  /// Network-related failures (no connection, timeout)
  const factory Failure.network({
    @Default('Network connection failed') String message,
    @Default('NETWORK_ERROR') String? code,
  }) = NetworkFailure;

  /// Cache-related failures (storage errors)
  const factory Failure.cache({
    @Default('Cache operation failed') String message,
    @Default('CACHE_ERROR') String? code,
  }) = CacheFailure;

  /// Validation failures (invalid input)
  const factory Failure.validation({
    required String message,
    @Default('VALIDATION_ERROR') String? code,
    String? field,
  }) = ValidationFailure;

  /// Authentication failures
  const factory Failure.auth({
    required String message,
    @Default('AUTH_ERROR') String? code,
  }) = AuthFailure;

  /// Unknown/unexpected failures
  const factory Failure.unknown({
    @Default('An unexpected error occurred') String message,
    @Default('UNKNOWN_ERROR') String? code,
    Object? exception,
  }) = UnknownFailure;

  /// Factory for common HTTP errors
  factory Failure.fromStatusCode(int statusCode) {
    final message = switch (statusCode) {
      400 => 'Bad request',
      401 => 'Unauthorized',
      403 => 'Forbidden',
      404 => 'Not found',
      408 => 'Request timeout',
      500 => 'Internal server error',
      502 => 'Bad gateway',
      503 => 'Service unavailable',
      _ => 'Unknown server error',
    };

    return Failure.server(
      message: message,
      code: 'HTTP_$statusCode',
      statusCode: statusCode,
    );
  }

  /// Factory for no internet connection
  factory Failure.noConnection() => const Failure.network(
    message: 'No internet connection',
    code: 'NO_CONNECTION',
  );

  /// Factory for connection timeout
  factory Failure.timeout() => const Failure.network(message: 'Connection timed out', code: 'TIMEOUT');

  /// Factory for invalid credentials
  factory Failure.invalidCredentials() => const Failure.auth(
    message: 'Invalid email or password',
    code: 'INVALID_CREDENTIALS',
  );

  /// Factory for token expired
  factory Failure.tokenExpired() => const Failure.auth(
    message: 'Session expired, please login again',
    code: 'TOKEN_EXPIRED',
  );

  /// Factory for required field validation
  factory Failure.required(String fieldName) => Failure.validation(
    message: '$fieldName is required',
    code: 'REQUIRED_FIELD',
    field: fieldName,
  );

  /// Factory for invalid email
  factory Failure.invalidEmail() => const Failure.validation(
    message: 'Invalid email address',
    code: 'INVALID_EMAIL',
    field: 'email',
  );
}
