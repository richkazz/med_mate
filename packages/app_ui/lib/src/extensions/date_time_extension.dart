import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a MMMM dd, yyyy [String].
  String get mDY {
    return DateFormat('MMMM d, yyyy').format(this);
  }
}

extension TimeOfDayEx on TimeOfDay {
  String get formatTime {
    final formattedHour = this.hourOfPeriod.toString().padLeft(2, '0');
    final formattedMinute = this.minute.toString().padLeft(2, '0');
    final period = this.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedHour:$formattedMinute $period';
  }
}
