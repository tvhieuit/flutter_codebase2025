# Creating a New App

This guide explains how to create a new Flutter app within the monorepo workspace.

## Quick Start

```bash
# Create directory structure
mkdir -p apps/my_app/lib/{app,screen/splash,screen/home,di,l10n}
mkdir -p apps/my_app/{l10n,assets/icon,assets/image}
```

## Step-by-Step Guide

### 1. Create Directory Structure

```
apps/my_app/
├── lib/
│   ├── app/
│   │   ├── app.dart              # MaterialApp configuration
│   │   ├── app_router.dart       # Auto route config
│   │   └── auth_routes.dart      # Routes for feature_auth
│   ├── di/
│   │   ├── injection.dart        # DI configuration
│   │   └── modules.dart          # DI modules and implementations
│   ├── l10n/                     # Generated localization files
│   ├── screen/
│   │   ├── splash/
│   │   │   ├── splash_bloc.dart
│   │   │   ├── splash_event.dart
│   │   │   ├── splash_state.dart
│   │   │   └── splash_page.dart
│   │   └── home/
│   │       └── home_page.dart
│   └── main.dart
├── l10n/
│   └── app_en.arb                # English translations
├── assets/
│   ├── icon/
│   └── image/
├── pubspec.yaml
├── l10n.yaml
├── build.yaml
└── analysis_options.yaml
```

### 2. Create pubspec.yaml

```yaml
name: my_app
description: My new Flutter app
publish_to: 'none'
version: 1.0.0+1

resolution: workspace

environment:
  sdk: '>=3.9.0 <4.0.0'
  flutter: '>=3.38.8 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  flutter_bloc: any

  # Dependency Injection
  get_it: any
  injectable: any

  # Code Generation
  freezed_annotation: any
  json_annotation: any
  auto_route: any

  # Networking
  dio: any

  # Local Storage
  shared_preferences: any

  # Internal Packages
  app_core: any
  app_widget: any
  domain: any
  use_cases: any
  data: any
  feature_auth: any  # If using auth

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: any

  # Code Generation
  build_runner: any
  freezed: any
  json_serializable: any
  injectable_generator: any
  auto_route_generator: any

flutter:
  uses-material-design: true
  generate: true

  assets:
    - assets/icon/
    - assets/image/
```

### 3. Create l10n.yaml

```yaml
arb-dir: l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n
nullable-getter: false
```

### 4. Create l10n/app_en.arb

```json
{
  "@@locale": "en",
  
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  
  "homeTitle": "Home",
  "@homeTitle": {
    "description": "Title for home page"
  },
  
  "welcomeMessage": "Welcome!",
  "@welcomeMessage": {
    "description": "Welcome message"
  }
}
```

### 5. Create main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await configureDependencies();

  runApp(const MyApp());
}
```

### 6. Create app/app.dart

```dart
import 'package:feature_auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import '../l10n/app_localizations.dart';
import 'app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.instance<AppRouter>();

    return MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        AuthLocalizationsFallback.delegate, // If using feature_auth (falls back to en)
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter.config(),
    );
  }
}
```

### 7. Create app/app_router.dart

```dart
import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/home/home_page.dart';
import '../screen/splash/splash_page.dart';
import 'auth_routes.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page),
        // Auth routes from feature_auth
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
      ];
}
```

### 8. Create app/auth_routes.dart

For using feature_auth pages:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/auth.dart';

class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => const WrappedRoute(child: LoginPage()),
  );
}

class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => const WrappedRoute(child: RegisterPage()),
  );
}
```

### 9. Create di/injection.dart

```dart
import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Configure packages in order (order matters!)
  initCorePackage();
  initWidgetPackage();
  initDataPackage();        // Registers repo impls, Dio, SharedPrefs
  initDomainPackage();      // Registers repo interfaces
  initUseCasesPackage();    // Registers core use cases
  initAuthPackage();

  // Configure this app's DI
  getIt.init();
}
```

### 10. Create di/modules.dart

```dart
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../app/app_router.dart' show AppRouter, HomeRoute;
import '../app/auth_routes.dart';

@module
abstract class AppModule {
  @singleton
  Dio get dio {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}

@module
abstract class AuthModule {
  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  @LazySingleton(as: AuthNavigation)
  AuthNavigationImpl get authNavigation;
}

// Implement AuthRepository
@Injectable()
class AuthRepositoryImpl implements AuthRepository {
  // Implement all methods...
}

// Implement AuthNavigation
@Injectable()
class AuthNavigationImpl implements AuthNavigation {
  final StackRouter _router;

  AuthNavigationImpl(this._router);

  @override
  void goToHome() => _router.replaceAll([const HomeRoute()]);

  @override
  void goToLogin() => _router.push(const LoginRoute());

  @override
  void goToRegister() => _router.push(const RegisterRoute());

  @override
  void goToForgotPassword() {}

  @override
  void goBack() => _router.maybePop();
}
```

### 11. Create Splash Screen

**splash_bloc.dart:**
```dart
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserLocalRepository _userLocalRepository;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  SplashBloc(this._userLocalRepository, this._router, this._appRoute, this._toast) : super(SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
       await event.when(
        started: () => _onStarted(emit),
      );
    });
    add(const SplashEvent.started());
  }

  Future<void> _onStarted(Emitter<SplashState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 2));

    try {
      final tokenResult = await _userLocalRepository.getAccessToken();
      final hasToken = tokenResult.data?.isNotEmpty ?? false;

      emit(state.copyWith(
        isLoading: false,
        authStatus: hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      ));
      
      if (hasToken) {
        _router.replaceAll([_appRoute.home]);
      } else {
        _router.replaceAll([_appRoute.login]);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, authStatus: AuthStatus.unauthenticated));
      _router.replaceAll([_appRoute.login]);
    }
  }
}
```

**splash_event.dart:**
```dart
part of 'splash_bloc.dart';

@freezed
sealed class SplashEvent with _$SplashEvent {
  const factory SplashEvent.started() = _Started;
}
```

**splash_state.dart:**
```dart
part of 'splash_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

@freezed
sealed class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({
    @Default(false) bool isLoading,
    @Default(AuthStatus.unknown) AuthStatus authStatus,
  }) = _SplashState;

  factory SplashState.initial() => const SplashState();
}
```

### 12. Add to Workspace

In root `pubspec.yaml`:

```yaml
workspace:
  - apps/my_app
  # ... other packages
```

Update l10n script:
```yaml
melos:
  scripts:
    l10n:
      run: fvm dart run melos exec --concurrency=1 -- fvm flutter gen-l10n
      packageFilters:
        scope:
          - "flutter_app"
          - "feature_auth"
          - "my_app"  # Add your app
```

### 13. Generate Code

```bash
# Get dependencies
fvm dart run melos run pg

# Generate l10n
cd apps/my_app && fvm flutter gen-l10n

# Generate code (freezed, injectable, auto_route)
cd apps/my_app && fvm dart run build_runner build -d

# Format code
fvm dart format apps/my_app/lib/
```

### 14. Run the App

```bash
cd apps/my_app && fvm flutter run
```

## Directory Structure Reference

```
apps/my_app/
├── lib/
│   ├── app/
│   │   ├── app.dart              # MaterialApp with theme & l10n
│   │   ├── app_router.dart       # @AutoRouterConfig router
│   │   ├── app_router.gr.dart    # Generated routes
│   │   └── auth_routes.dart      # Manual routes for feature_auth
│   ├── di/
│   │   ├── injection.dart        # GetIt + package init
│   │   ├── injection.config.dart # Generated DI config
│   │   └── modules.dart          # Repository/Navigation impl
│   ├── l10n/
│   │   ├── app_localizations.dart     # Generated
│   │   └── app_localizations_en.dart  # Generated
│   ├── screen/
│   │   ├── splash/
│   │   │   ├── splash_bloc.dart
│   │   │   ├── splash_bloc.freezed.dart  # Generated
│   │   │   ├── splash_event.dart
│   │   │   ├── splash_state.dart
│   │   │   └── splash_page.dart
│   │   └── home/
│   │       └── home_page.dart
│   └── main.dart
├── l10n/
│   └── app_en.arb
├── assets/
│   ├── icon/
│   └── image/
├── android/                      # Optional: platform configs
├── ios/                          # Optional: platform configs
├── pubspec.yaml
├── l10n.yaml
├── build.yaml
└── analysis_options.yaml
```

## Tips

### Adding Platform Configurations

If you need custom Android/iOS configurations:

```bash
cd apps/my_app
fvm flutter create . --platforms=android,ios
```

### Different App Icons

Each app can have its own launcher icons. Use `flutter_launcher_icons` package.

### Different Package Names

Update `android/app/build.gradle` and iOS bundle identifier for each app.

### Sharing Code Between Apps

- Put shared business logic in `domain`
- Put shared features in `packages/feature/`
- Put shared UI in `app_widget`
- Put shared utilities in `app_utility`

## See Also

- [monorepo_guide.md](./monorepo_guide.md) - Monorepo overview
- [feature_packages.md](./feature_packages.md) - Creating feature packages
- [auth_package.md](./auth_package.md) - Using feature_auth
