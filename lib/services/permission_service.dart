import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle app permissions
@lazySingleton
class PermissionService {
  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request storage permission
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Request photos permission (iOS 14+)
  Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Request location always permission
  Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Request contacts permission
  Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  Future<bool> get hasCameraPermission async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if storage permission is granted
  Future<bool> get hasStoragePermission async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }

  /// Check if photos permission is granted
  Future<bool> get hasPhotosPermission async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  /// Check if location permission is granted
  Future<bool> get hasLocationPermission async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Check if notification permission is granted
  Future<bool> get hasNotificationPermission async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Request multiple permissions at once
  /// Returns true if ALL permissions are granted
  Future<bool> requestMultiplePermissions(List<Permission> permissions) async {
    final statuses = await permissions.request();
    return statuses.values.every((status) => status.isGranted);
  }

  /// Check if permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings (when permission is permanently denied)
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Request permission with dialog explanation
  /// [permission] - Permission to request
  /// [onGranted] - Callback when permission granted
  /// [onDenied] - Callback when permission denied
  /// [onPermanentlyDenied] - Callback when permission permanently denied
  Future<void> requestPermissionWithCallback({
    required Permission permission,
    Function()? onGranted,
    Function()? onDenied,
    Function()? onPermanentlyDenied,
  }) async {
    final status = await permission.status;

    if (status.isGranted) {
      onGranted?.call();
      return;
    }

    if (status.isPermanentlyDenied) {
      onPermanentlyDenied?.call();
      return;
    }

    final result = await permission.request();

    if (result.isGranted) {
      onGranted?.call();
    } else if (result.isPermanentlyDenied) {
      onPermanentlyDenied?.call();
    } else {
      onDenied?.call();
    }
  }

  /// Get permission status
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return await permission.status;
  }

  /// Check if permission is denied
  Future<bool> isPermissionDenied(Permission permission) async {
    final status = await permission.status;
    return status.isDenied;
  }

  /// Check if permission is restricted (iOS only)
  Future<bool> isPermissionRestricted(Permission permission) async {
    final status = await permission.status;
    return status.isRestricted;
  }

  /// Request camera and microphone for video recording
  Future<bool> requestVideoPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  /// Request storage and camera for photo upload
  Future<bool> requestPhotoUploadPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }
}
