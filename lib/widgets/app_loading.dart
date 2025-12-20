import 'package:flutter/material.dart';

import '../app/app_router.dart';

/// Global loading overlay widget
/// 
/// Usage:
/// ```dart
/// // Show loading
/// AppLoading.show();
/// 
/// // Hide loading
/// AppLoading.hide();
/// 
/// // Multiple tasks
/// AppLoading.show(); // Task 1
/// AppLoading.show(); // Task 2
/// AppLoading.hide(); // Task 1 done
/// AppLoading.hide(); // Task 2 done - loading hidden
/// 
/// // Force hide
/// AppLoading.hide(force: true);
/// ```
class AppLoading {
  static int _numberOfTask = 0;
  static OverlayEntry? _currentLoader;

  AppLoading._();

  /// Show loading overlay
  /// Supports multiple concurrent tasks
  static void show({
    Color? backgroundColor,
    Widget? loadingWidget,
  }) {
    if (_numberOfTask <= 0) {
      _currentLoader ??= OverlayEntry(
        builder: (context) => PopScope(
          canPop: false,
          child: Container(
            color: backgroundColor ?? const Color.fromRGBO(0, 0, 0, 0.5),
            alignment: Alignment.center,
            child: loadingWidget ??
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      );
      rootNavigatorKey.currentState?.overlay?.insert(_currentLoader!);
      _numberOfTask = 0;
    }
    _numberOfTask++;
  }

  /// Hide loading overlay
  /// [force] - Force hide even if there are pending tasks
  static void hide({bool force = false}) {
    _numberOfTask--;
    if (_numberOfTask <= 0 || force) {
      _numberOfTask = 0;
      _currentLoader?.remove();
      _currentLoader = null;
    }
  }

  /// Toggle loading based on boolean value
  /// 
  /// Usage:
  /// ```dart
  /// AppLoading.loading(isLoading);
  /// ```
  static void loading(bool isLoading) => isLoading ? show() : hide();

  /// Show loading with custom widget
  static void showCustom({
    required Widget child,
    Color? backgroundColor,
  }) {
    show(
      backgroundColor: backgroundColor,
      loadingWidget: child,
    );
  }

  /// Check if loading is currently showing
  static bool get isShowing => _currentLoader != null;

  /// Get number of pending tasks
  static int get pendingTasks => _numberOfTask;
}

/// Loading widget with Lottie animation (if available)
class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

