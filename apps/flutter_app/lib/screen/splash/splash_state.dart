part of 'splash_bloc.dart';

/// State for Splash screen
@stateFreezed
sealed class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    @Default(false) bool isAuthenticated,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState(
    isLoading: true,
    isInitialized: false,
    isAuthenticated: false,
  );
}
