export 'auth_localizations.dart';

import 'package:flutter/widgets.dart';

import 'auth_localizations.dart';

/// Extension to easily access AuthLocalizations from BuildContext
extension AuthLocalizationsX on BuildContext {
  /// Get AuthLocalizations instance from context
  AuthLocalizations get authL10n => AuthLocalizations.of(this);
}
