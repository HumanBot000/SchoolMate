import 'package:flutter/material.dart';
import 'package:school_mate/util/extensions/dates.dart';

const List<String> weekdaysAbbreviations = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
];

int getIsoWeekNumber(DateTime date) {
  /// Returns the current Calendar week number of the year
  int weekNumber = ((date.dayOfYear - date.weekday + 10) / 7).floor();
  return weekNumber;
}

DateTime getStartOfWeek(DateTime currentDay) {
  return currentDay.subtract(Duration(days: currentDay.weekday - 1));
}

List<dynamic> getVisualTimeTillDate(DateTime start, DateTime end) {
  final difference = end.difference(start);
  if (difference.inDays >= 365) {
    final numOfYears = (difference.inDays ~/ 365).floor();
    return [numOfYears, numOfYears == 1 ? "year" : "years"];
  }
  if (difference.inHours >= 24) {
    final numOfDays = (difference.inHours ~/ 24).floor();
    return [numOfDays, numOfDays == 1 ? "day" : "days"];
  }
  if (difference.inMinutes >= 60) {
    final numOfHours = (difference.inMinutes ~/ 60).floor();
    return [numOfHours, numOfHours == 1 ? "hour" : "hours"];
  }
  final numOfMinutes = difference.inMinutes;
  return [numOfMinutes, numOfMinutes == 1 ? "minute" : "minutes"];
}

bool timeOfDaysOverlap(List<List<TimeOfDay>> times) {
  bool _isOrdered(TimeOfDay start, TimeOfDay end) {
    return start.hour < end.hour ||
        (start.hour == end.hour && start.minute <= end.minute);
  }

  bool _isBefore(TimeOfDay t1, TimeOfDay t2) {
    return t1.hour < t2.hour || (t1.hour == t2.hour && t1.minute < t2.minute);
  }

  bool _timesOverlap(
      TimeOfDay start1, TimeOfDay end1, TimeOfDay start2, TimeOfDay end2) {
    /// Two time ranges [start1, end1] and [start2, end2] overlap if:
    // start1 < end2 AND start2 < end1
    return _isBefore(start1, end2) && _isBefore(start2, end1);
  }

  //AI generated
  for (int i = 0; i < times.length; i++) {
    if (times[i].length != 2) {
      throw ArgumentError(
          "Each entry must have exactly two times: start and end.");
    }

    TimeOfDay start1 = times[i][0];
    TimeOfDay end1 = times[i][1];

    /// Check if the ranges are globally sorted
    for (int i = 0; i < times.length - 1; i++) {
      if (!_isOrdered(times[i][0], times[i + 1][0])) {
        return true;
      }
    }

    /// Ensure that start and end times are in order
    if (!_isOrdered(start1, end1)) {
      return true;
    }

    for (int j = i + 1; j < times.length; j++) {
      TimeOfDay start2 = times[j][0];
      TimeOfDay end2 = times[j][1];

      if (!_isOrdered(start2, end2)) {
        return true;
      }

      // Check overlap between [start1, end1] and [start2, end2]
      if (_timesOverlap(start1, end1, start2, end2)) {
        return true;
      }
    }
  }
  return false; // No overlaps found
}
