part of 'splash_bloc.dart';

/// State for Splash screen
@freezed
class SplashState with _$SplashState {
  const factory SplashState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default(false) bool isAuthenticated,
    String? error,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState(
    isLoading: true,
    isInitialized: false,
    isAuthenticated: false,
  );
}
