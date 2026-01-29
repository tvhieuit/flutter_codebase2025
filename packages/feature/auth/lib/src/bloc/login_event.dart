part of 'login_bloc.dart';

/// Events for Login screen
@freezed
sealed class LoginEvent with _$LoginEvent {
  /// Event to submit login credentials
  const factory LoginEvent.submit({
    required String email,
    required String password,
  }) = LoginEventSubmit;

  /// Event to clear error state
  const factory LoginEvent.clearError() = LoginEventClearError;
}
