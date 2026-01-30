part of 'splash_bloc.dart';

@eventFreezed
sealed class SplashEvent with _$SplashEvent {
  const factory SplashEvent.started() = _Started;
}
