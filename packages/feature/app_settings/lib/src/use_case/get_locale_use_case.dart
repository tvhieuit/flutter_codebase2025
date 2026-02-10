import 'dart:ui';

import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Use case for getting the stored locale from local storage.
///
/// Returns `null` to follow system locale.
@injectable
class GetLocaleUseCase implements UseCase<Locale?> {
  static const String _localeKey = 'feature_app_settings.locale';

  final LocalStorage _localStorage;

  GetLocaleUseCase(this._localStorage);

  @override
  Future<Result<Locale?>> call() async {
    final value = await _localStorage.getString(_localeKey);
    if (value == null || value.isEmpty) {
      return const Result.success(null);
    }
    return Result.success(Locale(value));
  }
}
