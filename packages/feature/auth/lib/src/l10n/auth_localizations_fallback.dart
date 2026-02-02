import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'auth_localizations.dart';
import 'auth_localizations_en.dart';

/// A non-generated delegate that always falls back to English (`en`).
///
/// Use this instead of the generated [AuthLocalizations.delegate] when the app
/// can run in locales that the auth package doesn't provide translations for.
class AuthLocalizationsFallback {
  const AuthLocalizationsFallback._();

  static const LocalizationsDelegate<AuthLocalizations> delegate =
      _AuthLocalizationsFallbackDelegate();
}

class _AuthLocalizationsFallbackDelegate
    extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AuthLocalizations> load(Locale locale) async {
    if (AuthLocalizations.delegate.isSupported(locale)) {
      try {
        return await AuthLocalizations.delegate.load(locale);
      } catch (_) {
        // If the generated delegate fails for any reason, fall back to English.
      }
    }

    return SynchronousFuture<AuthLocalizations>(AuthLocalizationsEn());
  }

  @override
  bool shouldReload(LocalizationsDelegate<AuthLocalizations> old) => false;
}

