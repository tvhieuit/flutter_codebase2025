# Commands Reference

All commands use FVM + Melos for consistency across the monorepo workspace.

## Quick Reference

| Command | Description |
|---------|-------------|
| `fvm dart run melos run pg` | Get dependencies for all packages |
| `fvm dart run melos run brd` | Generate code (freezed, injectable, auto_route) |
| `fvm dart run melos run l10n` | Generate localizations |
| `fvm dart run melos run fm` | Format code |
| `fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json` | Run main app |

## Dependency Management

### Get Dependencies
```bash
fvm dart run melos run pg
```
Gets dependencies for all packages in the workspace.

### Check Outdated Packages
```bash
fvm dart run melos run po
```

### Upgrade Packages
```bash
fvm dart run melos run pu
```

## Code Generation

### Build Runner (Freezed, Injectable, Auto Route)
```bash
# Standard build
fvm dart run melos run br

# Build with delete conflicting outputs (recommended)
fvm dart run melos run brd
```

### Localization Generation
```bash
fvm dart run melos run l10n
```
Generates localizations for:
- `flutter_app` (root app)
- `feature_auth`
- `customer_app`

### Single Package Code Generation

To run build_runner on a specific package:
```bash
cd packages/feature/auth && fvm dart run build_runner build -d
cd apps/customer_app && fvm dart run build_runner build -d
```

## Code Quality

### Format Code
```bash
fvm dart run melos run fm
```

### Format Check (CI/CD)
```bash
fvm dart run melos run fm-check
```
Checks formatting without modifying files.

### Apply Dart Fixes
```bash
fvm dart run melos run fix
```

### Analyze Code
```bash
fvm dart analyze lib/
fvm dart analyze packages/domain/lib/
fvm dart analyze apps/customer_app/lib/
```

## Running Applications

### Main App (flutter_app)
```bash
# Development
fvm flutter run --flavor dev --dart-define-from-file=configs/dev.json

# Staging
fvm flutter run --flavor stg --dart-define-from-file=configs/stg.json

# Beta
fvm flutter run --flavor beta --dart-define-from-file=configs/beta.json
```

### Customer App
```bash
cd apps/customer_app
fvm flutter run
```

### With Specific Device
```bash
# List devices
fvm flutter devices

# Run on specific device
fvm flutter run -d <device-id> --flavor dev --dart-define-from-file=configs/dev.json
```

## Testing

### Run All Tests
```bash
fvm dart run melos run test
```

### Run Tests with Coverage
```bash
fvm dart run melos run test:coverage
```

### Run Tests in Watch Mode
```bash
fvm dart run melos run test:watch
```

### Run Tests for Specific Package
```bash
cd packages/domain && fvm flutter test
cd packages/feature/auth && fvm flutter test
```

## Android Builds

### APK Builds
```bash
# Development
fvm dart run melos run aos:devapk

# Staging
fvm dart run melos run aos:stgapk

# Beta
fvm dart run melos run aos:betaapk
```

### App Bundle Builds
```bash
# Development
fvm dart run melos run aos:dev

# Staging
fvm dart run melos run aos:stg

# Beta
fvm dart run melos run aos:beta
```

## iOS Builds

```bash
# Development
fvm dart run melos run ios:dev

# Staging
fvm dart run melos run ios:stg

# Beta
fvm dart run melos run ios:beta
```

## App Icons

```bash
fvm dart run melos run icon
```

## Workspace Commands

### List All Packages
```bash
fvm dart run melos list
```

### Clean All Packages
```bash
fvm dart run melos clean
```

### Bootstrap (Get + Link)
```bash
fvm dart run melos bootstrap
```

## Direct Commands (Without Melos)

Sometimes you need to run commands directly:

```bash
# Get dependencies
fvm dart pub get

# Build runner
fvm dart run build_runner build -d

# Localization
fvm flutter gen-l10n

# Format
fvm dart format lib/
```

## Common Workflows

### Initial Setup
```bash
fvm use                                    # Use correct Flutter version
fvm dart run melos run pg                  # Get dependencies
fvm dart run melos run l10n                # Generate localizations
fvm dart run melos run brd                 # Generate code
fvm dart run melos run fm                  # Format code
```

### After Pulling Changes
```bash
fvm dart run melos run pg                  # Update dependencies
fvm dart run melos run brd                 # Regenerate code
```

### After Modifying Models/BLoCs
```bash
fvm dart run melos run brd                 # Regenerate freezed/injectable
```

### After Adding Translations
```bash
fvm dart run melos run l10n                # Regenerate localizations
```

### Before Committing
```bash
fvm dart run melos run fm                  # Format code
fvm dart analyze lib/                      # Check for issues
```

### Creating New Feature
```bash
# 1. Create files
# 2. Generate code
fvm dart run melos run brd
# 3. Format
fvm dart run melos run fm
```

## Melos Scripts Summary

| Script | Description |
|--------|-------------|
| `pg` | Get dependencies |
| `po` | Check outdated packages |
| `pu` | Upgrade packages |
| `l10n` | Generate localization files |
| `br` | Build runner (standard) |
| `brd` | Build runner (delete conflicts) |
| `fm` | Format code |
| `fm-check` | Format check (CI/CD) |
| `icon` | Generate app icons |
| `fix` | Apply Dart fixes |
| `test` | Run tests |
| `test:coverage` | Run tests with coverage |
| `test:watch` | Run tests in watch mode |
| `aos:devapk` | Android Dev APK |
| `aos:stgapk` | Android Staging APK |
| `aos:betaapk` | Android Beta APK |
| `aos:dev` | Android Dev App Bundle |
| `aos:stg` | Android Staging App Bundle |
| `aos:beta` | Android Beta App Bundle |
| `ios:dev` | iOS Dev IPA |
| `ios:stg` | iOS Staging IPA |
| `ios:beta` | iOS Beta IPA |

## Troubleshooting

### Command Not Found
Ensure FVM is installed and Flutter version is set:
```bash
fvm install
fvm use
```

### Melos Not Found
```bash
fvm dart pub global activate melos
```

### Build Runner Conflicts
Use the `-d` flag to delete conflicting outputs:
```bash
fvm dart run build_runner build -d
```

### Package Resolution Issues
```bash
fvm dart run melos clean
fvm dart run melos run pg
```

### Generated Files Out of Date
```bash
fvm dart run build_runner clean
fvm dart run melos run brd
```

## See Also

- [QUICK_START.md](./QUICK_START.md) - Setup guide
- [MONOREPO_GUIDE.md](./MONOREPO_GUIDE.md) - Workspace overview
- [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - File organization
