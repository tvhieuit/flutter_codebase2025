part of 'register_bloc.dart';

/// Events for Register screen
@eventFreezed
sealed class RegisterEvent with _$RegisterEvent {
  /// Event to submit registration
  const factory RegisterEvent.submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = RegisterEventSubmit;

  const factory RegisterEvent.login() = _RegisterEventLogin;
  const factory RegisterEvent.obscurePasswordToggle() =
      _RegisterEventObscurePasswordToggle;
  const factory RegisterEvent.obscureConfirmPasswordToggle() =
      _RegisterEventObscureConfirmPasswordToggle;
}
