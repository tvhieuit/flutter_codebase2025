# Flutter Screen Template - Best Practices

This template follows Clean Architecture and project standards.

## 📁 Directory Structure

```
lib/screen/feature_name/
├── feature_name_bloc.dart       # BLoC implementation
├── feature_name_event.dart      # Events (part of bloc)
├── feature_name_state.dart      # State (part of bloc)
├── feature_name_page.dart       # UI Page
└── feature_name_bloc.freezed.dart  # Generated
```

## 🎯 Complete Implementation

### 1. Event (freezed)

```dart
// lib/screen/feature_name/feature_name_event.dart
part of 'feature_name_bloc.dart';

@freezed
class FeatureNameEvent with _$FeatureNameEvent {
  const factory FeatureNameEvent.started() = _Started;
  const factory FeatureNameEvent.loadData() = _LoadData;
  const factory FeatureNameEvent.refresh() = _Refresh;
}
```

### 2. State (freezed)

```dart
// lib/screen/feature_name/feature_name_state.dart
part of 'feature_name_bloc.dart';

@freezed
class FeatureNameState with _$FeatureNameState {
  const factory FeatureNameState({
    @Default(false) bool isLoading,
    @Default(false) bool isInitialized,
    String? data,
    String? error,
  }) = _FeatureNameState;

  factory FeatureNameState.initial() => const FeatureNameState();
}
```

### 3. BLoC (injectable + auto-init)

```dart
// lib/screen/feature_name/feature_name_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../app_mixin/safety_network_mixin.dart';
// Import your use case here
// import '../../use_case/feature_name_use_case.dart';

part 'feature_name_event.dart';
part 'feature_name_state.dart';
part 'feature_name_bloc.freezed.dart';

@injectable
class FeatureNameBloc extends Bloc<FeatureNameEvent, FeatureNameState> 
    with SafetyNetworkMixin {
  // Inject use case (not repository!)
  // final FeatureNameUseCase _useCase;

  FeatureNameBloc(
    // this._useCase,
  ) : super(FeatureNameState.initial()) {
    on(_onStarted);
    on(_onLoadData);
    on(_onRefresh);

    // Auto-start initialization
    add(const FeatureNameEvent.started());
  }

  Future<void> _onStarted(
    _Started event,
    emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      () async {
        // Initialize logic here
        await Future.delayed(const Duration(seconds: 1));

        emit(
          state.copyWith(
            isLoading: false,
            isInitialized: true,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> _onLoadData(
    _LoadData event,
    emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    await safeNetworkCall(
      () async {
        // Call use case here
        // final result = await _useCase.getData();

        emit(
          state.copyWith(
            isLoading: false,
            data: 'Sample Data',
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            error: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(
    _Refresh event,
    emit,
  ) async {
    // Refresh logic
    add(const FeatureNameEvent.loadData());
  }
}
```

### 4. Page (AutoRouteWrapper)

```dart
// lib/screen/feature_name/feature_name_page.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import 'feature_name_bloc.dart';

@RoutePage()
class FeatureNamePage extends StatelessWidget implements AutoRouteWrapper {
  const FeatureNamePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeatureNameBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeatureNameBloc, FeatureNameState>(
      listenWhen: (previous, current) =>
          previous.error != current.error && current.error != null,
      listener: (context, state) {
        // Show error snackbar
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feature Name'),
        ),
        body: BlocBuilder<FeatureNameBloc, FeatureNameState>(
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading ||
              previous.data != current.data,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.data == null) {
              return const Center(
                child: Text('No data'),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.data!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FeatureNameBloc>().add(
                            const FeatureNameEvent.refresh(),
                          );
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## 🔧 Setup Steps

### 1. Create Files
```bash
mkdir -p lib/screen/feature_name
touch lib/screen/feature_name/feature_name_bloc.dart
touch lib/screen/feature_name/feature_name_event.dart
touch lib/screen/feature_name/feature_name_state.dart
touch lib/screen/feature_name/feature_name_page.dart
```

### 2. Add Route
```dart
// lib/app/app_router.dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: FeatureNameRoute.page),  // Add this
  ];
}
```

### 3. Generate Code
```bash
fvm dart run build_runner build -d
```

### 4. Format
```bash
fvm dart format .
```

## ✅ Checklist

- [ ] Event uses `@freezed`
- [ ] State uses `@freezed`
- [ ] BLoC uses `@injectable`
- [ ] BLoC extends with `SafetyNetworkMixin`
- [ ] BLoC auto-starts with `add()` in constructor
- [ ] Page implements `AutoRouteWrapper`
- [ ] Page uses `wrappedRoute()` for BLoC provider
- [ ] Page uses `@RoutePage()` annotation
- [ ] BlocBuilder has `buildWhen`
- [ ] BlocListener has `listenWhen`
- [ ] Uses `emit` instead of `Emitter<State>`
- [ ] Uses `on()` instead of `on<Event>()`
- [ ] Inject Use Case (not Repository)
- [ ] All API calls wrapped in `safeNetworkCall()`

## 🎯 Key Principles

### ✅ DO
- Use `@freezed` for Events and States
- Use `@injectable` for BLoCs
- Implement `AutoRouteWrapper` for Pages
- Auto-start BLoC with `add()` in constructor
- Use `buildWhen` and `listenWhen`
- Inject Use Cases only
- Wrap API calls with `safeNetworkMixin`
- Keep one class per page (no separate View)

### ❌ DON'T
- Don't use abstract class for Events
- Don't skip `buildWhen`/`listenWhen`
- Don't inject Repositories in BLoCs
- Don't make direct API calls
- Don't create separate View class
- Don't add events in `wrappedRoute()`
- Don't use type parameters in `on<>()`

## 📚 Navigation Example

### From Another Screen
```dart
// Navigate to feature
context.router.push(const FeatureNameRoute());

// Replace current route
context.router.replace(const FeatureNameRoute());

// Pop and push
context.router.pop();
context.router.push(const FeatureNameRoute());
```

### With Parameters
```dart
// In route definition
AutoRoute(page: FeatureNameRoute.page),

// In page
@RoutePage()
class FeatureNamePage extends StatelessWidget implements AutoRouteWrapper {
  final String userId;  // Add parameter
  
  const FeatureNamePage({
    super.key,
    required this.userId,  // Required parameter
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeatureNameBloc>()
        ..add(FeatureNameEvent.loadUser(userId)),  // Pass to event
      child: this,
    );
  }
}

// Navigate with parameter
context.router.push(FeatureNameRoute(userId: '123'));
```

## 🚀 Quick Command Reference

```bash
# Get dependencies
fvm dart run melos run pg

# Generate code
fvm dart run melos run brd

# Format code
fvm dart run melos run fm

# Run app
fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json
```

## 📝 Notes

- Always run code generation after creating/modifying freezed classes
- Format code before committing
- Test navigation flow
- Use localization for user-facing strings
- Add proper error handling
- Consider loading states
- Test on both Android and iOS

---

**Last Updated**: Based on project best practices
**Pattern Version**: 1.0 (Clean Architecture + BLoC + AutoRoute)

