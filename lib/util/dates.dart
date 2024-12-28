import 'package:intl/intl.dart';

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
