part of 'register_bloc.dart';

/// State for Register screen
@freezed
sealed class RegisterState with _$RegisterState {
  const RegisterState._();

  const factory RegisterState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    AuthToken? token,
    String? error,
    String? fieldError,
  }) = _RegisterState;

  factory RegisterState.initial() => const RegisterState();

  /// Whether there is an error
  bool get hasError => error != null;
}
