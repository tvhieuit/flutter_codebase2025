# Navigation & Communication Best Practices

This document outlines the recommended patterns for navigation and message display in modular environments where `BuildContext` might not be immediately available.

## Core Principle: Dependency Injection (DI)

Instead of using static global keys or "Safe Context" patterns, we use **Dependency Injection**. Inject the necessary service (`StackRouter`, `AppRoute`, `AppToast`) directly into your class.

---

## ❌ SAI (Suboptimal / Wrong)
Do NOT use static access or try to extract `BuildContext` from a global navigator key. This makes testing difficult and tightly couples your logic to the UI layer.

```dart
// ❌ DONT: High coupling to BuildContext
AppRouter.rootNavigatorKey.currentContext?.router.push(const LoginRoute());
```

## ✅ ĐÚNG (Modular / Testable)
Inject the services you need. The DI system (`GetIt` + `injectable`) handles providing the correct instances.

### 1. Navigation from a Service
Inject `StackRouter` and `AppRoute`.

```dart
@injectable
class AuthService {
  final StackRouter _router;
  final AppRoute _appRoute;
  final UserLocalRepository _userLocalRepo;

  AuthService(this._router, this._appRoute, this._userLocalRepo);

  Future<void> logout() async {
    await _userLocalRepo.clearAllUserData();
    _router.replaceAll([_appRoute.login]); // ✅ Simple and testable
  }
}
```

### 2. Handling API Errors in Interceptors
Interceptors should also use injected services.

```dart
@injectable
class AuthInterceptor extends Interceptor {
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  AuthInterceptor(this._router, this._appRoute, this._toast);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _toast.error('Session expired. Please login again.');
      _router.replaceAll([_appRoute.login]);
    }
    super.onError(err, handler);
  }
}
```

### 3. Context-Independent Messages (Toasts)
Use `AppToast` for all user-facing messages. It does not require `BuildContext` and can be called from anywhere.

```dart
@injectable
class DataSyncService {
  final AppToast _toast;

  DataSyncService(this._toast);

  void onSyncError() {
    _toast.error('Sync failed. Please check your connection.');
  }
}
```

---

## Summary of Communication Channels

| Requirement | Preferred Tool | Why? |
|-------------|----------------|------|
| **Navigate** | Inject `StackRouter` | Modular, Mockable, No Context needed. |
| **Show Message** | Inject `AppToast` | Context-independent, consistent UI. |
| **Route Constants** | Inject `AppRoute` | Single source of truth for paths. |

## Benefits of this Pattern
1. **True Unit Testing**: You can provide a `MockStackRouter` and verify that `push` or `replaceAll` was called without ever starting a Flutter UI.
2. **Modular Architecture**: Layer (Data/Domain) doesn't need to know about the Flutter View hierarchy.
3. **Simplicity**: No more null-checking `currentContext` or handling navigator key errors.
