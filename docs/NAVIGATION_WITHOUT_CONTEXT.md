# Navigation Without BuildContext

## Overview

Sometimes you need to navigate without access to `BuildContext`, such as:
- In Dio interceptors
- In services or repositories
- In background tasks
- From static methods

## Setup

The `AppRouter` includes a global navigator key:

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  // Global key for navigation without BuildContext
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter() : super(navigatorKey: rootNavigatorKey);

  @override
  List<AutoRoute> get routes => [...];
}
```

## Usage Examples

### 1. Navigate from Dio Interceptor

```dart
import 'package:dio/dio.dart';
import '../app/app_router.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Unauthorized - navigate to login without BuildContext
      AppRouter.rootNavigatorKey.currentContext?.router.push(const LoginRoute());
    }
    
    super.onError(err, handler);
  }
}
```

### 2. Navigate from Service

```dart
import '../app/app_router.dart';

@injectable
class AuthService {
  Future<void> logout() async {
    // Clear token, etc.
    await _clearUserData();
    
    // Navigate to login without BuildContext
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }
}
```

### 3. Show Dialog from Service

```dart
import 'package:flutter/material.dart';
import '../app/app_router.dart';

@injectable
class NotificationService {
  void showErrorDialog(String message) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
```

### 4. Show SnackBar from Anywhere

```dart
import 'package:flutter/material.dart';
import '../app/app_router.dart';

class AppSnackBar {
  static void show(String message) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  
  static void showError(String message) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Usage from anywhere
AppSnackBar.show('Data saved successfully');
AppSnackBar.showError('Failed to load data');
```

### 5. Navigate from UseCase

```dart
import '../app/app_router.dart';

@Injectable(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  @override
  Future<void> handleSessionExpired() async {
    // Session expired, navigate to login
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }
}
```

### 6. Complete Dio Setup with Auto-Navigation

```dart
@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add interceptor with navigation
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired - auto navigate to login
            final context = AppRouter.rootNavigatorKey.currentContext;
            if (context != null) {
              context.router.replaceAll([const LoginRoute()]);
            }
          }
          
          if (error.response?.statusCode == 403) {
            // Forbidden - show error
            AppSnackBar.showError('Access denied');
          }
          
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}
```

## Best Practices

### ✅ DO

1. **Check for null before using**
   ```dart
   final context = AppRouter.rootNavigatorKey.currentContext;
   if (context != null) {
     context.router.push(const HomeRoute());
   }
   ```

2. **Use for error handling**
   ```dart
   // Good use case: Handle global errors
   if (error is UnauthorizedException) {
     AppRouter.rootNavigatorKey.currentContext?.router.push(const LoginRoute());
   }
   ```

3. **Use for background tasks**
   ```dart
   // Good use case: Navigate after background task
   Future<void> syncData() async {
     await _syncWithServer();
     final context = AppRouter.rootNavigatorKey.currentContext;
     if (context != null) {
       AppSnackBar.show('Sync completed');
     }
   }
   ```

### ❌ DON'T

1. **Don't use when BuildContext is available**
   ```dart
   // BAD - BuildContext is available
   @override
   Widget build(BuildContext context) {
     return ElevatedButton(
       onPressed: () {
         AppRouter.rootNavigatorKey.currentContext?.router.push(/* */); // WRONG
         // Use context.router.push instead
       },
     );
   }
   ```

2. **Don't forget null check**
   ```dart
   // BAD - No null check
   AppRouter.rootNavigatorKey.currentContext!.router.push(/* */); // WRONG
   
   // GOOD - With null check
   final context = AppRouter.rootNavigatorKey.currentContext;
   if (context != null) {
     context.router.push(/* */);
   }
   ```

3. **Don't overuse it**
   ```dart
   // BAD - Using global key when context is available
   class MyBloc {
     void navigate() {
       AppRouter.rootNavigatorKey.currentContext?.router.push(/* */); // WRONG
       // BLoC shouldn't handle navigation - emit state instead
     }
   }
   ```

## Common Use Cases

### Authentication Error Handling

```dart
@injectable
class ApiService {
  final Dio _dio;
  
  ApiService(this._dio) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          _handleApiError(error);
          handler.next(error);
        },
      ),
    );
  }
  
  void _handleApiError(DioException error) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context == null) return;
    
    switch (error.response?.statusCode) {
      case 401:
        // Unauthorized
        context.router.replaceAll([const LoginRoute()]);
        AppSnackBar.showError('Session expired. Please login again.');
        break;
        
      case 403:
        // Forbidden
        AppSnackBar.showError('Access denied');
        break;
        
      case 404:
        // Not found
        AppSnackBar.showError('Resource not found');
        break;
        
      case 500:
        // Server error
        AppSnackBar.showError('Server error. Please try again.');
        break;
    }
  }
}
```

### Network Error Service

```dart
@injectable
class NetworkErrorService {
  void handleNetworkError(dynamic error) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context == null) return;
    
    String message = 'An error occurred';
    
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Server response timeout';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection';
          break;
        default:
          message = error.message ?? 'Network error';
      }
    }
    
    AppSnackBar.showError(message);
  }
}
```

## References

- [Routing Guide](./ROUTING.md)
- [Screen Template](./SCREEN_TEMPLATE.md)
- [Auto Route Documentation](https://pub.dev/packages/auto_route)

