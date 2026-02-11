import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:use_cases/use_cases.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Use case for getting the current theme mode from local storage.
@injectable
class GetThemeModeUseCase implements UseCase<ThemeMode> {
  static const String _themeModeKey = 'feature_app_settings.theme_mode';

  final LocalStorage _localStorage;

  GetThemeModeUseCase(this._localStorage);

  @override
  Future<Result<ThemeMode>> call() async {
    final value = await _localStorage.getString(_themeModeKey);
    final themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return Result.success(themeMode);
  }
}
