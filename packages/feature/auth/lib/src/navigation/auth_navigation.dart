/// Navigation interface for auth feature.
///
/// Implement this in your main app and register with GetIt.
/// This decouples auth package from main app's routing.
abstract class AuthNavigation {
  /// Navigate to register screen
  void goToRegister();

  /// Navigate to login screen
  void goToLogin();

  /// Navigate to home/main screen after successful auth
  void goToHome();

  /// Navigate to forgot password screen
  void goToForgotPassword();

  /// Pop back to previous screen
  void goBack();
}
