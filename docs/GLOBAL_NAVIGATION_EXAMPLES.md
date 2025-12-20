# Global Navigation Examples

## AppRouter Global Context Access

The `AppRouter` provides two ways to access BuildContext globally:

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter() : super(navigatorKey: rootNavigatorKey);

  // Throws exception if context is null
  BuildContext get globalContext =>
      rootNavigatorKey.currentContext ?? (throw Exception('Navigator context is not available'));

  // Returns null if context is not available
  BuildContext? get globalContextOrNull => rootNavigatorKey.currentContext;
}
```

## Usage Examples

### 1. Using Static Key (Recommended for Services)

```dart
@injectable
class AuthService {
  Future<void> logout() async {
    await _clearUserData();
    
    // Using static key - no need to inject router
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }
}
```

### 2. Using Instance Getter (When Router is Injected)

```dart
@injectable
class AuthService {
  final AppRouter _router;
  
  AuthService(this._router);
  
  Future<void> logout() async {
    await _clearUserData();
    
    try {
      // Throws if context not available
      final context = _router.globalContext;
      context.router.replaceAll([const LoginRoute()]);
    } catch (e) {
      print('Navigation failed: $e');
    }
  }
}
```

### 3. Using Safe Getter (Null Check)

```dart
@injectable
class NotificationService {
  final AppRouter _router;
  
  NotificationService(this._router);
  
  void showNotification(String message) {
    // Safe - returns null if not available
    final context = _router.globalContextOrNull;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
```

### 4. Dio Interceptor with Static Key

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Using static key - no DI needed
      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context != null) {
        context.router.replaceAll([const LoginRoute()]);
      }
    }
    
    super.onError(err, handler);
  }
}
```

### 5. Global Error Handler

```dart
class GlobalErrorHandler {
  static void handle(dynamic error) {
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context == null) {
      print('Cannot show error: context not available');
      return;
    }
    
    String message = 'An error occurred';
    
    if (error is DioException) {
      message = _getDioErrorMessage(error);
    } else if (error is Exception) {
      message = error.toString();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
  
  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return error.message ?? 'Network error';
    }
  }
}

// Usage from anywhere
try {
  await apiCall();
} catch (e) {
  GlobalErrorHandler.handle(e);
}
```

### 6. Complete API Service with Navigation

```dart
@injectable
class ApiService {
  final Dio _dio;
  final AppRouter _router;
  
  ApiService(this._dio, this._router) {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }
  
  void _handleError(DioException error) {
    final context = _router.globalContextOrNull;
    if (context == null) return;
    
    switch (error.response?.statusCode) {
      case 401:
        // Unauthorized - navigate to login
        context.router.replaceAll([const LoginRoute()]);
        _showSnackBar(context, 'Session expired. Please login again.');
        break;
        
      case 403:
        // Forbidden
        _showSnackBar(context, 'Access denied');
        break;
        
      case 404:
        // Not found
        _showSnackBar(context, 'Resource not found');
        break;
        
      case 500:
        // Server error
        _showSnackBar(context, 'Server error. Please try again.');
        break;
        
      default:
        _showSnackBar(context, 'An error occurred');
    }
  }
  
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

### 7. Background Task with Navigation

```dart
@injectable
class SyncService {
  final AppRouter _router;
  final ApiService _apiService;
  
  SyncService(this._router, this._apiService);
  
  Future<void> syncData() async {
    try {
      await _apiService.syncWithServer();
      
      // Show success message if context available
      final context = _router.globalContextOrNull;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync completed successfully')),
        );
      }
    } catch (e) {
      // Show error if context available
      final context = _router.globalContextOrNull;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
```

## Comparison

### Static Key vs Instance Getter

| Feature | Static Key | Instance Getter |
|---------|-----------|----------------|
| DI Required | ❌ No | ✅ Yes |
| Import | `AppRouter.rootNavigatorKey` | Inject `AppRouter` |
| Use Case | Services, Interceptors | When router already injected |
| Null Safe | Manual check | `globalContextOrNull` |
| Throws | Never | `globalContext` throws |

### When to Use What

**Use Static Key** (`AppRouter.rootNavigatorKey.currentContext`):
- ✅ In Dio interceptors
- ✅ In static methods
- ✅ When DI not available
- ✅ In simple utility classes

**Use Instance Getter** (`router.globalContext` / `router.globalContextOrNull`):
- ✅ When router already injected
- ✅ In services with DI
- ✅ When you want exception on null
- ✅ In complex service classes

## Best Practices

### ✅ DO

1. **Always check for null with static key**
   ```dart
   final context = AppRouter.rootNavigatorKey.currentContext;
   if (context != null) {
     // Use context
   }
   ```

2. **Use safe getter when injecting router**
   ```dart
   final context = _router.globalContextOrNull;
   if (context != null) {
     // Use context
   }
   ```

3. **Handle exceptions with throwing getter**
   ```dart
   try {
     final context = _router.globalContext;
     // Use context
   } catch (e) {
     print('Context not available: $e');
   }
   ```

### ❌ DON'T

1. **Don't use when BuildContext is available**
   ```dart
   // BAD
   Widget build(BuildContext context) {
     AppRouter.rootNavigatorKey.currentContext?.router.push(/**/); // WRONG
     // Use context.router.push instead
   }
   ```

2. **Don't force unwrap**
   ```dart
   // BAD - Can crash
   final context = AppRouter.rootNavigatorKey.currentContext!;
   ```

3. **Don't use in BLoCs for navigation**
   ```dart
   // BAD - BLoC shouldn't navigate
   class MyBloc {
     void navigate() {
       _router.globalContext.router.push(/**/); // WRONG
       // Emit state instead, let UI handle navigation
     }
   }
   ```

## Summary

Three ways to access global context:

1. **Static Key** - `AppRouter.rootNavigatorKey.currentContext`
   - No DI needed
   - Returns `BuildContext?`
   - Best for interceptors

2. **Safe Getter** - `router.globalContextOrNull`
   - Requires DI
   - Returns `BuildContext?`
   - Best for services

3. **Throwing Getter** - `router.globalContext`
   - Requires DI
   - Returns `BuildContext` (throws if null)
   - Best when context must exist

Choose based on your use case! 🚀

