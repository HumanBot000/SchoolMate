import 'package:intl/intl.dart';

const List<String> weekdaysAbbreviations = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
];

extension on DateTime {
  int get dayOfYear {
    return int.parse(DateFormat("D").format(this));
  }
}

int getIsoWeekNumber(DateTime date) {
  // Returns the current Calendar week number of the year
  int weekNumber = ((date.dayOfYear - date.weekday + 10) / 7).floor();
  return weekNumber;
}

DateTime getStartOfWeek(DateTime currentDay) {
  return currentDay.subtract(Duration(days: currentDay.weekday - 1));
}
