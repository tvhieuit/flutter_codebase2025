# Common Commands Reference

## Quick Reference

All commands use Melos scripts for consistency. Use `fvm dart run melos run <script-name>` to execute them.

## Dependency Management

### Get Dependencies
```bash
fvm dart run melos run pg
# or direct command:
fvm dart run melos exec -- fvm dart pub get --no-example
```

### Check Outdated Packages
```bash
fvm dart run melos run po
# or direct command:
fvm dart run melos exec -- fvm dart pub outdated
```

### Upgrade Packages
```bash
fvm dart run melos run pu
# or direct command:
fvm dart run melos exec -- fvm dart pub upgrade --major-versions
```

## Code Generation

### Localization Generation
```bash
fvm dart run melos run l10n
# or direct command:
fvm dart run melos exec -- fvm flutter gen-l10n
```

### Build Runner (Code Generation)
```bash
# Standard build
fvm dart run melos run br
# or direct command:
fvm dart run melos exec -- fvm dart run build_runner build

# Build with delete conflicting outputs
fvm dart run melos run brd
# or direct command:
fvm dart run melos exec -- fvm dart run build_runner build -d
```

## Code Quality

### Format Code
```bash
fvm dart run melos run fm
# or direct command:
fvm dart run melos exec -- fvm dart format .
```

### Format Check (CI/CD)
```bash
fvm dart run melos run fm-check
# Checks formatting without modifying files
```

### Apply Dart Fixes
```bash
fvm dart run melos run fix
# or direct command:
fvm dart run melos exec -- fvm dart fix --apply
```

## Testing

### Run Tests
```bash
fvm dart run melos run test
# or direct command:
fvm dart run melos exec -- fvm flutter test
```

### Run Tests with Coverage
```bash
fvm dart run melos run test:coverage
# or direct command:
fvm dart run melos exec -- fvm flutter test --coverage
```

### Run Tests in Watch Mode
```bash
fvm dart run melos run test:watch
# or direct command:
fvm dart run melos exec -- fvm flutter test --watch
```

## App Icons

### Generate App Icons
```bash
fvm dart run melos run icon
# or direct command:
fvm dart run melos exec -- fvm dart run flutter_launcher_icons
```

## Running the App

### Development Run
```bash
fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json
```

## Android Builds

### APK Builds

#### Dev APK
```bash
fvm dart run melos run aos:devapk
# or direct command:
fvm dart run melos exec -- fvm flutter build apk --release --flavor dev --dart-define-from-file=./configs/dev.json
```

#### Staging APK
```bash
fvm dart run melos run aos:stgapk
# or direct command:
fvm dart run melos exec -- fvm flutter build apk --release --flavor stg --dart-define-from-file=./configs/stg.json
```

#### Beta APK
```bash
fvm dart run melos run aos:betaapk
# or direct command:
fvm dart run melos exec -- fvm flutter build apk --release --flavor beta --dart-define-from-file=./configs/beta.json
```

### App Bundle Builds

#### Dev App Bundle
```bash
fvm dart run melos run aos:dev
# or direct command:
fvm dart run melos exec -- fvm flutter build appbundle --release --flavor dev --dart-define-from-file=./configs/dev.json
```

#### Staging App Bundle
```bash
fvm dart run melos run aos:stg
# or direct command:
fvm dart run melos exec -- fvm flutter build appbundle --release --flavor stg --dart-define-from-file=./configs/stg.json
```

#### Beta App Bundle
```bash
fvm dart run melos run aos:beta
# or direct command:
fvm dart run melos exec -- fvm flutter build appbundle --release --flavor beta --dart-define-from-file=./configs/beta.json
```

## iOS Builds

### Dev IPA
```bash
fvm dart run melos run ios:dev
# or direct command:
fvm dart run melos exec -- fvm flutter build ipa --release --flavor dev --dart-define-from-file=./configs/dev.json
```

### Staging IPA
```bash
fvm dart run melos run ios:stg
# or direct command:
fvm dart run melos exec -- fvm flutter build ipa --release --flavor stg --dart-define-from-file=./configs/stg.json
```

### Beta IPA
```bash
fvm dart run melos run ios:beta
# or direct command:
fvm dart run melos exec -- fvm flutter build ipa --release --flavor beta --dart-define-from-file=./configs/beta.json
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

### If melos scripts don't work:
Always use the direct `melos exec` pattern:
```bash
fvm dart run melos exec -- <command>
```

This ensures commands run correctly across all packages in the workspace.

### Common Workflow

1. **Get dependencies**: `fvm dart run melos run pg`
2. **Generate code**: `fvm dart run melos run brd`
3. **Generate localization**: `fvm dart run melos run l10n`
4. **Format code**: `fvm dart run melos run fm`
5. **Run app**: `fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json`
