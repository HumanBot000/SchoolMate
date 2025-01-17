import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

import 'ScheduleMetadata.dart';

class Schedule {
  final ScheduleMetadata metadata;
  final List<Subject>
      subjects; // All subjects the user has created, even those that aren't selected in the schedule
  final List<Lesson> lessons; // The individual lessons shown in the schedule
  Schedule(this.metadata, this.subjects, this.lessons);

  bool lessonOverlaps(TimeOfDay startTime, TimeOfDay endTime, int weekday,
      List<int> alternatingWeeks) {
    for (var lesson in lessons) {
      if (lesson.temporalData.weekday - 1 != weekday) {
        continue;
      }
      var isAtSameAlternatingWeek = lesson
          .temporalData.numericalAlternatingWeeks
          .toSet()
          .intersection(alternatingWeeks.toSet())
          .isNotEmpty;
      if (!isAtSameAlternatingWeek) {
        continue;
      }
      // Check if the time intervals overlap
      if (!(lesson.temporalData.endTime.hour < startTime.hour ||
              (lesson.temporalData.endTime.hour == startTime.hour &&
                  lesson.temporalData.endTime.minute <= startTime.minute)) &&
          !(lesson.temporalData.startTime.hour > endTime.hour ||
              (lesson.temporalData.startTime.hour == endTime.hour &&
                  lesson.temporalData.startTime.minute >= endTime.minute))) {
        return true;
      }
    }
    return false;
  }
}
