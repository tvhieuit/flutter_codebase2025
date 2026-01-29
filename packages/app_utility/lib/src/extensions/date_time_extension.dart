extension DateTimeExtension on DateTime {
  /// Returns true if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if this date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Returns true if this date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Returns date only (time set to midnight)
  DateTime get dateOnly => DateTime(year, month, day);

  /// Returns the difference in days from today (negative = past)
  int get daysFromToday => dateOnly.difference(DateTime.now().dateOnly).inDays;

  /// Formats as yyyy-MM-dd
  String get toDateString => '$year-${_pad(month)}-${_pad(day)}';

  /// Formats as HH:mm
  String get toTimeString => '${_pad(hour)}:${_pad(minute)}';

  /// Formats as yyyy-MM-dd HH:mm
  String get toDateTimeString => '$toDateString $toTimeString';

  String _pad(int value) => value.toString().padLeft(2, '0');
}
