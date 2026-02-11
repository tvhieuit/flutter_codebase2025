import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:use_cases/use_cases.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Use case for saving the theme mode to local storage.
@injectable
class SetThemeModeUseCase implements UseCaseWithParams<void, ThemeMode> {
  static const String _themeModeKey = 'feature_app_settings.theme_mode';

  final LocalStorage _localStorage;

  SetThemeModeUseCase(this._localStorage);

  @override
  Future<Result<void>> call(ThemeMode themeMode) async {
    final value = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _localStorage.setString(_themeModeKey, value);
    return const Result.success(null);
  }
}
