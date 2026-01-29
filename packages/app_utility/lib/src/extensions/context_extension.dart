import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  /// Access the current [ThemeData]
  ThemeData get theme => Theme.of(this);

  /// Access the current [TextTheme]
  TextTheme get textTheme => theme.textTheme;

  /// Access the current [ColorScheme]
  ColorScheme get colorScheme => theme.colorScheme;

  /// Access the current [MediaQueryData]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Screen width
  double get screenWidth => mediaQuery.size.width;

  /// Screen height
  double get screenHeight => mediaQuery.size.height;

  /// Top padding (status bar height)
  double get topPadding => mediaQuery.padding.top;

  /// Bottom padding (navigation bar / home indicator)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Whether the device is in landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Whether the keyboard is visible
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;

  /// Unfocus the current focus node (dismiss keyboard)
  void unfocus() => FocusScope.of(this).unfocus();

  /// Show a [SnackBar] with a message
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration ?? const Duration(seconds: 2)),
    );
  }
}
