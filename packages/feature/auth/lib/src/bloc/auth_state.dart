import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Authentication status
enum AuthStatus {
  /// Initial state, checking authentication
  initial,

  /// Currently checking auth status
  checking,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,
}

/// Authentication state
@stateFreezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    @Default(false) bool isLoading,
    UserEntity? user,
    String? accessToken,
    String? error,
    String? fieldError,
  }) = _AuthState;

  /// Initial state
  factory AuthState.initial() => const AuthState();

  /// Checks if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Checks if user is unauthenticated
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  /// Checks if currently checking auth
  bool get isChecking => status == AuthStatus.checking;

  /// Checks if there's an error
  bool get hasError => error != null && error!.isNotEmpty;
}
