import 'package:injectable/injectable.dart';

import 'package:app_core/app_core.dart';
import 'package:app_core/app_core.dart';
import 'local_storage.dart';
import 'local_storage_keys.dart';

/// Theme mode enum
enum AppThemeMode { light, dark, system }

/// Local repository interface for app settings.
abstract class AppSettingsRepository {
  /// Gets the current theme mode
  Future<Result<AppThemeMode>> getThemeMode();

  /// Sets the theme mode
  Future<Result<void>> setThemeMode(AppThemeMode mode);

  /// Gets the current language code
  Future<Result<String?>> getLanguageCode();

  /// Sets the language code
  Future<Result<void>> setLanguageCode(String code);

  /// Checks if this is the first launch
  Future<Result<bool>> isFirstLaunch();

  /// Sets first launch completed
  Future<Result<void>> setFirstLaunchCompleted();

  /// Checks if onboarding is completed
  Future<Result<bool>> isOnboardingCompleted();

  /// Sets onboarding completed
  Future<Result<void>> setOnboardingCompleted();

  /// Gets push notification enabled status
  Future<Result<bool>> isPushNotificationEnabled();

  /// Sets push notification enabled status
  Future<Result<void>> setPushNotificationEnabled(bool enabled);

  /// Clears all settings
  Future<Result<void>> clearAllSettings();
}

/// Implementation of [AppSettingsRepository] using [LocalStorage].
@LazySingleton(as: AppSettingsRepository)
class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final LocalStorage _storage;

  AppSettingsRepositoryImpl(this._storage);

  @override
  Future<Result<AppThemeMode>> getThemeMode() async {
    try {
      final modeString = await _storage.getString(StorageKeys.themeMode);
      if (modeString == null) return const Result.success(AppThemeMode.system);

      final mode = AppThemeMode.values.firstWhere(
        (e) => e.name == modeString,
        orElse: () => AppThemeMode.system,
      );
      return Result.success(mode);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get theme mode: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setThemeMode(AppThemeMode mode) async {
    try {
      await _storage.setString(StorageKeys.themeMode, mode.name);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to set theme mode: $e'),
      );
    }
  }

  @override
  Future<Result<String?>> getLanguageCode() async {
    try {
      final code = await _storage.getString(StorageKeys.languageCode);
      return Result.success(code);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get language code: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setLanguageCode(String code) async {
    try {
      await _storage.setString(StorageKeys.languageCode, code);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to set language code: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> isFirstLaunch() async {
    try {
      final isFirst = await _storage.getBool(StorageKeys.isFirstLaunch);
      // If null (never set), this is first launch
      return Result.success(isFirst ?? true);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get first launch status: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setFirstLaunchCompleted() async {
    try {
      await _storage.setBool(StorageKeys.isFirstLaunch, false);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to set first launch status: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> isOnboardingCompleted() async {
    try {
      final completed = await _storage.getBool(StorageKeys.onboardingCompleted);
      return Result.success(completed ?? false);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get onboarding status: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setOnboardingCompleted() async {
    try {
      await _storage.setBool(StorageKeys.onboardingCompleted, true);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to set onboarding status: $e'),
      );
    }
  }

  @override
  Future<Result<bool>> isPushNotificationEnabled() async {
    try {
      final enabled = await _storage.getBool(
        StorageKeys.pushNotificationEnabled,
      );
      return Result.success(enabled ?? true); // Default to enabled
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get push notification status: $e'),
      );
    }
  }

  @override
  Future<Result<void>> setPushNotificationEnabled(bool enabled) async {
    try {
      await _storage.setBool(StorageKeys.pushNotificationEnabled, enabled);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to set push notification status: $e'),
      );
    }
  }

  @override
  Future<Result<void>> clearAllSettings() async {
    try {
      await _storage.remove(StorageKeys.themeMode);
      await _storage.remove(StorageKeys.languageCode);
      await _storage.remove(StorageKeys.pushNotificationEnabled);
      // Don't clear first launch and onboarding flags
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to clear settings: $e'),
      );
    }
  }
}
