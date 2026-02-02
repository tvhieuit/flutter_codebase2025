# Project Structure

This document describes the complete structure of the Flutter monorepo workspace.

## Directory Structure Overview

```
flutter_codebase2025/
├── apps/                         # Flutter applications
│   └── flutter_app/              # Main multi-feature development app
├── packages/                     # Shared packages
│   ├── domain/                   # Core business logic
│   ├── feature/                  # Feature packages
│   │   ├── auth/                 # Authentication feature
│   │   └── app_settings/         # Application settings (Theme, Language)
│   ├── app_core/                 # Core shared configuration
│   ├── app_utility/              # Shared utilities
│   └── app_widget/               # Shared UI widgets
├── configs/                      # Environment configurations
├── docs/                         # Documentation
├── rules/                        # Architecture rules
├── scripts/                      # Setup scripts
└── pubspec.yaml                  # Workspace + Melos config
```

## Detailed Structure

### Root App (`apps/flutter_app/lib/`)

The main Flutter application:

```
lib/
├── app/
│   ├── app.dart                  # MaterialApp with routing & theme
│   ├── app_router.dart           # Auto Route configuration
│   ├── app_router.gr.dart        # Generated routes
│   └── auth_routes.dart          # Routes for feature_auth pages
├── di/
│   └── injection.dart            # GetIt configuration
├── extensions/
│   └── l10n_extension.dart       # Localization extension
├── l10n/                         # Generated localization
├── navigation/
│   └── auth_navigation_impl.dart # AuthNavigation implementation
├── repository/
│   └── auth_repository_impl.dart # AuthRepository implementation
├── screen/
│   ├── splash/
│   │   ├── splash_bloc.dart
│   │   ├── splash_event.dart
│   │   ├── splash_state.dart
│   │   └── splash_page.dart
│   └── user/
│       ├── user_bloc.dart
│       ├── user_event.dart
│       ├── user_state.dart
│       └── user_page.dart
├── screen/
│   ├── splash/
│   │   ├── splash_bloc.dart
│   │   ├── splash_event.dart
│   │   ├── splash_state.dart
│   │   └── splash_page.dart
│   └── user/
│       ├── user_bloc.dart
│       ├── user_event.dart
│       ├── user_state.dart
│       └── user_page.dart
├── widgets/
│   ├── app_loading.dart
│   ├── app_loading_button.dart
│   ├── network_status_indicator.dart
│   └── permission_dialog.dart
└── main.dart                     # Entry point
```

### Apps Directory (`apps/`)

Additional Flutter applications that share packages:

```
apps/
└── customer_app/
    ├── lib/
    │   ├── app/
    │   │   ├── app.dart          # MaterialApp
    │   │   ├── app_router.dart   # Routing
    │   │   └── auth_routes.dart  # Auth feature routes
    │   ├── di/
    │   │   ├── injection.dart    # DI setup
    │   │   └── modules.dart      # Implementations
    │   ├── l10n/                 # Generated l10n
    │   ├── screen/
    │   │   ├── splash/
    │   │   └── home/
    │   └── main.dart
    ├── l10n/
    │   └── app_en.arb
    ├── assets/
    │   ├── icon/
    │   └── image/
    ├── pubspec.yaml
    ├── l10n.yaml
    ├── build.yaml
    └── analysis_options.yaml
```

### Packages Directory (`packages/`)

#### Domain Package (`packages/domain/`)

Core business logic shared across all apps:

```
packages/domain/
├── lib/
│   ├── domain.dart               # Main export
│   └── src/
│       ├── annotations/          # Custom Freezed annotations
│       │   ├── annotations.dart
│       │   └── freezed_annotations.dart
│       ├── di/                   # Dependency injection
│       │   ├── di.dart
│       │   └── injection.dart
│       ├── entities/             # Business models
│       │   ├── entities.dart
│       │   └── user_entity.dart
│       ├── failures/             # Error types
│       │   ├── failures.dart
│       │   └── failure.dart
│       ├── mixins/               # Shared mixins
│       │   ├── mixins.dart
│       │   └── safety_network_mixin.dart
│       ├── repositories/         # Repository interfaces
│       │   ├── repositories.dart
│       │   ├── user_repository.dart
│       │   ├── impl/             # Implementations
│       │   │   └── user_repository_impl.dart
│       │   └── local/
│       │       ├── local.dart
│       │       ├── local_storage.dart
│       │       ├── local_storage_impl.dart
│       │       ├── local_storage_keys.dart
│       │       └── app_settings_repository.dart
│       ├── result/               # Result type
│       │   ├── result.dart
│       │   └── result.freezed.dart
│       └── use_cases/            # Business logic
│           ├── use_cases.dart
│           └── base_use_case.dart
└── pubspec.yaml
```

#### Feature Packages (`packages/feature/`)

Self-contained features:

```
packages/feature/auth/
├── lib/
│   ├── auth.dart                 # Main export
│   └── src/
│       ├── bloc/
│       │   ├── login_bloc.dart
│       │   ├── login_event.dart
│       │   ├── login_state.dart
│       │   ├── register_bloc.dart
│       │   ├── register_event.dart
│       │   └── register_state.dart
│       ├── page/
│       │   ├── pages.dart
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       ├── models/
│       │   ├── models.dart
│       │   ├── auth_credentials.dart
│       │   └── auth_token.dart
│       ├── repository/
│       │   ├── repository.dart
│       │   └── auth_repository.dart
│       ├── navigation/
│       │   ├── navigation.dart
│       │   └── auth_navigation.dart
│       ├── l10n/
│       │   ├── l10n.dart
│       │   └── auth_localizations.dart
│       └── di/
│           ├── di.dart
│           └── injection.dart
├── l10n/
│   └── auth_en.arb
├── pubspec.yaml
├── l10n.yaml
└── build.yaml
```

**app_settings** - Theme and Language settings:
```
packages/feature/app_settings/
├── lib/
│   ├── app_settings.dart         # Main export
│   └── src/
│       ├── bloc/                 # AppSettingsBloc
│       ├── sheet/                # AppSettingsPage
│       ├── l10n/                 # Package-level l10n
│       └── di/                   # Injection configuration
├── l10n/                         # ARB files
├── pubspec.yaml
└── l10n.yaml
```

#### Utility Packages

**app_utility** - Extensions and helpers:
```
packages/app_utility/
├── lib/
│   ├── app_utility.dart
│   └── src/
│       ├── extensions/
│       │   ├── extensions.dart
│       │   ├── context_extension.dart
│       │   ├── date_time_extension.dart
│       │   ├── iterable_extension.dart
│       │   ├── number_extension.dart
│       │   └── string_extension.dart
│       ├── helpers/
│       │   ├── helpers.dart
│       │   └── log_helper.dart
│       └── types/
│           ├── types.dart
│           └── typedefs.dart
└── pubspec.yaml
```

**app_widget** - Shared UI components:
```
packages/app_widget/
├── lib/
│   ├── app_widget.dart
│   └── src/
│       └── buttons/
│           ├── buttons.dart
│           └── app_primary_button.dart
└── pubspec.yaml
```

### Configuration Files

```
├── .fvmrc                        # Flutter version (3.35.2)
├── .gitignore                    # Git ignore rules
├── analysis_options.yaml         # Dart analyzer config
├── build.yaml                    # Build runner config
├── l10n.yaml                     # Root app l10n config
├── pubspec.yaml                  # Workspace + Melos config
└── override_dependencies.yaml    # Version overrides (if needed)
```

### Environment Configuration

```
configs/
├── dev.json                      # Development config
├── stg.json                      # Staging config
└── beta.json                     # Beta/production config
```

## Workspace Configuration

The workspace is defined in `pubspec.yaml`:

```yaml
workspace:
  - apps/customer_app
  - packages/app_utility
  - packages/app_widget
  - packages/domain
  - packages/feature/auth
```

## Layer Architecture

### Presentation Layer
- **Location**: `lib/screen/`, `apps/*/lib/screen/`, `packages/feature/*/lib/src/page/`
- **Pattern**: BLoC with Freezed states
- **Key Files**: `*_bloc.dart`, `*_event.dart`, `*_state.dart`, `*_page.dart`

### Business Logic Layer
- **Location**: `lib/use_case/`, `packages/domain/lib/src/use_cases/`
- **Pattern**: Single-responsibility use cases
- **Key Files**: `*_use_case.dart`

### Data Layer
- **Location**: `lib/repository/`, `packages/domain/lib/src/repositories/`
- **Pattern**: Repository pattern with interfaces
- **Key Files**: `*_repository.dart`, `*_repository_impl.dart`

### Domain Layer
- **Location**: `packages/domain/`
- **Pattern**: Clean Architecture core
- **Key Files**: Entities, Failures, Result type

## Dependency Flow

```
┌─────────────────────────────────────────────────────────────┐
│                          Apps                                │
│  ┌─────────────┐  ┌─────────────┐                           │
│  │ flutter_app │  │ customer_app│                           │
│  └──────┬──────┘  └──────┬──────┘                           │
└─────────┼────────────────┼──────────────────────────────────┘
          │                │
          ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                    Feature Packages                          │
│  ┌─────────────┐                                            │
│  │ feature_auth│                                            │
│  └──────┬──────┘                                            │
└─────────┼───────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                      Core Packages                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   domain    │  │ app_utility │  │ app_widget  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Generated Files

Do NOT edit manually:

- `**/injection.config.dart` - Injectable generator
- `**/*.freezed.dart` - Freezed generator
- `**/*.g.dart` - JSON serializable / build_runner
- `**/l10n/*.dart` - Localization generator
- `**/*.gr.dart` - Auto route generator

## Quick Reference

### Key Melos Scripts

```bash
fvm dart run melos run pg      # Get dependencies
fvm dart run melos run brd     # Build runner with -d flag
fvm dart run melos run l10n    # Generate localizations
fvm dart run melos run fm      # Format code
```

### Creating New Features

1. **In root app**: Add files to `lib/screen/your_feature/`
2. **As package**: Create `packages/feature/your_feature/`
3. **For new app**: Create `apps/your_app/`

See detailed guides:
- [NEW_APP_GUIDE.md](./NEW_APP_GUIDE.md)
- [FEATURE_PACKAGES.md](./FEATURE_PACKAGES.md)
- [SCREEN_TEMPLATE.md](./SCREEN_TEMPLATE.md)

## See Also

- [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md) - Monorepo overview
- [DOMAIN_PACKAGE.md](./DOMAIN_PACKAGE.md) - Domain package details
- [AUTH_PACKAGE.md](./AUTH_PACKAGE.md) - Auth feature package
- [QUICK_START.md](./QUICK_START.md) - Getting started
- [COMMANDS.md](./COMMANDS.md) - Available commands
