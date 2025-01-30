import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  int get dayOfYear {
    return int.parse(DateFormat("D").format(this));
  }
}

extension DateExtension on DateTime {
  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: this.hour, minute: this.minute);
  }

  DateTime startOfWeek() {
    return this.subtract(Duration(days: this.weekday - 1));
  }
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(1, 1, 1, this.hour, this.minute);
  }

  bool isBetween(TimeOfDay start, TimeOfDay end) {
    final int currentMinutes = hour * 60 + minute;
    final int startMinutes = start.hour * 60 + start.minute;
    final int endMinutes = end.hour * 60 + end.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  TimeOfDay add(Duration duration) {
    return toDateTime().add(duration).toTimeOfDay();
  }

  TimeOfDay subtract(Duration duration) {
    return toDateTime().subtract(duration).toTimeOfDay();
  }

  Duration difference(TimeOfDay startTime) {
    return Duration(
        hours: hour - startTime.hour, minutes: minute - startTime.minute);
  }
}
