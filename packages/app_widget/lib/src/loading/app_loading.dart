import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum AppLoadingSize { small, medium, large }

@singleton
class AppLoading {
  const AppLoading(this._globalKey);

  final GlobalKey<NavigatorState> _globalKey;

  static OverlayEntry? _overlayEntry;

  /// Helper to show as an overlay
  void show({String? message}) {
    if (_overlayEntry != null) {
      return;
    }
    final overlayContext = _globalKey.currentState?.overlay?.context;
    if (overlayContext == null) {
      return;
    }
    final overlay = Overlay.maybeOf(overlayContext) ?? Navigator.maybeOf(overlayContext)?.overlay;

    if (overlay == null) {
      debugPrint('AppLoading: No Overlay found in the given context.');
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => AppLoadingView(
        isOverlay: true,
        message: message,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  /// Helper to hide the overlay
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
    this.isOverlay = false,
    this.message,
  });

  final AppLoadingSize size;
  final Color? color;
  final bool isOverlay;
  final String? message;

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

    final Widget content = Column(
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

    return content;
  }
}
