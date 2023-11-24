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
    final formattedHour = hourOfPeriod.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');
    final period = this.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedHour:$formattedMinute $period';
  }

  DateTime get combineDateAndTime {
    final date = DateTime.now();
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
