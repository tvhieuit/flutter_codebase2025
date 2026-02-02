import 'package:flutter/material.dart';

enum AppDialogType { info, success, warning, danger }

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryActionText;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final AppDialogType type;
  final Widget? content;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.type = AppDialogType.info,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],
            const SizedBox(height: 24),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case AppDialogType.success:
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case AppDialogType.warning:
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case AppDialogType.danger:
        icon = Icons.error_outline_rounded;
        color = Theme.of(context).colorScheme.error;
        break;
      case AppDialogType.info:
        icon = Icons.info_outline_rounded;
        color = Theme.of(context).colorScheme.primary;
        break;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (secondaryActionText != null)
          TextButton(
            onPressed: onSecondaryAction ?? () => Navigator.of(context).pop(),
            child: Text(secondaryActionText!),
          ),
        if (primaryActionText != null) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onPrimaryAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getPrimaryColor(context),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(primaryActionText!),
          ),
        ],
      ],
    );
  }

  Color _getPrimaryColor(BuildContext context) {
    switch (type) {
      case AppDialogType.success:
        return Colors.green;
      case AppDialogType.warning:
        return Colors.orange;
      case AppDialogType.danger:
        return Theme.of(context).colorScheme.error;
      case AppDialogType.info:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  /// Static helper to show the dialog
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    AppDialogType type = AppDialogType.info,
    Widget? content,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        primaryActionText: primaryActionText,
        onPrimaryAction: onPrimaryAction,
        secondaryActionText: secondaryActionText,
        onSecondaryAction: onSecondaryAction,
        type: type,
        content: content,
      ),
    );
  }
}
