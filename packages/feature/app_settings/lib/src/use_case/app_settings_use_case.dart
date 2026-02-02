import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class AppSettingsUseCase {
  Future<Result<ThemeMode>> getThemeMode();
  Future<Result<void>> setThemeMode(ThemeMode themeMode);

  /// Returns forced locale, or `null` to follow system locale.
  Future<Result<Locale?>> getLocale();
  Future<Result<void>> setLocale(Locale? locale);
}

@Injectable(as: AppSettingsUseCase)
class AppSettingsUseCaseImpl implements AppSettingsUseCase {
  static const String _themeModeKey = 'feature_app_settings.theme_mode';
  static const String _localeKey = 'feature_app_settings.locale';

  final LocalStorage _localStorage;

  AppSettingsUseCaseImpl(this._localStorage);

  @override
  Future<Result<ThemeMode>> getThemeMode() async {
    try {
      final value = await _localStorage.getString(_themeModeKey);
      final themeMode = switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      return Result.success(themeMode);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setThemeMode(ThemeMode themeMode) async {
    try {
      final value = switch (themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await _localStorage.setString(_themeModeKey, value);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Locale?>> getLocale() async {
    try {
      final value = await _localStorage.getString(_localeKey);
      if (value == null || value.isEmpty) {
        return const Result.success(null);
      }
      return Result.success(Locale(value));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setLocale(Locale? locale) async {
    try {
      if (locale == null) {
        await _localStorage.setString(_localeKey, '');
        return const Result.success(null);
      }
      await _localStorage.setString(_localeKey, locale.languageCode);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
