import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

Future<void> insertScheduleMetadata(
  TimeOfDay startOfDay,
  TimeOfDay endOfDay,
  List<bool> workdays,
  int alternatingWeeksCount,
  int currentAlternatingWeek,
  int defaultLessonLength,
  List<List<TimeOfDay>> visualLessonTimes,
) async {
  alternatingWeeksCount += 1; // 0-indexed
  List<String> workdaysWithStrings = [];
  for (int i = 0; i < 7; i++) {
    if (workdays[i]) {
      workdaysWithStrings.add(weekdaysAbbreviations[i].toLowerCase());
    }
  }
  // If I later want to add more options I fear that this is the place I forget to Update. Safety > short code
  final String currentAlternatingWeekString = [
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
  ][currentAlternatingWeek];

  final Map<String, String> alternatingWeeksData = {
    "start_date": DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc()),
    "set_week": currentAlternatingWeekString,
  };
  // Example: {"start_date": "2024-01-01", "set_week": "A"}

  final String firstLesson = DateFormat("HH:mm:ss").format(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
        startOfDay.hour, startOfDay.minute),
  );
  final String lastLesson = DateFormat("HH:mm:ss").format(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
        endOfDay.hour, endOfDay.minute),
  );

  final List<List<String>> visualDailyLessonsTimeframe = [];
  for (int i = 0; i < visualLessonTimes.length; i++) {
    visualDailyLessonsTimeframe.add([
      DateFormat("HH:mm:ss").format(visualLessonTimes[i][0].toDateTime()),
      DateFormat("HH:mm:ss").format(visualLessonTimes[i][1].toDateTime())
    ]);
  }

  try {
    await supabaseClient!.client.schema("schedule").from("metadata").insert(({
          "user_id": await getUserID(),
          "first_lesson": firstLesson,
          "last_lesson": lastLesson,
          "alternate_weeks": alternatingWeeksCount,
          "week_cycle": alternatingWeeksData,
          "workdays": workdaysWithStrings,
          "lesson_default_length": defaultLessonLength,
          "visual_daily_lessons_timeframe": visualDailyLessonsTimeframe,
        }));
  } on Exception catch (e) {
    logger.e(e);
    rethrow;
  }
}
