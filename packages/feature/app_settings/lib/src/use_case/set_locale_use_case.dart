import 'dart:ui';

import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:use_cases/use_cases.dart';
import 'package:injectable/injectable.dart';

/// Use case for saving the locale to local storage.
///
/// Pass `null` to follow system locale.
@injectable
class SetLocaleUseCase implements UseCaseWithParams<void, Locale?> {
  static const String _localeKey = 'feature_app_settings.locale';

  final LocalStorage _localStorage;

  SetLocaleUseCase(this._localStorage);

  @override
  Future<Result<void>> call(Locale? locale) async {
    if (locale == null) {
      await _localStorage.setString(_localeKey, '');
      return const Result.success(null);
    }
    await _localStorage.setString(_localeKey, locale.languageCode);
    return const Result.success(null);
  }
}
