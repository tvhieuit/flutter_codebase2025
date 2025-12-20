# Services Documentation

## Available Services

### 1. NetworkService

Service to check network connectivity status.

#### Features
- Check current connectivity status
- Listen to connectivity changes
- Check WiFi/Mobile/Ethernet connection
- Real-time connection monitoring

#### Usage

```dart
import '../di/injection.dart';
import '../services/network_service.dart';

// Inject service
final networkService = getIt<NetworkService>();

// Check connection
final isConnected = await networkService.hasConnection();
if (isConnected) {
  print('Device is connected');
}

// Check specific connection type
final isWifi = await networkService.isWifiConnected;
final isMobile = await networkService.isMobileConnected;

// Listen to connectivity changes
networkService.listenConnectivity(
  onConnectionChanged: (isConnected) {
    if (isConnected) {
      print('Connected to internet');
    } else {
      print('No internet connection');
    }
  },
);

// Dispose when done
networkService.dispose();
```

#### NetworkStatusIndicator Widget

```dart
import '../widgets/network_status_indicator.dart';

@override
Widget build(BuildContext context) {
  return NetworkStatusIndicator(
    showOfflineMessage: true,
    child: Scaffold(
      // Your app content
    ),
  );
}
```

---

### 2. PermissionService

Service to handle app permissions (camera, storage, location, etc.).

#### Features
- Request single permission
- Request multiple permissions
- Check permission status
- Handle permanently denied permissions
- Open app settings

#### Usage

```dart
import '../di/injection.dart';
import '../services/permission_service.dart';

// Inject service
final permissionService = getIt<PermissionService>();

// Request camera permission
final granted = await permissionService.requestCameraPermission();
if (granted) {
  // Open camera
}

// Check if permission is granted
final hasCamera = await permissionService.hasCameraPermission;

// Request multiple permissions
final allGranted = await permissionService.requestMultiplePermissions([
  Permission.camera,
  Permission.microphone,
]);

// Request with callbacks
await permissionService.requestPermissionWithCallback(
  permission: Permission.camera,
  onGranted: () {
    print('Camera permission granted');
  },
  onDenied: () {
    print('Camera permission denied');
  },
  onPermanentlyDenied: () {
    print('Camera permission permanently denied');
    // Open settings
    permissionService.openAppSettings();
  },
);

// Check permission status
final status = await permissionService.getPermissionStatus(Permission.camera);
print('Camera permission status: $status');
```

#### PermissionDialog Widget

```dart
import '../widgets/permission_dialog.dart';

// Show camera permission dialog
final granted = await PermissionDialog.showCameraPermission(context);
if (granted) {
  // Open camera
}

// Show storage permission dialog
await PermissionDialog.showStoragePermission(context);

// Show location permission dialog
await PermissionDialog.showLocationPermission(context);

// Show notification permission dialog
await PermissionDialog.showNotificationPermission(context);

// Custom permission dialog
await PermissionDialog.show(
  context: context,
  permission: Permission.camera,
  title: 'Camera Permission Required',
  message: 'We need camera access to scan QR codes.',
  settingsMessage: 'Please enable camera in settings to use this feature.',
);
```

#### Common Permission Combinations

```dart
// Video recording (camera + microphone)
final granted = await permissionService.requestVideoPermissions();

// Photo upload (camera + photos)
final granted = await permissionService.requestPhotoUploadPermissions();
```

---

## Platform Configuration

### Android

**`android/app/src/main/AndroidManifest.xml`**:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.READ_CONTACTS"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
</manifest>
```

### iOS

**`ios/Runner/Info.plist`**:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select photos</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs photo library access to save photos</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to show nearby places</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs location access to track your location</string>
<key>NSContactsUsageDescription</key>
<string>This app needs contacts access to find friends</string>
```

---

## Best Practices

### ✅ DO

1. **Request permissions when needed**
   ```dart
   // Good: Request right before use
   onTapCamera() async {
     final granted = await permissionService.requestCameraPermission();
     if (granted) openCamera();
   }
   ```

2. **Explain why you need permission**
   ```dart
   // Good: Show dialog with explanation
   await PermissionDialog.show(
     context: context,
     permission: Permission.camera,
     title: 'Camera Permission',
     message: 'We need camera to scan barcodes for easy checkout.',
   );
   ```

3. **Handle permanently denied**
   ```dart
   // Good: Guide user to settings
   if (await permissionService.isPermissionPermanentlyDenied(Permission.camera)) {
     await permissionService.openAppSettings();
   }
   ```

4. **Check network before API calls**
   ```dart
   // Good: Check connection first
   if (await networkService.hasConnection()) {
     await apiCall();
   } else {
     showNoInternetDialog();
   }
   ```

### ❌ DON'T

1. **Don't request all permissions at app start**
   ```dart
   // BAD: Requesting too many permissions upfront
   @override
   void initState() {
     requestAllPermissions();  // WRONG
   }
   ```

2. **Don't ignore permission status**
   ```dart
   // BAD: Not checking if granted
   await permissionService.requestCameraPermission();
   openCamera();  // WRONG - might not be granted
   ```

3. **Don't make API calls without checking network**
   ```dart
   // BAD: No network check
   try {
     await apiCall();  // Will fail if offline
   } catch (e) {
     // Handle error
   }
   ```

---

## Examples

### Complete Permission Flow

```dart
class CameraScreen extends StatelessWidget {
  final _permissionService = getIt<PermissionService>();
  
  Future<void> _openCamera(BuildContext context) async {
    // Check if already granted
    final hasPermission = await _permissionService.hasCameraPermission;
    
    if (hasPermission) {
      _launchCamera();
      return;
    }
    
    // Request with dialog
    final granted = await PermissionDialog.showCameraPermission(context);
    
    if (granted) {
      _launchCamera();
    } else {
      // Check if permanently denied
      if (await _permissionService.isPermissionPermanentlyDenied(Permission.camera)) {
        _showSettingsDialog(context);
      }
    }
  }
  
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Camera permission is required. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _permissionService.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
  
  void _launchCamera() {
    // Open camera
  }
}
```

### Network-Aware API Call

```dart
class DataRepository {
  final _networkService = getIt<NetworkService>();
  final _apiService = getIt<ApiService>();
  
  Future<Result> fetchData() async {
    // Check network first
    if (!await _networkService.hasConnection()) {
      return Result.error('No internet connection');
    }
    
    try {
      final data = await _apiService.getData();
      return Result.success(data);
    } catch (e) {
      return Result.error('Failed to fetch data');
    }
  }
}
```

---

## Testing

### Mock NetworkService

```dart
class MockNetworkService extends Mock implements NetworkService {}

test('should check network before API call', () async {
  final mockNetwork = MockNetworkService();
  when(mockNetwork.hasConnection()).thenAnswer((_) async => false);
  
  final result = await repository.fetchData();
  
  expect(result.isError, true);
  expect(result.error, 'No internet connection');
});
```

### Mock PermissionService

```dart
class MockPermissionService extends Mock implements PermissionService {}

test('should open camera when permission granted', () async {
  final mockPermission = MockPermissionService();
  when(mockPermission.requestCameraPermission()).thenAnswer((_) async => true);
  
  await screen.openCamera();
  
  verify(cameraController.initialize()).called(1);
});
```

---

## References

- [connectivity_plus](https://pub.dev/packages/connectivity_plus)
- [permission_handler](https://pub.dev/packages/permission_handler)
- [Screen Template](./SCREEN_TEMPLATE.md)
- [Clean Architecture](../rules/clean_architecture.md)

