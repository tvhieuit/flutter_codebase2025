import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/app_router.gr.dart';
import 'package:permission_handler/permission_handler.dart';

import '../di/injection.dart';
import '../extensions/l10n_extension.dart';
import '../services/permission_service.dart';

/// Dialog page for permission request
@RoutePage()
class PermissionDialogPage extends StatelessWidget {
  final String title;
  final String message;
  final bool isSettingsDialog;

  const PermissionDialogPage({
    super.key,
    required this.title,
    required this.message,
    this.isSettingsDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.router.pop(false),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.router.pop(true),
                child: Text(isSettingsDialog ? 'Open Settings' : 'Allow'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper class to show permission dialogs using auto_route
class PermissionDialog {
  static Future<bool> show({
    required BuildContext context,
    required Permission permission,
    required String title,
    required String message,
    String? settingsMessage,
  }) async {
    final permissionService = getIt<PermissionService>();

    // Check if already granted
    final status = await permissionService.getPermissionStatus(permission);
    if (status.isGranted) {
      return true;
    }

    // If permanently denied, show settings dialog
    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context: context,
        title: title,
        message: settingsMessage ?? 'Permission is permanently denied. Please enable it in app settings.',
      );
    }

    // Show request dialog using auto_route
    final result = await context.router.push<bool>(
      PermissionDialogRoute(
        title: title,
        message: message,
        isSettingsDialog: false,
      ),
    );

    if (result == true) {
      final granted = await permission.request();
      return granted.isGranted;
    }

    return false;
  }

  static Future<bool> _showSettingsDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    // Show settings dialog using auto_route
    final result = await context.router.push<bool>(
      PermissionDialogRoute(
        title: title,
        message: message,
        isSettingsDialog: true,
      ),
    );

    if (result == true) {
      return await openAppSettings();
    }

    return false;
  }

  /// Show camera permission dialog
  static Future<bool> showCameraPermission(BuildContext context) {
    return show(
      context: context,
      permission: Permission.camera,
      title: 'Camera Permission',
      message: 'This app needs camera access to take photos.',
      settingsMessage: 'Camera permission is permanently denied. Please enable it in settings to use this feature.',
    );
  }

  /// Show storage permission dialog
  static Future<bool> showStoragePermission(BuildContext context) {
    return show(
      context: context,
      permission: Permission.storage,
      title: 'Storage Permission',
      message: 'This app needs storage access to save files.',
      settingsMessage: 'Storage permission is permanently denied. Please enable it in settings.',
    );
  }

  /// Show location permission dialog
  static Future<bool> showLocationPermission(BuildContext context) {
    return show(
      context: context,
      permission: Permission.location,
      title: 'Location Permission',
      message: 'This app needs location access to show nearby places.',
      settingsMessage: 'Location permission is permanently denied. Please enable it in settings.',
    );
  }

  /// Show notification permission dialog
  static Future<bool> showNotificationPermission(BuildContext context) {
    return show(
      context: context,
      permission: Permission.notification,
      title: 'Notification Permission',
      message: 'This app needs notification permission to send you updates.',
      settingsMessage: 'Notification permission is permanently denied. Please enable it in settings.',
    );
  }
}
