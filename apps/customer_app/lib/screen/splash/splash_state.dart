part of 'splash_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

@freezed
sealed class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({
    @Default(false) bool isLoading,
    @Default(AuthStatus.unknown) AuthStatus authStatus,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState();
}
