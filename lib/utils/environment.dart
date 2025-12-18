import 'package:flutter/foundation.dart';

class Environment {
  Environment._();

  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String _apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  static String get apiBaseUrl => _apiBaseUrl;
  static String get apiKey => _apiKey;
  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  static bool get isProfile => kProfileMode;
}

