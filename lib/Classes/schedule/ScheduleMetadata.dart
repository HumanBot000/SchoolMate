import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/util/dates.dart';

class ScheduleMetadata {
  final DateTime creationDate; // localized time

  // localization not required because it's a time not a date
  final TimeOfDay firstLessonTime;
  final TimeOfDay lastLessonTime;
  final int numberOfAlternateWeeks;
  final String currentAlternatedWeek;
  final List<int> workdays;
  final List<List<TimeOfDay>> visualLessonTimes;
  final int defaultLessonLength;

  ScheduleMetadata(
      this.creationDate,
      this.firstLessonTime,
      this.lastLessonTime,
      this.numberOfAlternateWeeks,
      this.currentAlternatedWeek,
      this.workdays,
      this.visualLessonTimes,
      this.defaultLessonLength);

  String alternatedWeekForDate(DateTime newDate) {
    // The preferred method is to use the view from the  postgresql function
    int dayDifference = newDate.difference(DateTime.now()).inDays;
    int weekDifference = (dayDifference / 7).floor();
    int newWeekType = ([
              "A",
              "B",
              "C",
              "D",
              "E",
              "F",
              "G",
              "H",
              "I",
              "J",
              "K",
              "L",
              "M",
              "N",
              "O",
              "P",
              "Q",
              "R",
              "S",
              "T",
              "U",
              "V",
              "W",
              "X",
              "Y",
              "Z"
            ].indexOf(currentAlternatedWeek) +
            weekDifference) %
        numberOfAlternateWeeks;
    if (newWeekType < 0) {
      newWeekType =
          (newWeekType + numberOfAlternateWeeks) % numberOfAlternateWeeks;
    }
    return [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ][newWeekType];
  }

  static List<List<TimeOfDay>> parseVisualLessonTimesJson(List<dynamic> json) {
    List<List<TimeOfDay>> visualLessonTimes = [];

    for (int i = 0; i < json.length; i++) {
      List<TimeOfDay> times = [];
      if (json[i].length != 2) {
        throw ArgumentError(
            "Each entry must have exactly two times: start and end.");
      }
      for (int j = 0; j < json[i].length; j++) {
        times
            .add(TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json[i][j])));
      }
      visualLessonTimes.add(times);
    }
    return visualLessonTimes;
  }

  factory ScheduleMetadata.fromSupabaseDBResponse(Map<String, dynamic> json) {
    final creationDate =
        DateFormat('yyyy-MM-dd').parse(json['created_at']).toLocal();
    final firstLessonTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['first_lesson']));
    final lastLessonTime =
        TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json['last_lesson']));
    final numberOfAlternateWeeks = json['alternate_weeks'];
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
    final visualLessonTimes =
        parseVisualLessonTimesJson(json['visual_daily_lessons_timeframe']);

    return ScheduleMetadata(
        creationDate,
        firstLessonTime,
        lastLessonTime,
        numberOfAlternateWeeks,
        currentAlternatedWeek,
        weekdays,
        visualLessonTimes,
        json["lesson_default_length"]);
  }
}
