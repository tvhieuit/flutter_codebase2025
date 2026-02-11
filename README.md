# Flutter Clean Architecture Monorepo

A Flutter monorepo workspace following Clean Architecture principles with BLoC pattern, dependency injection, and shared packages.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK managed by FVM (version 3.35.2 - see `.fvmrc`)
- Dart SDK >= 3.9.0

### Setup
```bash
# Install FVM and use project Flutter version
fvm use

# Get dependencies for all packages
fvm dart run melos run pg

# Generate code (freezed, injectable, auto_route)
fvm dart run melos run brd

# Generate localizations
fvm dart run melos run l10n

# Run main app (from repo root)
fvm dart run melos run run:flutter_app

# Or from app directory
cd apps/flutter_app && fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json
```

👉 **Full setup guide**: [docs/quick_start.md](./docs/quick_start.md)

## 📁 Project Structure

```
flutter_codebase2025/
├── apps/                         # Flutter app(s)
│   └── flutter_app/              # Main application
├── packages/                     # Shared packages
│   ├── app_core/                 # Core shared (Result, Failure, annotations)
│   ├── domain/                   # Business logic (entities, use cases, repo interfaces)
│   ├── data/                     # Data layer (repo implementations, network, storage)
│   ├── feature/                  # Feature packages
│   │   ├── auth/                 # Authentication (login, register)
│   │   └── app_settings/         # App settings (theme, language)
│   ├── app_utility/              # Shared extensions & helpers
│   └── app_widget/               # Shared UI widgets
├── configs/                      # Environment configs (dev, stg, beta)
├── docs/                         # Documentation
└── pubspec.yaml                  # Workspace + Melos configuration
```

👉 **Detailed structure**: [docs/project_structure.md](./docs/project_structure.md)

## 🏗️ Architecture

### Clean Architecture Layers
```
Presentation (BLoC) → Domain (Use Cases + Repo Interfaces) ← Data (Repo Implementations)
```

### Monorepo Benefits
- **Shared Code**: Domain logic, features, and widgets shared across apps
- **Independent Apps**: Each app can have its own configuration and dependencies
- **Feature Packages**: Self-contained features that can be reused
- **Consistent Tooling**: Single Melos configuration for all packages

👉 **Monorepo guide**: [docs/monorepo_guide.md](./docs/monorepo_guide.md)

## 📦 Packages

| Package | Description |
|---------|-------------|
| `app_core` | Core shared: Result type, Failure, custom annotations, base services |
| `domain` | Business logic: entities, use cases, repository interfaces (pure Dart) |
| `data` | Data layer: repository implementations, network (Dio), local storage |
| `feature_auth` | Authentication feature (login, register, navigation) |
| `feature_app_settings` | App settings feature (theme mode, language) |
| `app_utility` | Extensions, helpers, type definitions |
| `app_widget` | Reusable UI components |

## 🔧 Common Commands

```bash
# Dependencies
fvm dart run melos run pg          # Get dependencies
fvm dart run melos run pu          # Upgrade dependencies

# Code Generation
fvm dart run melos run brd         # Build runner (delete conflicts)
fvm dart run melos run l10n        # Generate localizations

# Code Quality
fvm dart run melos run fm          # Format code
fvm dart run melos run fix         # Apply dart fixes

# Testing
fvm dart run melos run test        # Run tests

# Building
fvm dart run melos run aos:devapk  # Build Android APK (dev)
fvm dart run melos run ios:dev     # Build iOS (dev)
```

👉 **All commands**: [docs/commands.md](./docs/commands.md)

## 📚 Documentation

### Getting Started
- [Quick Start Guide](./docs/quick_start.md) - Setup and run
- [Project Structure](./docs/project_structure.md) - File organization
- [Commands Reference](./docs/commands.md) - Available scripts

### Monorepo & Packages
- [Monorepo Guide](./docs/monorepo_guide.md) - Working with the workspace
- [Feature Packages](./docs/feature_packages.md) - Creating feature packages
- [New App Guide](./docs/new_app_guide.md) - Adding new apps
- [Domain Package](./docs/domain_package.md) - Domain layer (entities, use cases, interfaces)
- [Data Package](./docs/data_package.md) - Data layer (implementations, network, storage)
- [Auth Package](./docs/auth_package.md) - Authentication feature

### Development
- [Screen Template](./docs/screen_template.md) - Creating new screens
- [Routing Guide](./docs/routing.md) - Navigation setup
- [Localization](./docs/localization.md) - i18n implementation
- [Services](./docs/services.md) - Network & permissions

### Architecture Rules
- [Clean Architecture](./rules/clean_architecture.md)
- [BLoC Pattern](./rules/bloc_pattern.md)
- [Code Style](./rules/code_style.md)

## 🎯 Creating New Features

### In Root App
```bash
# Create BLoC, events, state, and page
# Add to lib/screen/my_feature/
fvm dart run melos run brd
```

### As Feature Package
```bash
# Create package structure
mkdir -p packages/feature/my_feature/lib/src/{bloc,page,models,repository,di}
# See docs/feature_packages.md for full guide
```

### New App
```bash
# Create app in apps/
mkdir -p apps/my_app/lib/{app,screen,di}
# See docs/new_app_guide.md for full guide
```

👉 **Templates**: [docs/screen_template.md](./docs/screen_template.md)

## 🛠️ Tech Stack

### Core
- **Flutter**: 3.35.2 (via FVM)
- **Dart**: >= 3.9.0
- **Melos**: Monorepo management

### State Management & Architecture
- flutter_bloc ^9.1.1
- get_it ^9.2.0
- injectable ^2.7.1+2

### Code Generation
- freezed ^3.2.4
- build_runner ^2.4.13
- auto_route_generator ^10.4.0

### Networking
- dio ^5.9.0
- retrofit ^4.9.1

### Local Storage
- shared_preferences ^2.5.4

## 📋 Architecture Rules

### ✅ DO
- Use `@injectable` for all BLoCs
- Use `SafetyNetworkMixin` for API calls
- Use `@freezed` for states and events
- Use `buildWhen` and `listenWhen` in BLoC widgets
- Inject Use Cases, not Repositories directly
- Use `Result<T>` for error handling

### ❌ DON'T
- Inject Repositories directly in BLoCs
- Skip `buildWhen`/`listenWhen`
- Make direct API calls in BLoCs
- Use mutable states
- Throw exceptions (use Result type)

## 🤝 Contributing

1. Read [contributing.md](./docs/contributing.md)
2. Follow architecture rules
3. Add tests for new features
4. Run code generation before committing
5. Format code with `fvm dart run melos run fm`

## 📖 Learning Resources

- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Auto Route Documentation](https://pub.dev/packages/auto_route)
- [Injectable Documentation](https://pub.dev/packages/injectable)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Melos Documentation](https://melos.invertase.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 📝 License

This project is licensed under the MIT License.

---

**Need Help?** Check the [docs](./docs/) folder for comprehensive guides.
