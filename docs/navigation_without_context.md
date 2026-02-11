# Navigation Without BuildContext

## Overview

In modular projects, it's common to need navigation from places where `BuildContext` is unavailable (Interceptors, Services, Repositories). Instead of using static global keys, we use **Dependency Injection** to provide the Router.

## ❌ SAI (Wrong Practice)
Do NOT use static global keys or access `NavigatorState` directly through static variables. This makes code hard to test and tightly coupled.

```dart
// ❌ DONT: Static access
AppRouter.rootNavigatorKey.currentContext?.router.push(const LoginRoute());
```

---

## ✅ ĐÚNG (Best Practice)
Inject the `StackRouter` (or `AppRouter`) into your classes. This follows Clean Architecture and makes your logic testable.

### 1. In a Service or Repository
The router is registered as a singleton in `GetIt`. Simply request it in the constructor.

```dart
@injectable
class MyService {
  final StackRouter _router;

  MyService(this._router);

  void handleAction() {
    _router.push(const MyRoute());
  }
}
```

### 2. In a Dio Interceptor
Since Interceptors are often registered as singletons, you can inject the router directly.

```dart
@injectable
class AuthInterceptor extends Interceptor {
  final StackRouter _router;

  AuthInterceptor(this._router);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Auto-navigate on session expired
      _router.replaceAll([const LoginRoute()]);
    }
    super.onError(err, handler);
  }
}
```

---

## Navigation in Different Layers

| Layer | Recommended Access |
|-------|-------------------|
| **UI (Widget)** | `context.router.push(...)` |
| **BLoC** | Inject `StackRouter` in constructor |
| **Service/Repo** | Inject `StackRouter` in constructor |
| **Interceptor** | Inject `StackRouter` in constructor |

### Note on "Global" Dialogs/SnackBars
For showing dialogs or SnackBars without context, use a dedicated abstraction or inject the `NavigatorState` key if absolutely necessary for `showDialog`, but prefer using `AppToast` for messages as it's context-independent.

```dart
@injectable
class NotificationService {
  final AppToast _toast; // Context-independent
  
  void notify(String msg) => _toast.show(msg);
}
```

## Why Injection is Better?
1. **Testability**: You can easily mock the `StackRouter` in unit tests.
2. **Decoupling**: Classes don't need to know about the concrete `AppRouter` implementation.
3. **Consistency**: Follows the same dependency pattern used for all other services.
