# SharedPreferencesAsync Guide

## Overview

This project uses `SharedPreferencesAsync` instead of the traditional `SharedPreferences` for local data storage.

## Why SharedPreferencesAsync?

### Advantages over SharedPreferences

1. **No Initialization Required** - Doesn't need `getInstance()` async call
2. **Better Performance** - Direct async operations without pre-loading
3. **Simplified DI** - No need for `@preResolve` annotation
4. **Modern API** - Follows Flutter's latest best practices
5. **Thread-Safe** - All operations are atomic and thread-safe

### Comparison

```dart
// ❌ OLD - SharedPreferences (requires initialization)
@preResolve
@lazySingleton
Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

// ✅ NEW - SharedPreferencesAsync (no initialization needed)
@lazySingleton
SharedPreferencesAsync get prefs => SharedPreferencesAsync();
```

## Usage in Repository

### LocalRepository Implementation

```dart
@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferencesAsync _prefs;

  LocalRepositoryImpl(this._prefs);

  @override
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _prefs.setString('user', json);
  }

  @override
  Future<UserModel?> getUser() async {
    final json = await _prefs.getString('user');
    if (json == null) return null;

    final Map<String, dynamic> data = jsonDecode(json);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove('user');
  }
}
```

## API Reference

### String Operations

```dart
// Save string
await _prefs.setString('key', 'value');

// Get string
final value = await _prefs.getString('key');

// Remove string
await _prefs.remove('key');
```

### Int Operations

```dart
// Save int
await _prefs.setInt('count', 42);

// Get int
final count = await _prefs.getInt('count');
```

### Bool Operations

```dart
// Save bool
await _prefs.setBool('isLoggedIn', true);

// Get bool
final isLoggedIn = await _prefs.getBool('isLoggedIn');
```

### Double Operations

```dart
// Save double
await _prefs.setDouble('price', 99.99);

// Get double
final price = await _prefs.getDouble('price');
```

### List<String> Operations

```dart
// Save string list
await _prefs.setStringList('tags', ['tag1', 'tag2']);

// Get string list
final tags = await _prefs.getStringList('tags');
```

### Clear All Data

```dart
// Clear all preferences
await _prefs.clear();
```

### Check if Key Exists

```dart
// Check if key exists
final exists = await _prefs.containsKey('key');
```

### Get All Keys

```dart
// Get all keys
final keys = await _prefs.getKeys();
```

## Best Practices

### 1. Use Constants for Keys

```dart
class LocalRepositoryImpl implements LocalRepository {
  static const String _keyUser = 'user';
  static const String _keyUserList = 'user_list';
  static const String _keyToken = 'token';
  
  // Use constants in methods
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }
}
```

### 2. Handle Null Values

```dart
Future<UserModel?> getUser() async {
  final json = await _prefs.getString(_keyUser);
  if (json == null) return null;  // Handle null case
  
  final data = jsonDecode(json);
  return UserModel.fromJson(data);
}
```

### 3. Encode Complex Objects

```dart
// Save complex object
Future<void> saveUser(UserModel user) async {
  final json = jsonEncode(user.toJson());
  await _prefs.setString(_keyUser, json);
}

// Load complex object
Future<UserModel?> getUser() async {
  final json = await _prefs.getString(_keyUser);
  if (json == null) return null;
  
  final data = jsonDecode(json);
  return UserModel.fromJson(data);
}
```

### 4. Save Lists

```dart
// Save list of objects
Future<void> saveUserList(List<UserModel> users) async {
  final jsonList = users.map((user) => user.toJson()).toList();
  final json = jsonEncode(jsonList);
  await _prefs.setString(_keyUserList, json);
}

// Load list of objects
Future<List<UserModel>> getUserList() async {
  final json = await _prefs.getString(_keyUserList);
  if (json == null) return [];
  
  final List<dynamic> data = jsonDecode(json);
  return data.map((item) => UserModel.fromJson(item)).toList();
}
```

### 5. Clear Specific Data

```dart
Future<void> logout() async {
  // Clear specific keys
  await _prefs.remove(_keyUser);
  await _prefs.remove(_keyToken);
  
  // Or clear all data
  // await _prefs.clear();
}
```

## Dependency Injection Setup

### di_module.dart

```dart
@module
abstract class DiModule {
  /// SharedPreferencesAsync instance for local storage
  /// No need for @preResolve as it doesn't require async initialization
  @lazySingleton
  SharedPreferencesAsync get prefs => SharedPreferencesAsync();
}
```

## Migration from SharedPreferences

### Before (SharedPreferences)

```dart
// DI Module
@preResolve
@lazySingleton
Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

// Repository
@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferences _prefs;
  
  LocalRepositoryImpl(this._prefs);
  
  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);  // Same API
  }
  
  @override
  Future<String?> getToken() async {
    return _prefs.getString('token');  // Synchronous read
  }
}
```

### After (SharedPreferencesAsync)

```dart
// DI Module
@lazySingleton
SharedPreferencesAsync get prefs => SharedPreferencesAsync();

// Repository
@Injectable(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final SharedPreferencesAsync _prefs;
  
  LocalRepositoryImpl(this._prefs);
  
  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);  // Same API
  }
  
  @override
  Future<String?> getToken() async {
    return await _prefs.getString('token');  // Async read
  }
}
```

### Key Differences

1. **No @preResolve** - SharedPreferencesAsync doesn't need async initialization
2. **Async Reads** - All read operations return `Future` instead of synchronous values
3. **Simpler DI** - Just return new instance, no `getInstance()` call

## Performance Considerations

### Memory Efficiency

- **SharedPreferences**: Loads all data into memory at initialization
- **SharedPreferencesAsync**: Reads/writes directly to disk, no memory cache

### Use Cases

#### Use SharedPreferencesAsync when:
- ✅ You have large amounts of data
- ✅ You want to minimize memory usage
- ✅ You don't need synchronous access
- ✅ You want modern, cleaner API

#### Still use SharedPreferences when:
- ❌ You need synchronous read access (rare cases)
- ❌ You have existing code that's hard to migrate
- ❌ You need the pre-loaded cache for performance

## Testing

### Mock SharedPreferencesAsync

```dart
class MockSharedPreferencesAsync extends Mock implements SharedPreferencesAsync {}

void main() {
  late LocalRepository repository;
  late MockSharedPreferencesAsync mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferencesAsync();
    repository = LocalRepositoryImpl(mockPrefs);
  });

  test('saveToken should save token to preferences', () async {
    // Arrange
    const token = 'test_token';
    when(() => mockPrefs.setString('token', token))
        .thenAnswer((_) async => {});

    // Act
    await repository.saveToken(token);

    // Assert
    verify(() => mockPrefs.setString('token', token)).called(1);
  });

  test('getToken should return token from preferences', () async {
    // Arrange
    const token = 'test_token';
    when(() => mockPrefs.getString('token'))
        .thenAnswer((_) async => token);

    // Act
    final result = await repository.getToken();

    // Assert
    expect(result, token);
    verify(() => mockPrefs.getString('token')).called(1);
  });
}
```

## Common Patterns

### Token Management

```dart
class LocalRepositoryImpl implements LocalRepository {
  static const String _keyToken = 'auth_token';
  
  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }
  
  @override
  Future<String?> getToken() async {
    return await _prefs.getString(_keyToken);
  }
  
  @override
  Future<void> clearToken() async {
    await _prefs.remove(_keyToken);
  }
}
```

### User Session Management

```dart
class LocalRepositoryImpl implements LocalRepository {
  static const String _keyUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';
  
  @override
  Future<void> saveUserSession(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _prefs.setString(_keyUser, json);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _prefs.getBool(_keyIsLoggedIn) ?? false;
  }
  
  @override
  Future<void> clearSession() async {
    await _prefs.remove(_keyUser);
    await _prefs.remove(_keyIsLoggedIn);
  }
}
```

### Cache Management

```dart
class LocalRepositoryImpl implements LocalRepository {
  static const String _keyCacheTimestamp = 'cache_timestamp';
  static const String _keyCacheData = 'cache_data';
  
  @override
  Future<void> cacheData(String data) async {
    await _prefs.setString(_keyCacheData, data);
    await _prefs.setString(
      _keyCacheTimestamp,
      DateTime.now().toIso8601String(),
    );
  }
  
  @override
  Future<String?> getCachedData({Duration maxAge = const Duration(hours: 1)}) async {
    final timestamp = await _prefs.getString(_keyCacheTimestamp);
    if (timestamp == null) return null;
    
    final cacheTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    
    if (now.difference(cacheTime) > maxAge) {
      // Cache expired
      await _prefs.remove(_keyCacheData);
      await _prefs.remove(_keyCacheTimestamp);
      return null;
    }
    
    return await _prefs.getString(_keyCacheData);
  }
}
```

## Summary

### ✅ Advantages
- No initialization required
- Better memory efficiency
- Modern async API
- Simpler dependency injection
- Thread-safe operations

### 📝 Key Points
- All operations are async (including reads)
- Use constants for keys
- Handle null values properly
- Encode/decode complex objects
- Use for token, session, cache management

### 🎯 Best For
- Modern Flutter apps
- Clean Architecture projects
- Large data storage needs
- Memory-conscious applications

Use `SharedPreferencesAsync` for all new code in this project!

