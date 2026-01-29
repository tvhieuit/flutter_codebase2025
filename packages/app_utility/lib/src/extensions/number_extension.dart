import 'package:flutter/widgets.dart';

extension IntExtension on int {
  /// Creates a [Duration] with this many milliseconds
  Duration get ms => Duration(milliseconds: this);

  /// Creates a [Duration] with this many seconds
  Duration get seconds => Duration(seconds: this);

  /// Creates a [Duration] with this many minutes
  Duration get minutes => Duration(minutes: this);

  /// Creates a [Duration] with this many hours
  Duration get hours => Duration(hours: this);

  /// Creates a [Duration] with this many days
  Duration get days => Duration(days: this);
}

extension DoubleExtension on double {
  /// Creates a [SizedBox] with this width
  SizedBox get widthBox => SizedBox(width: this);

  /// Creates a [SizedBox] with this height
  SizedBox get heightBox => SizedBox(height: this);

  /// Creates symmetric horizontal [EdgeInsets]
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: this);

  /// Creates symmetric vertical [EdgeInsets]
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: this);

  /// Creates uniform [EdgeInsets]
  EdgeInsets get all => EdgeInsets.all(this);
}
