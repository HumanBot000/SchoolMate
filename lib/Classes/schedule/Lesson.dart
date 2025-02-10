import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/util/alphabet.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

class LessonTemporalData {
  final int weekday;
  final List<String> alternatingWeeks; // Ex: ["A","C"]
  final List<int> numericalAlternatingWeeks; // Ex: [0,2]
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  LessonTemporalData(this.weekday, this.alternatingWeeks, this.startTime,
      this.endTime, this.numericalAlternatingWeeks);

  Duration get duration => endTime.difference(startTime);

  DateTime get startDateTime => getStartOfWeek(DateTime.now())
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)
      .add(Duration(days: weekday - 1))
      .add(Duration(hours: startTime.hour, minutes: startTime.minute));
}

class Lesson extends Subject {
  final int lessonID;
  final Subject subject;
  final LessonTemporalData temporalData;
  final String? location;

  Lesson(this.lessonID, this.subject, this.temporalData, this.location)
      : super(
            name: subject.name,
            teacher: subject.teacher,
            color: subject.color,
            id: subject.id);

  factory Lesson.fromJson(Map<String, dynamic> json, List<Subject> subjects) =>
      Lesson(
        json["lesson_id"],
        subjects.firstWhere((subject) => subject.id == json["subject_id"]),
        LessonTemporalData(
          json["weekday"],
          (json["alternating_weeks"] as List<dynamic>).cast<String>(),
          TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json["start_time"])),
          TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json["end_time"])),
          getIndexesInAlphabet(
              (json["alternating_weeks"] as List<dynamic>).cast<String>()),
        ),
        json["room"],
      );
}
