part of 'splash_bloc.dart';

/// Events for Splash screen
@freezed
class SplashEvent with _$SplashEvent {
  /// Event to start splash screen initialization
  const factory SplashEvent.start() = SplashEventStart;

  /// Event to check authentication status
  const factory SplashEvent.checkAuth() = SplashEventCheckAuth;

  /// Event to navigate to next screen
  const factory SplashEvent.navigate() = SplashEventNavigate;
}
