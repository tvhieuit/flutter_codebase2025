part of 'splash_bloc.dart';

@freezed
sealed class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({
    @Default(false) bool isLoading,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState();
}
