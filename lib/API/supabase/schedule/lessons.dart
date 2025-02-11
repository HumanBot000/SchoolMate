import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/util/alphabet.dart';
import 'package:school_mate/util/extensions/dates.dart';

Future<void> addLesson(Subject subject, TimeOfDay startTime, TimeOfDay endTime,
    int weekday, List<int> alternatingWeeks, String roomNumber) async {
  await supabaseClient.client.schema("schedule").from("lessons").insert({
    "subject_id": subject.id,
    "weekday": weekday + 1,
    "start_time": DateFormat("HH:mm:ss").format(startTime.toDateTime()),
    "end_time": DateFormat("HH:mm:ss").format(endTime.toDateTime()),
    "alternating_weeks": getCharactersInAlphabet(alternatingWeeks),
    "room": roomNumber,
    "user_id": await getUserID(),
  });
}

Future<void> editLesson(
    Lesson oldLesson,
    Subject subject,
    TimeOfDay startTime,
    TimeOfDay endTime,
    int weekday,
    List<int> alternatingWeeks,
    String roomNumber) async {
  await supabaseClient.client
      .schema("schedule")
      .from("lessons")
      .update({
        "subject_id": subject.id,
        "weekday": weekday + 1,
        "start_time": DateFormat("HH:mm:ss").format(startTime.toDateTime()),
        "end_time": DateFormat("HH:mm:ss").format(endTime.toDateTime()),
        "alternating_weeks": getCharactersInAlphabet(alternatingWeeks),
        "room": roomNumber,
        "user_id": await getUserID(),
      })
      .eq("user_id", await getUserID())
      .eq("lesson_id", oldLesson.lessonID);
}

Future<void> deleteLesson(Lesson lesson) async {
  await supabaseClient.client
      .schema("schedule")
      .from("lessons")
      .delete()
      .eq("user_id", await getUserID())
      .eq("lesson_id", lesson.lessonID);
}
