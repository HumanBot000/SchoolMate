import 'package:postgrest/src/types.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/API/supabase/schedule/subjects.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';

import 'gradingSystem.dart';

Future<List<Mark>> fetchMarks({bool onlyConsiderated = false}) async {
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
        .eq("consider", true);
  } else {
    marks = await supabaseClient.client
        .schema("grades")
        .from("marks")
        .select()
        .eq("user_id", await getUserID());
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
        value: mark["value"]));
  }
  return markList;
}

Future<Map<Subject, List<Mark>>> fetchMarksBySubjects(
    {bool onlyConsiderated = false}) async {
  final List<Mark> marks = await fetchMarks(onlyConsiderated: onlyConsiderated);
  Map<Subject, List<Mark>> markMap = {};
  for (Mark mark in marks) {
    if (!markMap.containsKey(mark.subject)) {
      markMap[mark.subject] = [];
    }
    markMap[mark.subject]!.add(mark);
  }
  return markMap;
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
        value: mark["value"]));
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
    // Group marks by exam type
    Map<ExamType, List<String>> marksPerExamType = {};
    for (Mark mark in subjectMarks) {
      marksPerExamType
          .putIfAbsent(mark.examType, () => [])
          .add(mark.value.toString());
    }
    // Calculate average per exam type
    Map<ExamType, double> averagePerExamType = {};
    for (MapEntry<ExamType, List<String>> entry in marksPerExamType.entries) {
      double total = 0.0;
      for (String mark in entry.value) {
        total +=
            parseMark(mark); // Assuming parseMark() handles non-numeric values
      }
      double average = total / entry.value.length;
      averagePerExamType[entry.key] = average;
    }
    // Calculate total weight of the filled exam types
    double totalWeightOfFilledExamTypes = 0;
    for (ExamType examType in averagePerExamType.keys) {
      totalWeightOfFilledExamTypes += examType.evaluationData.percentage!;
    }
    totalWeightOfFilledExamTypes /= 100;
    // Adjust weights and calculate the final weighted average
    double finalAverage = 0;
    for (MapEntry<ExamType, double> entry in averagePerExamType.entries) {
      double adjustedWeight =
          entry.key.evaluationData.percentage! / totalWeightOfFilledExamTypes;
      finalAverage += entry.value * (adjustedWeight / 100);
    }

    return finalAverage;
  }
  return null;
}

Future<Map<Subject, double?>> calculateAverageMarksBySubjects(
    List<Subject> subjects,
    {bool onlyConsiderated = false}) async {
  Map<Subject, double?> averageMarks = {};
  for (Subject subject in subjects) {
    averageMarks[subject] = await calculateAverageMarkForSubject(subject,
        onlyConsiderated: onlyConsiderated);
  }
  return averageMarks;
}

double parseMark(String mark) {
  //TODO
  final parsedValue = double.tryParse(mark);
  return parsedValue ?? 0.0; // Return 0.0 or handle as needed
}
