import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// Lightweight log helper that only prints in debug mode
class Log {
  Log._();

  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      dev.log(message, name: tag ?? 'DEBUG');
    }
  }

  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      dev.log(message, name: tag ?? 'INFO');
    }
  }

  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      dev.log('\u26A0 $message', name: tag ?? 'WARN');
    }
  }

  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      dev.log(message, name: tag ?? 'ERROR', error: error, stackTrace: stackTrace);
    }
  }
}
