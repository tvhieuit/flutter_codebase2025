# Project Structure

This document describes the complete structure of the Flutter project.

## Directory Structure (Monorepo / Workspace)

The repository is a single Flutter workspace that also embeds Melos configuration in `pubspec.yaml`.  
The root package is the main app, and additional shared code lives under `packages/`.

```
.
├── configs/                  # Environment configuration files (dev/stg/beta)
├── lib/                      # Main application
│   ├── app/                  # App configuration & routing
│   │   ├── app.dart          # Main app widget
│   │   ├── app_router.dart   # Auto Route configuration
│   │   └── app_router.gr.dart# Generated routes
│   ├── app_mixin/            # Shared mixins
│   │   └── safety_network_mixin.dart
│   ├── di/                   # Dependency Injection
│   │   ├── di_module.dart    # DI modules / external dependencies
│   │   └── injection.dart    # GetIt configuration (generated config lives in injection.config.dart)
│   ├── entities/             # Domain models (Freezed)
│   │   └── user_model.dart
│   ├── extensions/           # Extension methods
│   │   └── l10n_extension.dart
│   ├── l10n/                 # Localization (generated)
│   ├── repository/           # Data layer
│   │   ├── remote_repository.dart
│   │   └── local_repository.dart
│   ├── screen/               # UI screens (feature-based)
│   │   ├── splash/
│   │   │   ├── splash_bloc.dart
│   │   │   ├── splash_event.dart
│   │   │   ├── splash_page.dart
│   │   │   └── splash_state.dart
│   │   └── user/
│   │       ├── user_bloc.dart
│   │       ├── user_event.dart
│   │       ├── user_page.dart
│   │       └── user_state.dart
│   ├── services/             # External services
│   │   ├── network_service.dart
│   │   └── permission_service.dart
│   ├── use_case/             # Business logic layer
│   │   └── user_use_case.dart
│   ├── widgets/              # Reusable UI components
│   │   ├── app_loading.dart
│   │   ├── app_loading_button.dart
│   │   ├── network_status_indicator.dart
│   │   └── permission_dialog.dart
│   └── main.dart             # App entry point
├── packages/                 # Workspace / monorepo packages
│   ├── app_utility/
│   │   ├── lib/
│   │   │   ├── app_utility.dart
│   │   │   └── src/
│   │   │       ├── extensions/
│   │   │       │   ├── context_extension.dart
│   │   │       │   ├── date_time_extension.dart
│   │   │       │   ├── iterable_extension.dart
│   │   │       │   ├── number_extension.dart
│   │   │       │   └── string_extension.dart
│   │   │       ├── helpers/
│   │   │       │   ├── helpers.dart
│   │   │       │   └── log_helper.dart
│   │   │       └── types/
│   │   │           ├── types.dart
│   │   │           └── typedefs.dart
│   │   └── pubspec.yaml      # Package-specific dependencies
│   └── app_widget/
│       ├── lib/
│       │   ├── app_widget.dart
│       │   └── src/
│       │       └── buttons/
│       │           └── app_primary_button.dart
│       └── pubspec.yaml      # Package-specific dependencies
├── l10n/                     # Localization ARB files
│   └── lang_en.arb
├── scripts/                  # Setup and utility scripts
│   ├── setup.sh
│   └── setup.ps1
├── .fvmrc                    # FVM Flutter version
├── .gitignore                # Git ignore rules
├── analysis_options.yaml     # Dart analyzer config
├── build.yaml                # Build runner config
├── devtools_options.yaml     # DevTools configuration
├── l10n.yaml                 # Localization config
├── override_dependencies.yaml# Workspace overrides (if needed)
├── pubspec.yaml              # Flutter workspace, app, and Melos configuration
├── README.md                 # Project documentation
└── docs/PROJECT_STRUCTURE.md # This file
```

## Layer Architecture

### Presentation Layer (`lib/screen/`)
- **BLoC Pattern**: State management using flutter_bloc
- **Feature-based**: Each feature has its own directory
- **Separation**: Each screen has separate bloc, event, state, and page files

### Business Logic Layer (`lib/use_case/`)
- **Single Responsibility**: Each use case handles one business operation
- **Abstract Interfaces**: All use cases have abstract interfaces
- **Dependency Injection**: Uses injectable for DI

### Data Layer (`lib/repository/`)
- **Repository Pattern**: Abstract interfaces for data access
- **Multiple Sources**: Remote and local repositories
- **Implementation**: Concrete implementations with @Injectable

### Domain Layer (`lib/entities/`)
- **Freezed**: Immutable data classes
- **JSON Serialization**: Auto-generated from/to JSON
- **Type Safety**: Strong typing with nullable support

## Key Files

### Entry Point
- `lib/main.dart`: App initialization and MaterialApp setup

### Dependency Injection
- `lib/di/di.dart`: GetIt configuration
- `lib/di/modules/`: DI modules for third-party dependencies

### State Management
- `lib/app_mixin/safety_network_mixin.dart`: Mixin for safe network calls
- BLoC files in `lib/screen/*/`: Feature-specific state management

### Utilities
- `lib/utils/app_error.dart`: Error handling with Freezed
- `lib/utils/validators.dart`: Input validation helpers
- `lib/utils/environment.dart`: Environment configuration

## Generated Files

The following files are generated and should NOT be edited manually:

- `lib/di/di.config.dart`: Generated by injectable_generator
- `lib/**/*.freezed.dart`: Generated by freezed
- `lib/**/*.g.dart`: Generated by json_serializable/build_runner
- `lib/l10n/*.dart`: Generated by flutter gen-l10n
- `lib/app/routes/app_router.gr.dart`: Generated by auto_route_generator

## Next Steps

After cloning the repository:

1. Run setup script: `bash scripts/setup.sh` or `powershell scripts/setup.ps1`
2. Generate code: `fvm dart run melos exec -- fvm dart run build_runner build -d`
3. Run the app: `fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json`

