part of 'login_bloc.dart';

/// State for Login screen
@freezed
sealed class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState();

  /// Whether there is an error
  bool get hasError => error != null;
}
