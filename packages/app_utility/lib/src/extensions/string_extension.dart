extension StringExtension on String {
  /// Capitalizes the first letter of the string
  String get capitalized => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalizes the first letter of each word
  String get titleCase => split(' ').map((word) => word.capitalized).join(' ');

  /// Removes all whitespace from the string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Returns true if the string is a valid email format
  bool get isEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  /// Returns true if the string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  /// Truncates the string to [maxLength] and appends [ellipsis] if needed
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }
}

extension NullableStringExtension on String? {
  /// Returns true if the string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if the string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the string or a default value if null/empty
  String orDefault(String defaultValue) => isNullOrEmpty ? defaultValue : this!;
}
