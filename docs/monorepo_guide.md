# Monorepo Guide

This project uses a **Flutter Workspace** with **Melos** for managing multiple packages and apps in a single repository.

## Overview

```
flutter_codebase2025/
├── apps/                    # Flutter app(s)
│   └── flutter_app/        # Main application
├── packages/                # Shared packages
│   ├── app_core/            # Core shared (Result, Failure, annotations)
│   ├── domain/              # Domain layer (entities, use cases, repo interfaces)
│   ├── data/                # Data layer (repo implementations, network, storage)
│   ├── feature/             # Feature packages
│   │   ├── auth/            # Authentication feature
│   │   └── app_settings/    # App settings (theme, language)
│   ├── app_utility/         # Shared utilities and extensions
│   └── app_widget/          # Shared UI widgets
├── pubspec.yaml             # Workspace config + Melos scripts
└── melos.yaml               # (Optional) Separate Melos config
```

## Workspace Configuration

The workspace is defined in the root `pubspec.yaml`:

```yaml
workspace:
  - apps/flutter_app
  - packages/app_utility
  - packages/app_widget
  - packages/domain
  - packages/data
  - packages/feature/auth
  - packages/feature/app_settings
  - packages/app_core
```

## Package Types

### 1. Domain Package (`packages/domain/`)

Pure business logic shared across all apps (no infrastructure dependencies):
- **Entities**: Business models with `@freezed`
- **Repository Interfaces**: Abstract interfaces for data access (NO implementations)
- **Use Cases**: Business logic operations
- **Result Type**: Type-safe error handling (from `app_core`)
- **Failures**: Sealed failure types (from `app_core`)

```dart
// Usage in any app
import 'package:domain/domain.dart';

final result = await getUserUseCase(userId);
final failure = result.failureOrNull;
if (failure != null) {
  print(failure.message);
  return;
}

final user = result.dataOrThrow;
print(user.name);
```

### 2. Data Package (`packages/data/`)

Data layer containing repository implementations and infrastructure:
- **Repository Implementations**: Concrete implementations using Dio, SharedPreferences
- **Network**: Auth interceptor, Dio configuration
- **Storage**: Storage key constants, LocalStorage implementation
- **DI Module**: Provides Dio, SharedPreferencesAsync instances

```dart
// Data package is imported by the app, not by features
// It registers implementations for domain interfaces via DI
import 'package:data/data.dart';

// In app's DI setup
initDataPackage();
```

### 3. Feature Packages (`packages/feature/`)

Self-contained features that can be shared across apps:
- **feature_auth**: Authentication (login, register, logout)
- Each feature has its own:
  - BLoCs
  - Pages
  - Models
  - Repository interfaces
  - Localization (l10n)
  - DI configuration

```dart
// Usage in app
import 'package:feature_auth/auth.dart';

// Register DI
initAuthPackage(getIt: getIt);

// Use pages
AutoRoute(page: LoginRoute.page),
```

### 4. Utility Packages

**app_utility** - Shared extensions and helpers:
```dart
import 'package:app_utility/app_utility.dart';

// String extensions
'hello'.capitalize(); // 'Hello'

// DateTime extensions
DateTime.now().toFormattedString();

// Number extensions
1000.toCurrency(); // '$1,000.00'
```

**app_widget** - Shared UI components:
```dart
import 'package:app_widget/app_widget.dart';

AppPrimaryButton(
  text: 'Submit',
  onPressed: () {},
)
```

### 5. Apps (`apps/`)

- **flutter_app**: Main Flutter application using shared packages
- Has its own routing, DI, localization, and platform configs (android/, ios/)

## Dependency Flow

```
┌─────────────────────────────────────────────────────────────┐
│                          Apps                                │
│  ┌─────────────┐                                            │
│  │ flutter_app │                                            │
│  └──────┬──────┘                                            │
└─────────┼──────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Feature Packages                          │
│  ┌─────────────┐  ┌──────────────────┐                      │
│  │ feature_auth│  │feature_app_settings│                    │
│  └──────┬──────┘  └────────┬─────────┘                      │
└─────────┼──────────────────┼────────────────────────────────┘
          │                  │
          ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                      Core Packages                           │
│  ┌──────────┐  ┌──────────┐  ┌─────────────┐  ┌──────────┐ │
│  │  domain  │  │   data   │  │ app_utility │  │app_widget│ │
│  └────┬─────┘  └────┬─────┘  └─────────────┘  └──────────┘ │
│       │              │                                       │
│       └──────┬───────┘                                       │
│              ▼                                               │
│        ┌──────────┐                                          │
│        │ app_core │                                          │
│        └──────────┘                                          │
└─────────────────────────────────────────────────────────────┘
```

**Key**: `data` depends on `domain` (implements its interfaces). `domain` depends only on `app_core`.

## Melos Scripts

All commands are defined in `pubspec.yaml` under `melos:`:

```bash
# Get dependencies for all packages
fvm dart run melos run pg

# Generate code for all packages
fvm dart run melos run brd

# Generate localization
fvm dart run melos run l10n

# Format all code
fvm dart run melos run fm

# Run tests
fvm dart run melos run test
```

## Creating New Packages

### Create a Feature Package

```bash
mkdir -p packages/feature/my_feature/lib/src/{bloc,page,models,repository,di}
```

Create `pubspec.yaml`:
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
  domain: any
  flutter_bloc: any
  get_it: any
  injectable: any
  freezed_annotation: any
  auto_route: any

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: any
  freezed: any
  injectable_generator: any
  auto_route_generator: any
```

Add to workspace in root `pubspec.yaml`:
```yaml
workspace:
  - packages/feature/my_feature
```

### Create a New App

See [new_app_guide.md](./new_app_guide.md) for detailed instructions.

## Dependency Resolution

All packages use `resolution: workspace` in their `pubspec.yaml`:

```yaml
resolution: workspace
```

This means:
- Dependencies are resolved from the root workspace
- Version constraints use `any` (resolved by root)
- No version conflicts between packages

## Best Practices

### 1. Package Dependencies
- Feature packages depend on `domain` only (not `data`)
- `data` depends on `domain` (implements its interfaces)
- `domain` depends only on `app_core` (no Dio, no SharedPreferences)
- Apps depend on features, `data`, and core packages
- Avoid circular dependencies

### 2. Code Sharing
- Put business logic (use cases, entities, repo interfaces) in `domain`
- Put repository implementations, network, storage in `data`
- Put reusable UI in `app_widget`
- Put utilities in `app_utility`
- Put feature-specific code in feature packages

### 3. Versioning
- All packages use `version: 0.0.1`
- Root workspace controls actual versions
- Use `dependency_overrides` only when necessary

### 4. Testing
- Each package has its own tests
- Integration tests live in apps
- Use `fvm dart run melos run test` to run all

## Troubleshooting

### "Package not found"
```bash
# Re-run pub get for all packages
fvm dart run melos run pg
```

### "Generated files missing"
```bash
# Run build_runner for all packages
fvm dart run melos run brd
```

### "Conflicting dependencies"
```yaml
# Add to root pubspec.yaml
dependency_overrides:
  package_name: ^x.y.z
```

### "Package not in workspace"
Add the package path to `workspace:` in root `pubspec.yaml`:
```yaml
workspace:
  - packages/my_new_package
```

## See Also

- [project_structure.md](./project_structure.md) - Detailed file structure
- [new_app_guide.md](./new_app_guide.md) - Creating new apps
- [feature_packages.md](./feature_packages.md) - Creating feature packages
- [domain_package.md](./domain_package.md) - Domain package documentation
- [data_package.md](./data_package.md) - Data package documentation
