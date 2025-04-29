import 'package:collection/collection.dart';
import 'package:postgrest/src/types.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/API/supabase/schedule/subjects.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';

import 'gradingSystem.dart';

Future<List<Mark>> fetchMarks({bool onlyConsiderated = false}) async {
  final gradingSystem = await fetchGradingSystem();
  if (gradingSystem == null ||
      (gradingSystem is String && gradingSystem.isEmpty)) {
    return [];
  }

  PostgrestList marks = await supabaseClient.client
      .schema("grades")
      .from("marks")
      .select("*")
      .eq("user_id", await getUserID())
      .eq("consider", onlyConsiderated);

  return Future.wait(marks.map((mark) async {
    Subject subject = await fetchSubjectByID(mark["subject"]);
    return Mark.parse(
      id: mark["id"],
      createdAt: DateTime.parse(mark["created_at"]),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: gradingSystem.examTypes.firstWhere(
        (e) => e.id == mark["exam_type"],
      ),
      description: mark["description"],
      value: mark["value"],
    );
  }));
}

Future<Map<Subject, Map<String, Object>>> fetchMarksBySubjects(
    {bool onlyConsiderated = false}) async {
  final List<Mark> marks = await fetchMarks(onlyConsiderated: onlyConsiderated);

  var markMap = groupBy(marks, (Mark mark) => mark.subject);
  var marksPerExamType = markMap.map((subject, marks) =>
      MapEntry(subject, groupBy(marks, (Mark mark) => mark.examType)));

  return markMap.map((subject, markList) => MapEntry(subject, {
        "marks": markList,
        "marksPerExamType": marksPerExamType[subject]!,
      }));
}

Future<List<Mark>> fetchMarksForSubject(Subject subject,
    {bool onlyConsiderated = false}) async {
  final gradingSystem = await fetchGradingSystem();
  if (gradingSystem is String && gradingSystem.isEmpty) {
    return [];
  }

  PostgrestList marks;
  //We currently consider that there is maximum 1 GradingSystem
  if (onlyConsiderated) {
    marks = await supabaseClient.client
        .schema("grades")
        .from("marks")
        .select()
        .eq("user_id", await getUserID())
        .eq("consider", true)
        .eq("subject", subject.id);
  } else {
    marks = await supabaseClient.client
        .schema("grades")
        .from("marks")
        .select()
        .eq("user_id", await getUserID())
        .eq("subject", subject.id);
  }

  List<Mark> markList = [];
  for (var mark in marks) {
    Subject subject = await fetchSubjectByID(mark["subject"]);
    markList.add(Mark.parse(
      id: mark["id"],
      createdAt: DateTime.parse(mark["created_at"]),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: gradingSystem.examTypes
          .where((element) => element.id == mark["exam_type"])
          .first,
      value: mark["value"],
      description: mark["description"],
    ));
  }
  return markList;
}

Future<double?> calculateAverageMarkForSubject(Subject subject,
    {bool onlyConsiderated = false}) async {
  final List<Mark> subjectMarks =
      await fetchMarksForSubject(subject, onlyConsiderated: onlyConsiderated);
  if (subjectMarks.isEmpty) return null;

  if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
      EvaluationMethod.percentage) {
    var marksPerExamType = groupBy(subjectMarks, (Mark mark) => mark.examType);
    var averagePerExamType = marksPerExamType.map((examType, marks) {
      List<double> parsedMarks =
          marks.map((mark) => parseMark(mark.toRawString())).toList();
      double avg = parsedMarks.isNotEmpty
          ? parsedMarks.reduce((a, b) => a + b) / parsedMarks.length
          : 0.0;
      return MapEntry(examType, avg);
    });
    double totalWeight = averagePerExamType.keys.fold(0.0,
        (sum, examType) => sum + (examType.evaluationData.percentage ?? 0));

    if (totalWeight == 0) return null;
    double weightedAverage = averagePerExamType.entries.fold(0.0, (sum, entry) {
      double weight = (entry.key.evaluationData.percentage ?? 0) / totalWeight;
      return sum + (entry.value * weight);
    });

    return weightedAverage;
  } else if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
      EvaluationMethod.multiplication) {
    List<Mark> parsedMarks = List.from(subjectMarks);
    List<Mark> resultMarks = [];

    while (parsedMarks.any((mark) =>
        mark.examType.evaluationData.multiplicationChildType != null)) {
      List<Mark> nextIterationMarks = [];

      for (Mark mark in parsedMarks) {
        final childType = mark.examType.evaluationData.multiplicationChildType;
        final factor = mark.examType.evaluationData.multiplicationFactor ?? 1;

        if (childType != null) {
          for (int i = 0; i < factor; i++) {
            nextIterationMarks.add(
              mark.copyWith(
                examType: childType,
              ),
            );
          }
        } else {
          resultMarks.add(mark);
        }
      }

      parsedMarks = nextIterationMarks;
    }

    resultMarks.addAll(parsedMarks); // In case any final round marks are left

    if (resultMarks.isEmpty) return null;

    double avg = resultMarks
            .map((mark) => parseMark(mark.toRawString()))
            .reduce((a, b) => a + b) /
        resultMarks.length;

    return avg;
  }
  return null;
}

Future<Map<Subject, Map<ExamType, double?>>?>
    calculateAverageMarksBySubjectsAndExamTypes(List<Subject> subjects,
        {bool onlyConsiderated = false}) async {
  Map<Subject, Map<ExamType, double?>> marks = {};
  for (Subject subject in subjects) {
    final List<Mark> subjectMarks =
        await fetchMarksForSubject(subject, onlyConsiderated: onlyConsiderated);
    if (subjectMarks.isEmpty) {
      marks[subject] = {};
      continue;
    }

    if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
        EvaluationMethod.percentage) {
      var marksPerExamType =
          groupBy(subjectMarks, (Mark mark) => mark.examType);
      var averagePerExamType = marksPerExamType.map((examType, marks) {
        List<double> parsedMarks =
            marks.map((mark) => parseMark(mark.toRawString())).toList();
        double avg = parsedMarks.isNotEmpty
            ? parsedMarks.reduce((a, b) => a + b) / parsedMarks.length
            : 0.0;
        return MapEntry(examType, avg);
      });
      double totalWeight = averagePerExamType.keys.fold(0.0,
          (sum, examType) => sum + (examType.evaluationData.percentage ?? 0));

      if (totalWeight == 0) {
        marks[subject] = {};
        continue;
      }
      marks[subject] = averagePerExamType;
    } else if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
        EvaluationMethod.multiplication) {
      var marksPerExamType =
          groupBy(subjectMarks, (Mark mark) => mark.examType);
      var averagePerExamType = marksPerExamType.map((examType, marks) {
        List<double> parsedMarks =
            marks.map((mark) => parseMark(mark.toRawString())).toList();
        double avg = parsedMarks.isNotEmpty
            ? parsedMarks.reduce((a, b) => a + b) / parsedMarks.length
            : 0.0;
        return MapEntry(examType, avg);
      });
      marks[subject] = averagePerExamType;
    }
  }
  return marks;
}

Future<Map<Subject, double?>> calculateAverageMarksBySubjects(
    List<Subject> subjects,
    {bool onlyConsiderated = false}) async {
  return Map.fromEntries(await Future.wait(subjects.map((subject) async =>
      MapEntry(
          subject,
          await calculateAverageMarkForSubject(subject,
              onlyConsiderated: onlyConsiderated)))));
}

double parseMark(String mark) {
  // Replace comma with dot for localization
  mark = mark.replaceAll(',', '.');

  // Try to extract the first number from the string using RegExp
  final regex = RegExp(r'[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?');
  final match = regex.firstMatch(mark);
  if (match != null) {
    return double.parse(match.group(0)!);
  }

  // Handle letter grades
  const gradeMap = {"A": 1.0, "B": 2.0, "C": 3.0, "D": 4.0, "E": 5.0, "F": 6.0};
  return gradeMap[mark.trim().toUpperCase()]!;
}

String markRepresentation(
  dynamic value,
  GradingSystem gradingSystem, {
  String modifier = "",
}) {
  if (gradingSystem.range[0] == "A" && gradingSystem.range[1] == "F") {
    var reverseGradeMap = {
      "1.0": "A",
      "2.0": "B",
      "3.0": "C",
      "4.0": "D",
      "5.0": "E",
      "6.0": "F"
    };
    return reverseGradeMap[value] ??
        value.toStringAsFixed(gradingSystem.modifiers.contains(".") ? 1 : 0);
  }
  if (value is String) return value;
  return "${value.toStringAsFixed(gradingSystem.modifiers.contains(".") ? 1 : 0)}$modifier";
}

Future<void> insertMark(String value, Subject subject, ExamType examType,
    {String description = ""}) async {
  await supabaseClient.client.schema("grades").from("marks").insert({
    "user_id": await getUserID(),
    "subject": subject.id,
    "value": value,
    "grading_system": (await fetchGradingSystem()).id,
    "exam_type": examType.id,
    "description": description
  });
}
