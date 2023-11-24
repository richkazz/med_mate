import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension to make displaying [DateTime] objects simpler.
extension DateTimeEx on DateTime {
  /// Converts [DateTime] into a MMMM dd, yyyy [String].
  String get mDY {
    return DateFormat('MMMM d, yyyy').format(this);
  }
}

/// Extension on TimeOfDay providing additional formatting
/// and conversion methods.
extension TimeOfDayEx on TimeOfDay {
  /// Formats the time as a string in 12-hour clock format.
  String get formatTime {
    // Pad hour and minute with leading zeros if needed.
    final formattedHour = hourOfPeriod.toString().padLeft(2, '0');
    final formattedMinute = minute.toString().padLeft(2, '0');

    // Determine whether it's AM or PM.
    final period = this.period == DayPeriod.am ? 'AM' : 'PM';

    // Combine formatted components into a time string.
    return '$formattedHour:$formattedMinute $period';
  }

  /// Combines the time with the current date to create a DateTime instance.
  DateTime get combineDateAndTime {
    // Get the current date.
    final date = DateTime.now();

    // Create a new DateTime instance with the same year, month, and day
    // as the current date,
    // but with the hour and minute values from the TimeOfDay instance.
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
