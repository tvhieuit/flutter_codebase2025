# Flutter Clean Architecture Project

A Flutter application in a Melos-managed monorepo, following Clean Architecture principles with BLoC pattern, dependency injection, and auto routing.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK managed by FVM (see `.fvmrc` for the exact version)
- Dart SDK compatible with the Flutter version in this workspace

### Setup
```bash
# Install FVM and use project Flutter version
fvm use

# Get dependencies
fvm dart run melos run pg

# Generate code
fvm dart run melos run brd

# Run app
fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json
```

👉 **Full setup guide**: [docs/QUICK_START.md](./docs/QUICK_START.md)

## 📁 Project Structure (Monorepo)

```
.
├── lib/                     # Main application
│   ├── app/                 # App configuration & routing
│   ├── app_mixin/           # Shared mixins (SafetyNetworkMixin)
│   ├── di/                  # Dependency Injection (GetIt + Injectable)
│   ├── screen/              # Feature screens (BLoC + UI)
│   ├── use_case/            # Business logic layer
│   ├── repository/          # Data layer
│   ├── entities/            # Data models (Freezed)
│   ├── extensions/          # App-wide extensions
│   ├── services/            # External services
│   ├── widgets/             # Reusable UI components
│   └── main.dart            # Entry point
└── packages/                # Workspace packages (Melos)
    ├── app_utility/         # Shared extensions, helpers, and types
    │   └── lib/
    │       └── src/
    │           ├── extensions/  # Context, string, number extensions, etc.
    │           ├── helpers/     # Logging, helpers
    │           └── types/       # Shared typedefs and types
    └── app_widget/          # Shared UI widgets
        └── lib/
            └── src/
                └── buttons/     # Common button widgets, etc.
```

👉 **Detailed structure**: [docs/PROJECT_STRUCTURE.md](./docs/PROJECT_STRUCTURE.md)

## 🏗️ Architecture

### Clean Architecture Layers
- **Presentation** (BLoC) → **Business Logic** (Use Cases) → **Data** (Repositories)
- Dependency flow: UI → Use Cases → Repositories → Data Sources

### Key Technologies
- **State Management**: BLoC Pattern with `flutter_bloc`
- **Dependency Injection**: GetIt + Injectable
- **Routing**: Auto Route
- **Code Generation**: Freezed, Build Runner
- **Network**: Dio + Retrofit

👉 **Architecture rules**: [rules/clean_architecture.md](./rules/clean_architecture.md)

## 📚 Documentation

### For New Contributors
- [Quick Start Guide](./docs/QUICK_START.md) - Get up and running
- [Project Structure](./docs/PROJECT_STRUCTURE.md) - Understand the codebase
- [Commands Reference](./docs/COMMANDS.md) - Available commands

### For Development
- [Screen Template](./docs/SCREEN_TEMPLATE.md) - Create new features
- [Routing Guide](./docs/ROUTING.md) - Navigation and routing
- [Splash Screen Setup](./docs/SPLASH_SCREEN_SETUP.md) - Implementation example
- [Contributing Guidelines](./docs/CONTRIBUTING.md) - How to contribute

### Rules & Standards
- [Clean Architecture](./rules/clean_architecture.md) - Architecture principles
- [BLoC Pattern](./rules/bloc_pattern.md) - State management rules
- [Code Style](./rules/code_style.md) - Formatting and naming conventions

## 🔧 Common Commands

```bash
# Get dependencies
fvm dart run melos run pg

# Generate code (freezed, injectable, auto_route)
fvm dart run melos run brd

# Format code
fvm dart run melos run fm

# Generate localization
fvm dart run melos run l10n

# Run tests
fvm dart run melos run test

# Build APK
fvm dart run melos run aos:devapk
```

👉 **All commands**: [docs/COMMANDS.md](./docs/COMMANDS.md)

## 🎯 Creating a New Feature

Follow the standard pattern:

1. **Create BLoC** with `@injectable` and `SafetyNetworkMixin`
2. **Create Events & State** with `@freezed`
3. **Create Page** with `@RoutePage()` and `AutoRouteWrapper`
4. **Add Route** to `app_router.dart`
5. **Run Code Generation**: `fvm dart run melos run brd`

👉 **Full template**: [docs/SCREEN_TEMPLATE.md](./docs/SCREEN_TEMPLATE.md)

## 📋 Project Features

### ✅ Implemented
- Splash screen with BLoC
- Auto Route navigation
- Dependency injection setup
- SafetyNetworkMixin for API calls
- Freezed for immutable models
- Clean Architecture structure

### 🚧 To Be Implemented
- Authentication flow
- Home screen
- API integration
- Local storage
- Error handling UI
- Loading states

## 🛠️ Tech Stack

### Core
- Flutter (managed by FVM)
- Dart (version aligned with Flutter SDK)

### State Management & Architecture
- flutter_bloc ^9.1.1
- get_it ^9.2.0
- injectable ^2.7.1+2

### Code Generation
- freezed ^2.5.2
- build_runner ^2.4.13
- auto_route_generator ^7.3.2

### Networking
- dio ^5.9.0
- retrofit ^4.9.1

### Local Storage
- shared_preferences ^2.5.4

## 📖 Learning Resources

- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Auto Route Documentation](https://pub.dev/packages/auto_route)
- [Injectable Documentation](https://pub.dev/packages/injectable)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## 🤝 Contributing

Please read [CONTRIBUTING.md](./docs/CONTRIBUTING.md) before submitting pull requests.

## 📝 License

This project is licensed under the MIT License.

---

**Need Help?** Check the [docs](./docs/) folder for comprehensive guides.
