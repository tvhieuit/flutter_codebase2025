/// Callback with no arguments and no return value
typedef VoidCallback = void Function();

/// Callback that receives a value of type [T]
typedef ValueChanged<T> = void Function(T value);

/// Async callback with no arguments
typedef AsyncCallback = Future<void> Function();

/// Async callback that receives a value of type [T]
typedef AsyncValueChanged<T> = Future<void> Function(T value);

/// JSON map alias
typedef Json = Map<String, dynamic>;

/// Predicate function
typedef Predicate<T> = bool Function(T value);
