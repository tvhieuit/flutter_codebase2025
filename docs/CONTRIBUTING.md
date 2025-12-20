# Contributing

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Development Setup

1. **Install FVM** (Flutter Version Management):
   ```bash
   dart pub global activate fvm
   ```

2. **Install Flutter version**:
   ```bash
   fvm install
   fvm use
   ```

3. **Run setup script**:
   ```bash
   # Linux/Mac
   bash scripts/setup.sh
   
   # Windows
   powershell scripts/setup.ps1
   ```

## Architecture Rules

### Clean Architecture Compliance

- ✅ **DO**: Inject Use Cases into BLoCs
- ❌ **DON'T**: Inject Repositories directly into BLoCs
- ✅ **DO**: Use abstract interfaces for all repositories and use cases
- ✅ **DO**: Use `@injectable` annotations for dependency injection
- ✅ **DO**: Use `SafetyNetworkMixin` for network calls in BLoCs

### Code Style

- Always use `.sp` for font sizes (ScreenUtil)
- Always use `buildWhen` and `listenWhen` in BlocBuilder/BlocListener
- Always format code before committing: `fvm dart run melos exec -- fvm dart format .`
- Follow the 120-character line limit

### File Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/Methods: `camelCase`
- Constants: `UPPER_SNAKE_CASE`

## Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the architecture rules

3. **Generate code** after modifying entities, repositories, or use cases:
   ```bash
   fvm dart run melos exec -- fvm dart run build_runner build -d
   ```

4. **Format code**:
   ```bash
   fvm dart run melos exec -- fvm dart format .
   ```

5. **Test your changes**:
   ```bash
   fvm flutter test
   ```

6. **Commit your changes**:
   ```bash
   git commit -m "feat: Add your feature description"
   ```

## Code Generation

After modifying files with these annotations, you MUST run code generation:

- `@freezed` - Run build_runner
- `@injectable` - Run build_runner
- `@JsonSerializable` - Run build_runner
- `@auto_route` - Run build_runner
- Localization strings - Run `flutter gen-l10n`

## Testing

- Write unit tests for use cases
- Write widget tests for UI components
- Write BLoC tests for state management

## Pull Request Process

1. Ensure all code is formatted
2. Ensure all generated files are up to date
3. Ensure tests pass
4. Create a pull request with a clear description
5. Request review from team members

## Questions?

If you have questions about the architecture or contribution process, please open an issue or contact the maintainers.

