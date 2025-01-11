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
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(1, 1, 1, this.hour, this.minute);
  }

  TimeOfDay add(Duration duration) {
    return toDateTime().add(duration).toTimeOfDay();
  }

  Duration difference(TimeOfDay startTime) {
    return Duration(
        hours: hour - startTime.hour, minutes: minute - startTime.minute);
  }
}
