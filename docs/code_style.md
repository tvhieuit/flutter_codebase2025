# Code Style Rules

## Naming Conventions

### Classes
```dart
// ✅ CORRECT - PascalCase
class UserProfileBloc extends Bloc {}
class AddressModel with _$AddressModel {}
abstract class ApiRepository {}
```

### Variables & Methods
```dart
// ✅ CORRECT - camelCase
String userName = 'john';
List<String> userAddresses = [];
Future<void> getUserData() async {}
bool isUserLoggedIn = false;
```

### Files
```dart
// ✅ CORRECT - snake_case
user_profile_bloc.dart
address_model.dart
api_repository.dart
main_screen_page.dart
```

### Constants
```dart
// ✅ CORRECT - UPPER_SNAKE_CASE
const String API_BASE_URL = 'https://api.example.com';
const int MAX_RETRY_COUNT = 3;
const Duration REQUEST_TIMEOUT = Duration(seconds: 30);
```

### Private Variables
```dart
// ✅ CORRECT - leading underscore
final ApiService _apiService;
String? _cachedData;
bool _isInitialized = false;
```

## Formatting Rules

### Line Length
- Maximum: 120 characters
- Configured in `analysis_options.yaml`

### Indentation
- 2 spaces (no tabs)

### Trailing Commas
- REQUIRED for multi-line parameter lists
- REQUIRED for collections

```dart
// ✅ CORRECT
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      Text('World'),
    ], // Trailing comma
  );
}
```

### Import Organization
```dart
// 1. Flutter imports
import 'package:flutter/material.dart';

// 2. Dart core imports  
import 'dart:async';

// 3. Third-party packages
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Local imports
import '../entities/user_model.dart';
import 'user_profile_event.dart';
```

## Performance Optimization

### Use const
```dart
// ✅ CORRECT
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.home, size: 24, color: Colors.blue)

// ❌ WRONG
Text('Hello')
SizedBox(height: 16)
Icon(Icons.home, size: 24, color: Colors.blue)
```

### Const Constructors
```dart
// ✅ CORRECT
const AppBar(
  title: const Text('Title'),
  backgroundColor: AppColors.primary,
)
```

## Required Commands

### Before Every Commit
```bash
# Format code
fvm dart run melos run fm

# Or
fvm dart format .
```

### Format Check (CI/CD)
```bash
fvm dart format --set-exit-if-changed .
```

## Linter Rules

Key rules from `analysis_options.yaml`:
- `require_trailing_commas: true`
- `always_declare_return_types: true`
- `prefer_const_constructors: true`
- `prefer_const_literals_to_create_immutables: true`
- `use_key_in_widget_constructors: true`

## Best Practices

### ✅ DO
- Use descriptive variable names
- Add comments for complex logic
- Use const constructors when possible
- Format code before committing
- Follow naming conventions
- Keep line length under 120 characters

### ❌ DON'T
- Use magic numbers (use constants)
- Hardcode strings (use l10n)
- Skip code formatting
- Use tabs for indentation
- Skip trailing commas
- Ignore linter warnings

