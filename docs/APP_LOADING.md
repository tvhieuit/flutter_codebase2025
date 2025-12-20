# AppLoading Documentation

## Overview

Global loading overlay system for showing loading indicators across the entire app.

## Features

- ✅ Global overlay loading
- ✅ Multiple concurrent tasks support
- ✅ Prevent back button during loading
- ✅ Customizable appearance
- ✅ Loading buttons with built-in state

## AppLoading

### Basic Usage

```dart
import '../widgets/app_loading.dart';

// Show loading
AppLoading.show();

// Hide loading
AppLoading.hide();

// Toggle based on boolean
AppLoading.loading(isLoading);
```

### Multiple Tasks

The loading overlay supports multiple concurrent tasks:

```dart
// Start task 1
AppLoading.show();
await fetchData1();

// Start task 2 (loading still showing)
AppLoading.show();
await fetchData2();

// Finish task 1 (loading still showing)
AppLoading.hide();

// Finish task 2 (loading hidden)
AppLoading.hide();
```

### Force Hide

```dart
// Force hide regardless of pending tasks
AppLoading.hide(force: true);
```

### Custom Loading

```dart
// Custom background color
AppLoading.show(
  backgroundColor: Colors.black87,
);

// Custom loading widget
AppLoading.showCustom(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Please wait...'),
    ],
  ),
);
```

### Check Status

```dart
// Check if loading is showing
if (AppLoading.isShowing) {
  print('Loading is visible');
}

// Get number of pending tasks
final tasks = AppLoading.pendingTasks;
print('Pending tasks: $tasks');
```

## Usage Patterns

### With API Calls

```dart
Future<void> fetchData() async {
  try {
    AppLoading.show();
    final result = await apiService.getData();
    // Handle result
  } finally {
    AppLoading.hide();
  }
}
```

### With BLoC

```dart
@injectable
class MyBloc extends Bloc<MyEvent, MyState> with SafetyNetworkMixin {
  Future<void> _onLoadData(event, emit) async {
    emit(state.copyWith(isLoading: true));
    AppLoading.show();
    
    await safeNetworkCall(() async {
      final result = await _useCase.getData();
      emit(state.copyWith(data: result, isLoading: false));
    });
    
    AppLoading.hide();
  }
}
```

### With Multiple Async Operations

```dart
Future<void> syncData() async {
  try {
    // Each operation shows loading
    AppLoading.show();
    await syncUsers();
    
    AppLoading.show();
    await syncProducts();
    
    AppLoading.show();
    await syncOrders();
  } finally {
    // Force hide to clear all
    AppLoading.hide(force: true);
  }
}
```

## AppLoadingButton

Button with built-in loading state.

### Usage

```dart
import '../widgets/app_loading_button.dart';

AppLoadingButton(
  onPressed: _handleSubmit,
  isLoading: _isLoading,
  child: const Text('Submit'),
)
```

### Full Example

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    
    try {
      await apiService.submit();
      // Handle success
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLoadingButton(
      onPressed: _handleSubmit,
      isLoading: _isLoading,
      width: double.infinity,
      backgroundColor: Colors.blue,
      child: const Text('Submit'),
    );
  }
}
```

### Customization

```dart
AppLoadingButton(
  onPressed: _handleSubmit,
  isLoading: _isLoading,
  backgroundColor: Colors.blue,
  foregroundColor: Colors.white,
  width: double.infinity,
  height: 56,
  padding: EdgeInsets.symmetric(horizontal: 24),
  borderRadius: BorderRadius.circular(12),
  child: const Text('Submit'),
)
```

## AppLoadingTextButton

Text button with loading state.

```dart
AppLoadingTextButton(
  onPressed: _handleRetry,
  isLoading: _isRetrying,
  foregroundColor: Colors.blue,
  child: const Text('Retry'),
)
```

## AppLoadingIconButton

Icon button with loading state.

```dart
AppLoadingIconButton(
  onPressed: _handleRefresh,
  isLoading: _isRefreshing,
  icon: const Icon(Icons.refresh),
  color: Colors.blue,
)
```

## Best Practices

### ✅ DO

1. **Always hide in finally block**
   ```dart
   try {
     AppLoading.show();
     await operation();
   } finally {
     AppLoading.hide();
   }
   ```

2. **Use with try-catch**
   ```dart
   try {
     AppLoading.show();
     await apiCall();
   } catch (e) {
     // Handle error
   } finally {
     AppLoading.hide();
   }
   ```

3. **Use loading buttons for form submissions**
   ```dart
   AppLoadingButton(
     onPressed: _submit,
     isLoading: _isSubmitting,
     child: Text('Submit'),
   )
   ```

4. **Force hide on screen disposal**
   ```dart
   @override
   void dispose() {
     AppLoading.hide(force: true);
     super.dispose();
   }
   ```

### ❌ DON'T

1. **Don't forget to hide**
   ```dart
   // BAD - May leave loading visible
   AppLoading.show();
   await apiCall();
   AppLoading.hide(); // What if apiCall throws?
   ```

2. **Don't use for local loading states**
   ```dart
   // BAD - Use loading button instead
   AppLoading.show();
   await quickOperation();
   AppLoading.hide();
   
   // GOOD
   AppLoadingButton(
     onPressed: quickOperation,
     isLoading: isLoading,
   )
   ```

3. **Don't nest show/hide incorrectly**
   ```dart
   // BAD
   AppLoading.show();
   AppLoading.show();
   AppLoading.hide(force: true); // Skips task tracking
   ```

## Complete Examples

### Form Submission

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      AppLoading.show();
      
      final success = await authService.login(
        _emailController.text,
        _passwordController.text,
      );
      
      if (success) {
        context.router.replace(const HomeRoute());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      AppLoading.hide();
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 24),
        AppLoadingButton(
          onPressed: _handleLogin,
          isLoading: _isLoading,
          width: double.infinity,
          child: const Text('Login'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    AppLoading.hide(force: true);
    super.dispose();
  }
}
```

### Data Sync

```dart
class SyncService {
  Future<void> syncAll() async {
    try {
      AppLoading.show();
      await _syncUsers();
      
      AppLoading.show();
      await _syncProducts();
      
      AppLoading.show();
      await _syncOrders();
      
      print('Sync completed');
    } catch (e) {
      print('Sync failed: $e');
    } finally {
      AppLoading.hide(force: true);
    }
  }

  Future<void> _syncUsers() async {
    try {
      await userRepository.sync();
    } finally {
      AppLoading.hide();
    }
  }

  Future<void> _syncProducts() async {
    try {
      await productRepository.sync();
    } finally {
      AppLoading.hide();
    }
  }

  Future<void> _syncOrders() async {
    try {
      await orderRepository.sync();
    } finally {
      AppLoading.hide();
    }
  }
}
```

## API Reference

### AppLoading

| Method | Parameters | Description |
|--------|-----------|-------------|
| `show()` | `backgroundColor`, `loadingWidget` | Show loading overlay |
| `hide()` | `force` | Hide loading overlay |
| `loading()` | `bool isLoading` | Toggle based on boolean |
| `showCustom()` | `child`, `backgroundColor` | Show with custom widget |
| `isShowing` | - | Check if loading is visible |
| `pendingTasks` | - | Get number of pending tasks |

### AppLoadingButton

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Button callback |
| `child` | `Widget` | required | Button content |
| `isLoading` | `bool` | `false` | Loading state |
| `backgroundColor` | `Color?` | null | Background color |
| `foregroundColor` | `Color?` | null | Text/icon color |
| `width` | `double?` | null | Button width |
| `height` | `double?` | `48` | Button height |

## References

- [Screen Template](./SCREEN_TEMPLATE.md)
- [BLoC Pattern](../rules/bloc_pattern.md)

