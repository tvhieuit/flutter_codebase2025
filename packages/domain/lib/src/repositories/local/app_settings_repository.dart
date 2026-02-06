import 'package:app_core/app_core.dart';

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
