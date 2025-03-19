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
    return Mark(
      id: mark["id"],
      createdAt: DateTime.parse(mark["created_at"]),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: gradingSystem.examTypes.firstWhere(
        (e) => e.id == mark["exam_type"],
      ),
      value: mark["value"],
      description: mark["description"],
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
    markList.add(Mark(
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

  //todo
  if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
      EvaluationMethod.percentage) {
    var marksPerExamType = groupBy(subjectMarks, (Mark mark) => mark.examType);
    var averagePerExamType = marksPerExamType.map((examType, marks) {
      List<double> parsedMarks =
          marks.map((mark) => parseMark(mark.value.toString())).toList();
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

    //todo
    if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
        EvaluationMethod.percentage) {
      var marksPerExamType =
          groupBy(subjectMarks, (Mark mark) => mark.examType);
      var averagePerExamType = marksPerExamType.map((examType, marks) {
        List<double> parsedMarks =
            marks.map((mark) => parseMark(mark.value.toString())).toList();
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
  final parsedValue = double.tryParse(mark);
  if (parsedValue != null) return parsedValue;
  return {"A": 1.0, "B": 2.0, "C": 3.0, "D": 4.0, "E": 5.0, "F": 6.0}[mark]!;
}

String markRepresentation(double value, GradingSystem gradingSystem,
    {int decimalPlaces = 0}) {
  if (gradingSystem.range[0] == "A" && gradingSystem.range[1] == "F") {
    return {1.0: "A", 2.0: "B", 3.0: "C", 4.0: "D", 5.0: "E", 6.0: "F"}[value]!;
  }
  return value.toStringAsFixed(decimalPlaces);
}
