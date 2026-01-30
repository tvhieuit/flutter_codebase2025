import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Module for third-party dependencies (app-level only)
///
/// Note: SharedPreferencesAsync is registered by domain package's DomainModule
@module
abstract class DiModule {
  /// Dio instance for network calls
  @lazySingleton
  GlobalKey<NavigatorState> get rootNavigatorKey => GlobalKey<NavigatorState>();

  @lazySingleton
  BuildContext globalContext(GlobalKey<NavigatorState> rootNavigatorKey) {
    return rootNavigatorKey.currentContext ?? (throw Exception('Navigator context is not available'));
  }

  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => GlobalKey<ScaffoldMessengerState>();
}
