import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/util/extensions/dates.dart';

class LessonTemporalData {
  final int weekday;
  final List<String> alternatingWeeks; // Ex: ["A","C"]
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  LessonTemporalData(
      this.weekday, this.alternatingWeeks, this.startTime, this.endTime);

  Duration get duration => endTime.difference(startTime);
}

class Lesson extends Subject {
  final int lesson_id;
  @override
  final int subject_id;
  @override
  final String name;
  @override
  final Teacher teacher;
  @override
  final Color color;
  final LessonTemporalData temporalData;

  Lesson(this.lesson_id, this.subject_id, this.name, this.teacher, this.color,
      this.temporalData)
      : super(
            name: name, teacher: teacher, color: color, subject_id: subject_id);

  factory Lesson.fromJson(Map<String, dynamic> json, List<Subject> subjects) =>
      Lesson(
        json["lesson_id"],
        json["subject_id"],
        subjects
            .firstWhere((subject) => subject.subject_id == json["subject_id"])
            .name,
        subjects
            .firstWhere((subject) => subject.subject_id == json["subject_id"])
            .teacher,
        subjects
            .firstWhere((subject) => subject.subject_id == json["subject_id"])
            .color,
        LessonTemporalData(
            json["weekday"],
            (json["alternating_weeks"] as List<dynamic>).cast<String>(),
            TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(json["start_time"])),
            TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(json["end_time"]))),
      );
}
