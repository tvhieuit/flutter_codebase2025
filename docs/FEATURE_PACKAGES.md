# Feature Packages Guide

Feature packages are self-contained modules that encapsulate a specific feature of your application. They can be shared across multiple apps in the monorepo.

## Overview

```
packages/feature/
├── auth/           # Authentication feature
├── home/           # Home/dashboard feature (example)
├── profile/        # User profile feature (example)
└── settings/       # Settings feature (example)
```

## Feature Package Structure

```
packages/feature/my_feature/
├── lib/
│   ├── my_feature.dart           # Main export file
│   └── src/
│       ├── bloc/                 # BLoC files
│       │   ├── my_feature_bloc.dart
│       │   ├── my_feature_event.dart
│       │   └── my_feature_state.dart
│       ├── page/                 # UI pages
│       │   ├── pages.dart        # Barrel export
│       │   ├── my_feature_page.dart
│       │   └── my_feature_detail_page.dart
│       ├── models/               # Feature-specific models
│       │   ├── models.dart       # Barrel export
│       │   └── my_model.dart
│       ├── repository/           # Repository interfaces
│       │   ├── repository.dart   # Barrel export
│       │   └── my_repository.dart
│       ├── navigation/           # Navigation abstraction
│       │   ├── navigation.dart
│       │   └── my_navigation.dart
│       ├── l10n/                 # Generated localizations
│       │   ├── l10n.dart
│       │   └── my_feature_localizations.dart
│       └── di/                   # Dependency injection
│           ├── di.dart
│           └── injection.dart
├── l10n/                         # ARB files
│   └── my_feature_en.arb
├── pubspec.yaml
├── l10n.yaml
├── build.yaml
└── analysis_options.yaml
```

## Creating a Feature Package

### Step 1: Create Directory Structure

```bash
mkdir -p packages/feature/my_feature/lib/src/{bloc,page,models,repository,navigation,di}
mkdir -p packages/feature/my_feature/l10n
```

### Step 2: Create pubspec.yaml

```yaml
name: feature_my_feature
description: My feature package
publish_to: 'none'
version: 0.0.1

resolution: workspace

environment:
  sdk: '>=3.9.0 <4.0.0'
  flutter: '>=3.38.8 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # Domain layer
  domain: any
  
  # State Management
  flutter_bloc: any
  
  # Dependency Injection
  get_it: any
  injectable: any
  
  # Code Generation
  freezed_annotation: any
  json_annotation: any
  
  # Routing
  auto_route: any

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
  generate: true
```

### Step 3: Create Main Export File

**lib/my_feature.dart:**
```dart
// BLoC
export 'src/bloc/my_feature_bloc.dart';

// Models
export 'src/models/models.dart';

// Repository
export 'src/repository/repository.dart';

// Pages
export 'src/page/pages.dart';

// Navigation
export 'src/navigation/navigation.dart';

// DI
export 'src/di/di.dart';

// Localization
export 'src/l10n/l10n.dart';
```

### Step 4: Create BLoC

**src/bloc/my_feature_bloc.dart:**
```dart
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'my_feature_bloc.freezed.dart';
part 'my_feature_event.dart';
part 'my_feature_state.dart';

@injectable
class MyFeatureBloc extends Bloc<MyFeatureEvent, MyFeatureState>
    with SafetyNetworkMixin {
  final MyFeatureRepository _repository;

  MyFeatureBloc(this._repository) : super(MyFeatureState.initial()) {
    on<MyFeatureEvent>(_onEvent);
  }

  Future<void> _onEvent(
    MyFeatureEvent event,
    Emitter<MyFeatureState> emit,
  ) async {
    await event.when(
      load: () => _onLoad(emit),
      refresh: () => _onRefresh(emit),
    );
  }

  Future<void> _onLoad(Emitter<MyFeatureState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    await safeNetworkCall(
      () async {
        final result = await _repository.getData();
        result.when(
          success: (data) => emit(state.copyWith(
            isLoading: false,
            data: data,
          )),
          failure: (failure) => emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          )),
        );
      },
      onError: (e) => emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      )),
    );
  }

  Future<void> _onRefresh(Emitter<MyFeatureState> emit) async {
    // Similar to _onLoad
  }
}
```

**src/bloc/my_feature_event.dart:**
```dart
part of 'my_feature_bloc.dart';

@freezed
sealed class MyFeatureEvent with _$MyFeatureEvent {
  const factory MyFeatureEvent.load() = _Load;
  const factory MyFeatureEvent.refresh() = _Refresh;
}
```

**src/bloc/my_feature_state.dart:**
```dart
part of 'my_feature_bloc.dart';

@freezed
sealed class MyFeatureState with _$MyFeatureState {
  const MyFeatureState._();

  const factory MyFeatureState({
    @Default(false) bool isLoading,
    @Default([]) List<MyModel> data,
    String? error,
  }) = _MyFeatureState;

  factory MyFeatureState.initial() => const MyFeatureState();

  bool get hasError => error != null;
  bool get hasData => data.isNotEmpty;
}
```

### Step 5: Create Repository Interface

**src/repository/my_repository.dart:**
```dart
import 'package:domain/domain.dart';

import '../models/my_model.dart';

/// Repository interface for MyFeature.
/// 
/// Implementation should be provided by the consuming app.
abstract class MyFeatureRepository {
  /// Gets list of data
  Future<Result<List<MyModel>>> getData();

  /// Gets single item by ID
  Future<Result<MyModel>> getById(String id);

  /// Creates new item
  Future<Result<MyModel>> create(MyModel item);

  /// Updates existing item
  Future<Result<MyModel>> update(MyModel item);

  /// Deletes item by ID
  Future<Result<void>> delete(String id);
}
```

**src/repository/repository.dart:**
```dart
export 'my_repository.dart';
```

### Step 6: Create Models

**src/models/my_model.dart:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isActive,
    DateTime? createdAt,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### Step 7: Create Navigation Interface

**src/navigation/my_navigation.dart:**
```dart
/// Navigation interface for MyFeature.
/// 
/// Implement this in your main app and register with GetIt.
abstract class MyFeatureNavigation {
  /// Navigate to detail screen
  void goToDetail(String id);

  /// Navigate to create screen
  void goToCreate();

  /// Navigate to edit screen
  void goToEdit(String id);

  /// Go back
  void goBack();

  /// Go to home
  void goToHome();
}
```

### Step 8: Create Page

**src/page/my_feature_page.dart:**
```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/my_feature_bloc.dart';
import '../l10n/l10n.dart';

@RoutePage()
class MyFeaturePage extends StatelessWidget implements AutoRouteWrapper {
  const MyFeaturePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<MyFeatureBloc>()
        ..add(const MyFeatureEvent.load()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.myFeatureL10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myFeatureTitle),
      ),
      body: BlocBuilder<MyFeatureBloc, MyFeatureState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.data != current.data ||
            previous.error != current.error,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.hasError) {
            return Center(child: Text(state.error!));
          }

          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              final item = state.data[index];
              return ListTile(
                title: Text(item.name),
                subtitle: item.description != null 
                    ? Text(item.description!) 
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
```

### Step 9: Create DI Configuration

**src/di/injection.dart:**
```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

@InjectableInit(
  initializerName: 'initMyFeaturePackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initMyFeaturePackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initMyFeaturePackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
```

### Step 10: Create Localization

**l10n.yaml:**
```yaml
arb-dir: l10n
template-arb-file: my_feature_en.arb
output-localization-file: my_feature_localizations.dart
output-class: MyFeatureLocalizations
output-dir: lib/src/l10n
nullable-getter: false
```

**l10n/my_feature_en.arb:**
```json
{
  "@@locale": "en",
  
  "myFeatureTitle": "My Feature",
  "@myFeatureTitle": {
    "description": "Title for my feature page"
  },
  
  "loading": "Loading...",
  "@loading": {
    "description": "Loading indicator text"
  },
  
  "error": "An error occurred",
  "@error": {
    "description": "Error message"
  }
}
```

**src/l10n/l10n.dart:**
```dart
export 'my_feature_localizations.dart';

import 'package:flutter/widgets.dart';

import 'my_feature_localizations.dart';

extension MyFeatureLocalizationsX on BuildContext {
  MyFeatureLocalizations get myFeatureL10n => MyFeatureLocalizations.of(this);
}
```

### Step 11: Add to Workspace

In root `pubspec.yaml`:
```yaml
workspace:
  - packages/feature/my_feature
```

Update l10n script if needed:
```yaml
melos:
  scripts:
    l10n:
      run: fvm dart run melos exec --concurrency=1 -- fvm flutter gen-l10n
      packageFilters:
        scope:
          - "flutter_app"
          - "feature_my_feature"
```

### Step 12: Generate Code

```bash
# Get dependencies
fvm dart run melos run pg

# Generate l10n
cd packages/feature/my_feature && fvm flutter gen-l10n

# Generate code
cd packages/feature/my_feature && fvm dart run build_runner build -d
```

## Using Feature Packages in Apps

### 1. Add Dependency

In app's `pubspec.yaml`:
```yaml
dependencies:
  feature_my_feature: any
```

### 2. Register DI

In app's `di/injection.dart`:
```dart
import 'package:feature_my_feature/my_feature.dart' as my_feature;

Future<void> configureDependencies() async {
  // ...
  my_feature.initMyFeaturePackage(getIt: getIt);
  // ...
}
```

### 3. Implement Repository

In app's `di/modules.dart`:
```dart
@LazySingleton(as: MyFeatureRepository)
class MyFeatureRepositoryImpl implements MyFeatureRepository {
  final Dio _dio;
  
  MyFeatureRepositoryImpl(this._dio);
  
  @override
  Future<Result<List<MyModel>>> getData() async {
    // Implement API call
  }
}
```

### 4. Implement Navigation

```dart
@Injectable()
class MyFeatureNavigationImpl implements MyFeatureNavigation {
  final AppRouter _router;
  
  MyFeatureNavigationImpl(this._router);
  
  @override
  void goToDetail(String id) {
    _router.push(MyFeatureDetailRoute(id: id));
  }
  
  // ... other methods
}
```

### 5. Add Routes

Create route definitions for feature pages:
```dart
class MyFeatureRoute extends PageRouteInfo<void> {
  const MyFeatureRoute({List<PageRouteInfo>? children})
      : super(MyFeatureRoute.name, initialChildren: children);

  static const String name = 'MyFeatureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => const WrappedRoute(child: MyFeaturePage()),
  );
}
```

### 6. Add Localization Delegate

In app's `app.dart`:
```dart
localizationsDelegates: const [
  AppLocalizations.delegate,
  MyFeatureLocalizations.delegate,  // Add feature l10n
  // ...
],
```

## Best Practices

### 1. Keep Features Independent
- Don't import other feature packages
- Only depend on `domain` for shared types
- Use navigation interfaces for cross-feature navigation

### 2. Abstract External Dependencies
- Use repository interfaces
- Use navigation interfaces
- Let the app provide implementations

### 3. Localization
- Each feature has its own ARB files
- Use descriptive key names with feature prefix
- Export l10n for app to include in delegates

### 4. Testing
- Write unit tests for BLoCs
- Write widget tests for pages
- Mock repositories in tests

## See Also

- [AUTH_PACKAGE.md](./AUTH_PACKAGE.md) - Example: Authentication feature
- [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md) - Monorepo overview
- [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md) - Creating new apps
