import 'package:flutter/material.dart';

/// Button with built-in loading state
class AppLoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppLoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? Colors.white,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}

/// Text button with built-in loading state
class AppLoadingTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? foregroundColor;

  const AppLoadingTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
      ),
      child: isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? Theme.of(context).primaryColor,
                ),
              ),
            )
          : child,
    );
  }
}

/// Icon button with built-in loading state
class AppLoadingIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final bool isLoading;
  final Color? color;

  const AppLoadingIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? Theme.of(context).primaryColor,
                ),
              ),
            )
          : icon,
      color: color,
    );
  }
}

