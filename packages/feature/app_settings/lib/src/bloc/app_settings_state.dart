part of 'app_settings_bloc.dart';

@stateFreezed
sealed class AppSettingsState with _$AppSettingsState {
  const AppSettingsState._();

  const factory AppSettingsState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    Locale? locale,
  }) = _AppSettingsState;

  factory AppSettingsState.initial() => const AppSettingsState();
}
