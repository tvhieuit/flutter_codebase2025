part of 'app_settings_bloc.dart';

@eventFreezed
sealed class AppSettingsEvent with _$AppSettingsEvent {
  const factory AppSettingsEvent.started() = _Started;

  const factory AppSettingsEvent.themeModeChanged({
    required ThemeMode themeMode,
  }) = _ThemeModeChanged;

  const factory AppSettingsEvent.localeChanged({required Locale? locale}) =
      _LocaleChanged;
}
