# Flutter Clean Architecture Project

A Flutter application following Clean Architecture principles with Feature-Based Architecture.

## Architecture

This project follows Clean Architecture with the following layers:

- **Presentation Layer** (`lib/screen/`): BLoC pattern for state management
- **Business Logic Layer** (`lib/use_case/`): Use cases for business logic
- **Data Layer** (`lib/repository/`): Repository pattern for data access
- **Domain Layer** (`lib/entities/`): Domain models using Freezed

## Project Structure

```
lib/
├── app/                    # App configuration & routing
├── app_mixin/             # Shared mixins
├── assets/                # Asset utilities
├── converter/             # Data converters
├── di/                    # Dependency Injection
├── entities/              # Data models & entities
├── extension/             # Extension methods
├── l10n/                  # Localization
├── map/                   # Map related features
├── repository/            # Data layer
├── screen/                # UI screens & features
├── services/              # External services
├── use_case/              # Business logic
├── utils/                 # Utility classes
└── widgets/               # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK 3.35.2 (managed via FVM)
- FVM (Flutter Version Management)
- Melos (for monorepo management)

### Setup

1. Install FVM:
```bash
dart pub global activate fvm
```

2. Install Flutter version:
```bash
fvm install 3.35.2
fvm use 3.35.2
```

3. Install dependencies:
```bash
fvm dart run melos exec -- fvm dart pub get --no-example
```

4. Generate code:
```bash
fvm dart run melos exec -- fvm dart run build_runner build -d
fvm dart run melos exec -- fvm flutter gen-l10n
```

5. Run the app:
```bash
fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json
```

## Development Rules

### Code Formatting

Always format code before committing:
```bash
fvm dart run melos exec -- fvm dart format .
```

### Code Generation

After modifying files with annotations (@freezed, @injectable, etc.):
```bash
fvm dart run melos exec -- fvm dart run build_runner build -d
```

### Architecture Rules

- **NEVER** inject repositories directly into BLoCs - use Use Cases instead
- **ALWAYS** use abstract interfaces for repositories and use cases
- **ALWAYS** use @injectable annotations for dependency injection
- **ALWAYS** use SafetyNetworkMixin for network calls in BLoCs
- **ALWAYS** use buildWhen/listenWhen in BlocBuilder/BlocListener

## Dependencies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it + injectable
- **Code Generation**: freezed, json_serializable, build_runner
- **Networking**: dio
- **Local Storage**: shared_preferences
- **UI**: flutter_screenutil for responsive design

## License

[Your License Here]

