# Quick Start Guide

## ✅ Setup Complete!

Your splash screen is fully implemented and ready to use!

## 🚀 Run the App

```bash
# Run in development mode
fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json

# Or for quick testing (if flavors not fully configured)
fvm flutter run
```

## 📁 What You Have Now

### Project Structure
```
lib/
├── app/
│   ├── app.dart                 # Main app with routing
│   └── app_router.dart          # Route configuration
├── app_mixin/
│   └── safety_network_mixin.dart # For safe API calls
├── di/
│   └── injection.dart           # Dependency injection
├── screen/
│   └── splash/
│       ├── splash_bloc.dart     # Business logic
│       ├── splash_event.dart    # Events
│       ├── splash_state.dart    # State
│       └── splash_page.dart     # UI
└── main.dart                    # Entry point
```

### Features Implemented
✅ Splash screen with loading animation  
✅ BLoC state management  
✅ Auto Route navigation  
✅ GetIt dependency injection  
✅ Freezed immutable states  
✅ SafetyNetworkMixin for error handling  
✅ Clean Architecture structure  

## 🎯 Next Steps

### 1. Add a Home Screen

Create `lib/screen/home/home_page.dart`:
```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome Home!')),
    );
  }
}
```

Add to `lib/app/app_router.dart`:
```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),  // Add this
  ];
}
```

Run code generation:
```bash
fvm dart run build_runner build -d
```

### 2. Add Navigation from Splash

Update `lib/screen/splash/splash_page.dart`:
```dart
BlocListener<SplashBloc, SplashState>(
  listenWhen: (previous, current) =>
      previous.isInitialized != current.isInitialized &&
      current.isInitialized,
  listener: (context, state) {
    // Navigate to home after initialization
    context.router.replace(const HomeRoute());
  },
  // ... rest of code
)
```

### 3. Add Authentication Logic

Create use case:
```dart
// lib/use_case/auth_use_case.dart
abstract class AuthUseCase {
  Future<bool> isAuthenticated();
}

@Injectable(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  @override
  Future<bool> isAuthenticated() async {
    // Check token, etc.
    return false;
  }
}
```

Update splash BLoC:
```dart
@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> with SafetyNetworkMixin {
  final AuthUseCase _authUseCase;
  
  SplashBloc(this._authUseCase) : super(SplashState.initial());
  // ... rest of implementation
}
```

## 🔧 Common Commands

```bash
# Get dependencies
fvm dart run melos run pg

# Generate code (after adding @freezed, @injectable, @RoutePage)
fvm dart run melos run brd

# Format code
fvm dart run melos run fm

# Generate localization
fvm dart run melos run l10n

# Run app
fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json
```

## 📝 Creating New Features

### Step 1: Create BLoC
```dart
// lib/screen/my_feature/my_feature_bloc.dart
@injectable
class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState> 
    with SafetyNetworkMixin {
  final MyFeatureUseCase _useCase;
  
  MyFeatureBloc(this._useCase) : super(MyFeatureState.initial());
}
```

### Step 2: Create State with Freezed
```dart
// lib/screen/my_feature/my_feature_state.dart
part of 'my_feature_bloc.dart';

@freezed
class MyFeatureState with _$MyFeatureState {
  const factory MyFeatureState({
    @Default(false) bool isLoading,
    String? data,
    String? error,
  }) = _MyFeatureState;
  
  factory MyFeatureState.initial() => const MyFeatureState();
}
```

### Step 3: Create Page
```dart
// lib/screen/my_feature/my_feature_page.dart
@RoutePage()
class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyFeatureBloc>(),
      child: const MyFeatureView(),
    );
  }
}
```

### Step 4: Generate Code
```bash
fvm dart run melos run brd
```

## 🐛 Troubleshooting

### Build Errors
```bash
# Clean and rebuild
fvm flutter clean
fvm dart run melos run pg
fvm dart run melos run brd
```

### Route Not Found
- Make sure you added `@RoutePage()` to your page
- Run `fvm dart run melos run brd`
- Check `app_router.dart` includes your route

### DI Not Working
- Ensure `@injectable` annotation on BLoC
- Run `fvm dart run melos run brd`
- Check `injection.config.dart` includes your class

### State Not Updating
- Use `buildWhen` in BlocBuilder
- Use `listenWhen` in BlocListener
- Emit new state with `copyWith()`

## 📚 Architecture Rules

### ✅ DO
- Use `@injectable` for all BLoCs
- Use `SafetyNetworkMixin` for API calls
- Use `@freezed` for all states
- Use `buildWhen` and `listenWhen`
- Inject Use Cases (not Repositories)

### ❌ DON'T
- Don't inject Repositories directly in BLoCs
- Don't skip `buildWhen`/`listenWhen`
- Don't make direct API calls in BLoCs
- Don't use mutable states

## 🎨 Customize Splash Screen

Edit `lib/screen/splash/splash_page.dart`:

```dart
// Change colors
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.purple, Colors.blue],  // Your colors
    ),
  ),
)

// Change logo
Icon(
  Icons.your_icon,  // Your icon
  size: 120,
)

// Change text
Text(
  'Your App Name',  // Your app name
  style: TextStyle(...),
)

// Change timing in splash_bloc.dart
await Future.delayed(const Duration(seconds: 1));  // Your timing
```

## ✅ Verification Checklist

- [x] FVM setup complete
- [x] Dependencies installed
- [x] Code generated
- [x] Splash screen created
- [x] BLoC implemented
- [x] Auto Route configured
- [x] GetIt DI configured
- [x] SafetyNetworkMixin created
- [x] Code formatted
- [x] No linter errors

## 🎉 You're Ready!

Your Flutter app is now set up with:
- ✅ Clean Architecture
- ✅ BLoC Pattern
- ✅ Dependency Injection
- ✅ Routing
- ✅ State Management
- ✅ Error Handling

Start building your features! 🚀

