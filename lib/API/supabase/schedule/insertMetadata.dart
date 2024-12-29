import 'dart:convert';

import 'package:app/API/supabase/auth/userData.dart';
import 'package:app/main.dart';
import 'package:app/util/dates.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> insertScheduleMetadata(
    TimeOfDay startOfDay,
    TimeOfDay endOfDay,
    List<int> workdays,
    int alternatingWeeksCount,
    int currentAlternatingWeek,
    int defaultLessonLength) async {
  alternatingWeeksCount += 1; // 0-indexed
  List<String> workdaysWithStrings = [];
  for (int i = 0; i < 7; i++) {
    if (!workdays.contains(i)) {
      continue;
    }
    workdaysWithStrings.add(weekdaysAbbreviations[i].toLowerCase());
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

  final String alternatingWeeksData = jsonEncode(
      '{"start_date": "${DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc())}", "set_week": "$currentAlternatingWeekString'); // Example: {"start_date": "2024-01-01", "set_week": "A"}

  try {
    await supabaseClient.client.schema("schedule").from("metadata").insert(({
          "user_id": await getUserID(),
          "first_lesson": startOfDay,
          "last_lesson": endOfDay,
          "alternate_weeks": alternatingWeeksCount,
          "week_cycle": alternatingWeeksData,
          "workdays": workdaysWithStrings,
          "lesson_default_length": defaultLessonLength
        }));
  } on Exception catch (e) {
    logger.e(e);
    rethrow;
  }
}
