# Routing Guide

## Auto Route Configuration

### Router Setup

The `AppRouter` must be configured as a singleton with proper annotations:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@singleton  // MUST be singleton - only one router instance in app
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {  // MUST extend generated $AppRouter
  // Global key for navigation without BuildContext
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter() : super(navigatorKey: rootNavigatorKey);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
    ),
    // Add more routes...
  ];
}
```

### Why @singleton?

1. **Single Instance**: Only one router instance throughout app lifecycle
2. **Navigation State**: Maintains consistent navigation state
3. **Performance**: No need to recreate router instance
4. **DI Integration**: Works seamlessly with GetIt

### Router Injection

In `app.dart`:

```dart
import '../di/injection.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();  // Inject singleton router

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      // ...
    );
  }
}
```

## Adding New Routes

### 1. Create Page with @RoutePage

```dart
import 'package:auto_route/auto_route.dart';

@RoutePage()
class MyFeaturePage extends StatelessWidget implements AutoRouteWrapper {
  const MyFeaturePage({super.key});
  
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyFeatureBloc>(),
      child: this,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(/* ... */);
  }
}
```

### 2. Add Route to AppRouter

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: MyFeatureRoute.page),  // Add here
  ];
}
```

### 3. Generate Code

```bash
fvm dart run melos run brd
```

## Navigation

### Basic Navigation

```dart
// Push new route
context.router.push(const MyFeatureRoute());

// Replace current route
context.router.replace(const MyFeatureRoute());

// Pop current route
context.router.pop();

// Pop and push
context.router.popAndPush(const MyFeatureRoute());
```

### Navigation with Parameters

#### 1. Define Page with Parameters

```dart
@RoutePage()
class UserProfilePage extends StatelessWidget implements AutoRouteWrapper {
  final String userId;
  
  const UserProfilePage({
    super.key,
    required this.userId,
  });
  
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserProfileBloc>()
        ..add(UserProfileEvent.load(userId)),
      child: this,
    );
  }
}
```

#### 2. Navigate with Parameters

```dart
context.router.push(UserProfileRoute(userId: '123'));
```

### Nested Navigation

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
  ];
}
```

## Route Guards

### Authentication Guard

```dart
class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepository;
  
  AuthGuard(this._authRepository);
  
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    
    if (isAuthenticated) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}

// Register guard
@singleton
class AppRouter extends $AppRouter {
  final AuthGuard _authGuard;
  
  AppRouter(this._authGuard);
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(
      page: HomeRoute.page,
      guards: [_authGuard],  // Add guard
    ),
  ];
}
```

## Deep Linking

Configure deep linking in `app_router.dart`:

```dart
@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: UserProfileRoute.page,
      path: '/user/:userId',  // Deep link path
    ),
  ];
}
```

## Route Transitions

### Custom Transitions

```dart
AutoRoute(
  page: MyFeatureRoute.page,
  transitionsBuilder: TransitionsBuilders.slideLeft,
  durationInMilliseconds: 300,
),
```

### Available Transitions

- `TransitionsBuilders.slideLeft`
- `TransitionsBuilders.slideRight`
- `TransitionsBuilders.slideTop`
- `TransitionsBuilders.slideBottom`
- `TransitionsBuilders.fadeIn`
- `TransitionsBuilders.zoomIn`

## Best Practices

### ✅ DO

1. **Use @singleton for AppRouter**
   ```dart
   @singleton
   class AppRouter extends $AppRouter {}
   ```

2. **Extend $AppRouter (generated class)**
   ```dart
   class AppRouter extends $AppRouter {}  // NOT RootStackRouter
   ```

3. **Use AutoRouteWrapper for BLoC**
   ```dart
   class MyPage implements AutoRouteWrapper {}
   ```

4. **Inject router as singleton**
   ```dart
   final _appRouter = getIt<AppRouter>();
   ```

5. **Use const for routes**
   ```dart
   context.router.push(const MyFeatureRoute());
   ```

### ❌ DON'T

1. **Don't create multiple router instances**
   ```dart
   final router = AppRouter();  // WRONG - use getIt
   ```

2. **Don't extend RootStackRouter directly**
   ```dart
   class AppRouter extends RootStackRouter {}  // WRONG
   ```

3. **Don't add events in wrappedRoute**
   ```dart
   // WRONG - add events in BLoC constructor
   Widget wrappedRoute(BuildContext context) {
     return BlocProvider(
       create: (context) => getIt<MyBloc>()..add(event),  // WRONG
     );
   }
   ```

## Troubleshooting

### UnimplementedError in pagesMap

**Problem**: Router extends `RootStackRouter` instead of `$AppRouter`

**Solution**:
```dart
// Change from:
class AppRouter extends RootStackRouter {}

// To:
class AppRouter extends $AppRouter {}
```

### Route not found

**Problem**: Forgot to run code generation after adding route

**Solution**:
```bash
fvm dart run melos run brd
```

### Multiple router instances

**Problem**: Not using `@singleton` annotation

**Solution**:
```dart
@singleton
class AppRouter extends $AppRouter {}
```

## Examples

### Complete Router Setup

```dart
// lib/app/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ProfileRoute.page, path: '/profile/:userId'),
  ];
}
```

### App Integration

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import '../di/injection.dart';
import 'app_router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'My App',
      theme: ThemeData.light(),
    );
  }
}
```

## References

- [Auto Route Documentation](https://pub.dev/packages/auto_route)
- [Screen Template](./SCREEN_TEMPLATE.md)
- [Clean Architecture Rules](../rules/clean_architecture.md)

