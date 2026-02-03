# Monorepo Guide

This project uses a **Flutter Workspace** with **Melos** for managing multiple packages and apps in a single repository.

## Overview

```
flutter_codebase2025/
├── apps/                    # Flutter app(s)
│   └── flutter_app/        # Main application
├── packages/                # Shared packages
│   ├── domain/              # Domain layer (entities, repositories, use cases)
│   ├── feature/             # Feature packages
│   │   └── auth/            # Authentication feature
│   ├── app_utility/         # Shared utilities and extensions
│   └── app_widget/          # Shared UI widgets
├── lib/                     # Main/root app (flutter_app)
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
  - packages/feature/auth
  - packages/feature/app_settings
  - packages/app_core
```

## Package Types

### 1. Domain Package (`packages/domain/`)

Core business logic shared across all apps:
- **Entities**: Business models with `@freezed`
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic operations
- **Result Type**: Type-safe error handling
- **Failures**: Sealed failure types
- **Local Storage**: SharedPreferences abstraction

```dart
// Usage in any app
import 'package:domain/domain.dart';

final result = await userRepository.getUser(id);
result.when(
  success: (user) => print(user.name),
  failure: (failure) => print(failure.message),
);
```

### 2. Feature Packages (`packages/feature/`)

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

### 3. Utility Packages

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

### 4. Apps (`apps/`)

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
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ feature_auth│  │feature_home │  │feature_cart │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
└─────────┼────────────────┼────────────────┼─────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                      Core Packages                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   domain    │  │ app_utility │  │ app_widget  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

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

See [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md) for detailed instructions.

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
- Feature packages depend on `domain` only
- Apps depend on features and core packages
- Avoid circular dependencies

### 2. Code Sharing
- Put business logic in `domain`
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

- [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - Detailed file structure
- [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md) - Creating new apps
- [FEATURE_PACKAGES.md](./FEATURE_PACKAGES.md) - Creating feature packages
- [DOMAIN_PACKAGE.md](./DOMAIN_PACKAGE.md) - Domain package documentation
