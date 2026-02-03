export 'app_settings_localizations.dart';

import 'package:flutter/widgets.dart';
import 'app_settings_localizations.dart';

/// Extension to easily access AppSettingsLocalizations from BuildContext
extension AppSettingsLocalizationsX on BuildContext {
  /// Get AppSettingsLocalizations instance from context
  AppSettingsLocalizations get settingsL10n => AppSettingsLocalizations.of(this);
}
