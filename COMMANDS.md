# Common Commands Reference

## Localization Generation

### Option 1: Direct Command (Recommended)
```bash
fvm dart run melos exec -- fvm flutter gen-l10n
```

### Option 2: Melos Script (if workspace is initialized)
```bash
fvm dart run melos run gen_l10n
```

**Note**: If you get "NoScriptException", use Option 1 instead.

## Code Generation

```bash
fvm dart run melos exec -- fvm dart run build_runner build --delete-conflicting-outputs
```

## Format Code

```bash
fvm dart run melos exec -- fvm dart format .
```

## Get Dependencies

```bash
fvm dart run melos exec -- fvm dart pub get --no-example
```

## Run App

```bash
fvm flutter run --flavor dev --dart-define-from-file=configs/.env.dev.json
```

## Troubleshooting

### If melos scripts don't work:
Always use the direct `melos exec` pattern:
```bash
fvm dart run melos exec -- <command>
```

This ensures commands run correctly across all packages in the workspace.

