# Localization (L10n) Guide

## Overview

This project uses Flutter's official localization package with ARB (Application Resource Bundle) files for internationalization.

## Setup

### Configuration

**`l10n.yaml`** - Localization configuration:
```yaml
arb-dir: l10n
template-arb-file: lang_en.arb
output-localization-file: app_localization.dart
```

### Supported Locales

Currently supported:
- English (`en`) - Default

To add more locales, create new ARB files in `l10n/` directory.

## Usage Pattern

### ✅ CORRECT - Use `l10n` extension (Recommended)

This project provides a global `l10n` extension for easy access:

**`lib/extensions/l10n_extension.dart`**:
```dart
import 'package:flutter_app/app/app_router.dart';
import 'package:flutter_app/l10n/app_localization.dart';

AppLocalizations get l10n => AppLocalizations.of(globalContext);
```

**Usage**:
```dart
import '../../extensions/l10n_extension.dart';

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text(l10n.appName),      // ✅ Super clean - no context needed
      Text(l10n.welcome),      // ✅ Import once, use everywhere
      Text(l10n.save),         // ✅ Global access
    ],
  );
}
```

### Alternative - Local context (when needed)

If you need locale-specific context (e.g., for locale switching):

```dart
@override
Widget build(BuildContext context) {
  final localL10n = AppLocalizations.of(context);  // Context-specific
  
  return Column(
    children: [
      Text(localL10n.appName),
      Text(localL10n.welcome),
    ],
  );
}
```

### ❌ WRONG - Repeated `AppLocalizations.of(context)`

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text(AppLocalizations.of(context).appName),   // ❌ Verbose
      Text(AppLocalizations.of(context).welcome),   // ❌ Repetitive
      Text(AppLocalizations.of(context).save),      // ❌ Hard to read
    ],
  );
}
```

## ARB File Structure

### Basic Structure

**`l10n/lang_en.arb`**:
```json
{
  "@@locale": "en",
  "appName": "Flutter App",
  "@appName": {
    "description": "Application name"
  },
  "welcome": "Welcome",
  "save": "Save",
  "cancel": "Cancel"
}
```

### With Placeholders

```json
{
  "welcomeUser": "Welcome, {name}!",
  "@welcomeUser": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  "itemCount": "{count} items",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.welcomeUser('John'))    // "Welcome, John!"
Text(l10n.itemCount(5))           // "5 items"
```

### With Pluralization

```json
{
  "nItems": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@nItems": {
    "description": "Number of items with pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.nItems(0))   // "No items"
Text(l10n.nItems(1))   // "One item"
Text(l10n.nItems(5))   // "5 items"
```

## Adding New Translations

### 1. Add to ARB File

**`l10n/lang_en.arb`**:
```json
{
  "loginButton": "Login",
  "@loginButton": {
    "description": "Login button text"
  }
}
```

### 2. Generate Code

```bash
fvm flutter gen-l10n

# Or use melos script
fvm dart run melos run l10n
```

### 3. Use in Code

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return ElevatedButton(
    onPressed: () {},
    child: Text(l10n.loginButton),
  );
}
```

## Adding New Languages

### 1. Create ARB File

**`l10n/lang_vi.arb`** (Vietnamese):
```json
{
  "@@locale": "vi",
  "appName": "Ứng Dụng Flutter",
  "welcome": "Chào mừng",
  "save": "Lưu",
  "cancel": "Hủy",
  "loginButton": "Đăng nhập"
}
```

### 2. Generate Code

```bash
fvm flutter gen-l10n
```

### 3. App Automatically Supports It

Flutter will automatically use the appropriate locale based on device settings.

## Best Practices

### ✅ DO

1. **Use `l10n` shorthand at the top of build method**
   ```dart
   Widget build(BuildContext context) {
     final l10n = AppLocalizations.of(context);  // ✅
     return Text(l10n.appName);
   }
   ```

2. **Add descriptions to all strings**
   ```json
   {
     "save": "Save",
     "@save": {
       "description": "Save button label"
     }
   }
   ```

3. **Use placeholders for dynamic content**
   ```json
   {
     "greeting": "Hello, {name}!",
     "@greeting": {
       "placeholders": {
         "name": {"type": "String"}
       }
     }
   }
   ```

4. **Group related strings with prefixes**
   ```json
   {
     "loginTitle": "Login",
     "loginButton": "Sign In",
     "loginError": "Invalid credentials",
     "signupTitle": "Sign Up",
     "signupButton": "Create Account"
   }
   ```

5. **Use consistent naming conventions**
   - camelCase for keys
   - Descriptive names: `loginButton` not `btn1`
   - Group by feature: `profileTitle`, `profileSave`

### ❌ DON'T

1. **Don't repeat `AppLocalizations.of(context)`**
   ```dart
   // ❌ WRONG
   Text(AppLocalizations.of(context).title)
   Text(AppLocalizations.of(context).subtitle)
   
   // ✅ CORRECT
   final l10n = AppLocalizations.of(context);
   Text(l10n.title)
   Text(l10n.subtitle)
   ```

2. **Don't hardcode strings in UI**
   ```dart
   // ❌ WRONG
   Text('Login')
   
   // ✅ CORRECT
   final l10n = AppLocalizations.of(context);
   Text(l10n.loginButton)
   ```

3. **Don't skip descriptions**
   ```json
   // ❌ WRONG
   {
     "save": "Save"
   }
   
   // ✅ CORRECT
   {
     "save": "Save",
     "@save": {
       "description": "Save button label"
     }
   }
   ```

4. **Don't use generic names**
   ```json
   // ❌ WRONG
   {
     "button1": "Login",
     "text2": "Welcome"
   }
   
   // ✅ CORRECT
   {
     "loginButton": "Login",
     "welcomeMessage": "Welcome"
   }
   ```

## Common Patterns

### Screen Titles

```json
{
  "splashTitle": "Welcome",
  "homeTitle": "Home",
  "profileTitle": "Profile",
  "settingsTitle": "Settings"
}
```

### Buttons

```json
{
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "edit": "Edit",
  "submit": "Submit",
  "confirm": "Confirm"
}
```

### Messages

```json
{
  "successMessage": "Operation completed successfully",
  "errorMessage": "An error occurred",
  "loadingMessage": "Loading...",
  "emptyMessage": "No data available"
}
```

### Validation

```json
{
  "emailRequired": "Email is required",
  "emailInvalid": "Invalid email format",
  "passwordRequired": "Password is required",
  "passwordTooShort": "Password must be at least 8 characters"
}
```

## Examples

### Complete Login Screen

**ARB File**:
```json
{
  "loginTitle": "Login",
  "emailLabel": "Email",
  "emailHint": "Enter your email",
  "passwordLabel": "Password",
  "passwordHint": "Enter your password",
  "loginButton": "Sign In",
  "forgotPassword": "Forgot Password?",
  "noAccount": "Don't have an account?",
  "signupLink": "Sign Up"
}
```

**Widget**:
```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.loginTitle),
    ),
    body: Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: l10n.emailLabel,
            hintText: l10n.emailHint,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text(l10n.loginButton),
        ),
        TextButton(
          onPressed: () {},
          child: Text(l10n.forgotPassword),
        ),
        Row(
          children: [
            Text(l10n.noAccount),
            TextButton(
              onPressed: () {},
              child: Text(l10n.signupLink),
            ),
          ],
        ),
      ],
    ),
  );
}
```

## Troubleshooting

### Issue: Strings not updating

**Solution**: Run code generation
```bash
fvm flutter gen-l10n
```

### Issue: Missing translations

**Solution**: Ensure all locales have the same keys
```bash
# Check keys in each ARB file match
```

### Issue: BuildContext not available

**Solution**: Pass context or use MaterialApp's `onGenerateTitle`
```dart
MaterialApp.router(
  onGenerateTitle: (context) {
    final l10n = AppLocalizations.of(context);
    return l10n.appName;
  },
)
```

## References

- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Screen Template](./SCREEN_TEMPLATE.md)

## Summary

### Key Rules

1. ✅ **Always use `l10n` shorthand**
   ```dart
   final l10n = AppLocalizations.of(context);
   ```

2. ✅ **Never hardcode UI strings**
   ```dart
   Text(l10n.buttonText)  // Not Text('Button')
   ```

3. ✅ **Add descriptions to all strings**
   ```json
   "@key": {"description": "..."}
   ```

4. ✅ **Run gen-l10n after ARB changes**
   ```bash
   fvm flutter gen-l10n
   ```

5. ✅ **Use consistent naming**
   - camelCase keys
   - Descriptive names
   - Group by feature

