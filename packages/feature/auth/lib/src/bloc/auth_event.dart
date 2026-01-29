import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Authentication events
@eventFreezed
sealed class AuthEvent with _$AuthEvent {
  /// Check initial authentication status
  const factory AuthEvent.checkAuth() = _CheckAuth;

  /// Login with email and password
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = _Login;

  /// Register new user
  const factory AuthEvent.register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = _Register;

  /// Logout current user
  const factory AuthEvent.logout() = _Logout;

  /// Clear error message
  const factory AuthEvent.clearError() = _ClearError;
}
