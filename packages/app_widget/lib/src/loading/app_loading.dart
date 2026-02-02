import 'package:flutter/material.dart';

enum AppLoadingSize { small, medium, large }

class AppLoading extends StatelessWidget {
  final AppLoadingSize size;
  final Color? color;
  final bool isOverlay;
  final String? message;

  const AppLoading({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
    this.isOverlay = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    double indicatorSize;
    switch (size) {
      case AppLoadingSize.small:
        indicatorSize = 20.0;
        break;
      case AppLoadingSize.medium:
        indicatorSize = 36.0;
        break;
      case AppLoadingSize.large:
        indicatorSize = 56.0;
        break;
    }

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            strokeWidth: size == AppLoadingSize.small ? 2.0 : 4.0,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: effectiveColor,
            ),
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: content,
          ),
        ),
      );
    }

    return Center(child: content);
  }

  /// Helper to show as a dialog
  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AppLoading(
          isOverlay: true,
          message: message,
        ),
      ),
    );
  }

  /// Helper to hide the dialog
  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
