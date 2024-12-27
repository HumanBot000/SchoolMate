import 'package:app/config/generic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule {
  final ScheduleMetadata metadata;

  Schedule(this.metadata);
}

class ScheduleMetadata {
  final DateTime creationDate; // localized time

  // localization not required because it's a time not a date
  final TimeOfDay firstLessonTime;
  final TimeOfDay lastLessonTime;
  final int numberOfAlternateWeeks;
  final String currentAlternatedWeek;
  final List<int> workdays;

  ScheduleMetadata(this.creationDate, this.firstLessonTime, this.lastLessonTime,
      this.numberOfAlternateWeeks, this.currentAlternatedWeek, this.workdays);

  factory ScheduleMetadata.fromSupabaseDBResponse(Map<String, dynamic> json) {
    final creationDate =
        DateFormat('yyyy-MM-dd').parse(json['created_at']).toLocal();
    final firstLessonTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['first_lesson']));
    final lastLessonTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['last_lesson']));
    final numberOfAlternateWeeks = int.parse(json['alternate_weeks']);
    final currentAlternatedWeek =
        json['current_week']; //todo rename in DB to current_alternated_week
    List<int> weekdays = [];
    for (int i = 0; i < 7; i++) {
      // Maybe it would be better to store an array of ints instead of strings in the DB
      final dayOfWeek = weekdaysAbbreviations[i].toLowerCase();
      if (json['workdays'].contains(dayOfWeek)) {
        weekdays.add(i);
      }
    }
    return ScheduleMetadata(creationDate, firstLessonTime, lastLessonTime,
        numberOfAlternateWeeks, currentAlternatedWeek, weekdays);
  }
}
