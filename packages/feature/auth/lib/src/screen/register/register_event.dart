part of 'register_bloc.dart';

/// Events for Register screen
@freezed
sealed class RegisterEvent with _$RegisterEvent {
  /// Event to submit registration
  const factory RegisterEvent.submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) = RegisterEventSubmit;

  /// Event to clear error state
  const factory RegisterEvent.clearError() = RegisterEventClearError;
}
