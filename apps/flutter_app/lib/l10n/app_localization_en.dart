// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Flutter App';

  @override
  String get welcome => 'Welcome';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get updateUser => 'Update User';

  @override
  String get userName => 'Name';

  @override
  String get userEmail => 'Email';

  @override
  String get update => 'Update';

  @override
  String get deleteUser => 'Delete User';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this user?';

  @override
  String get userDetails => 'User Details';

  @override
  String get userPhone => 'Phone';

  @override
  String get userCreated => 'Created';

  @override
  String get close => 'Close';

  @override
  String get userList => 'User List';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get reload => 'Reload';

  @override
  String get unknown => 'Unknown';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get allow => 'Allow';

  @override
  String get permissionPermanentlyDenied => 'Permission is permanently denied. Please enable it in app settings.';

  @override
  String get cameraPermissionTitle => 'Camera Permission';

  @override
  String get cameraPermissionMessage => 'This app needs camera access to take photos.';

  @override
  String get cameraPermissionSettings =>
      'Camera permission is permanently denied. Please enable it in settings to use this feature.';

  @override
  String get storagePermissionTitle => 'Storage Permission';

  @override
  String get storagePermissionMessage => 'This app needs storage access to save files.';

  @override
  String get storagePermissionSettings => 'Storage permission is permanently denied. Please enable it in settings.';

  @override
  String get locationPermissionTitle => 'Location Permission';

  @override
  String get locationPermissionMessage => 'This app needs location access to show nearby places.';

  @override
  String get locationPermissionSettings => 'Location permission is permanently denied. Please enable it in settings.';

  @override
  String get notificationPermissionTitle => 'Notification Permission';

  @override
  String get notificationPermissionMessage => 'This app needs notification permission to send you updates.';

  @override
  String get notificationPermissionSettings =>
      'Notification permission is permanently denied. Please enable it in settings.';
}
