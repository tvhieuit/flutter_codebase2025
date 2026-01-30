part of 'register_bloc.dart';

/// State for Register screen
@stateFreezed
sealed class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _RegisterState;

  factory RegisterState.initial() => const RegisterState();
}
