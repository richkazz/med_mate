/// Represents the days of the week.
enum DayOfTheWeek {
  ///
  monday,

  ///
  tuesday,

  ///
  wednesday,

  ///
  thursday,

  ///
  friday,

  ///
  saturday,

  ///
  sunday,
}

/// for converting the enum to string
extension DayOfTheWeekExtension on DayOfTheWeek {
  ///
  String get displayName {
    switch (this) {
      case DayOfTheWeek.monday:
        return 'Mon';
      case DayOfTheWeek.tuesday:
        return 'Tue';
      case DayOfTheWeek.wednesday:
        return 'Wed';
      case DayOfTheWeek.thursday:
        return 'Thur';
      case DayOfTheWeek.friday:
        return 'Fri';
      case DayOfTheWeek.saturday:
        return 'Sat';
      case DayOfTheWeek.sunday:
        return 'Sun';
    }
  }
}
