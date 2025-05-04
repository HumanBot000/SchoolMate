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

/// Central cache storage for marks data to prevent redundant fetching
class MarksCache {
  static List<Mark>? _allMarks;
  static Map<String, Subject?>? _subjectCache;
  static GradingSystem? _gradingSystem;
  static DateTime? _lastFetchTime;

  /// Clears the cache to force a refresh on next fetch
  static void invalidateCache() {
    _allMarks = null;
    _subjectCache = null;
    _lastFetchTime = null;
  }

  /// Check if cache is still valid (less than 5 minutes old)
  static bool isCacheValid() {
    if (_lastFetchTime == null || _allMarks == null) return false;

    final now = DateTime.now();
    // Cache expires after 5 minutes
    return now.difference(_lastFetchTime!).inMinutes < 5;
  }
}

/// Loads all necessary data once and caches it
Future<List<Mark>> _loadAllMarksData({bool forceRefresh = false}) async {
  // Return cached data if it exists and is still valid
  if (!forceRefresh &&
      MarksCache.isCacheValid() &&
      MarksCache._allMarks != null) {
    return MarksCache._allMarks!;
  }

  logger.i("Fetching fresh marks data from database");

  // Fetch grading system
  final gradingSystem = await fetchGradingSystem();
  if (gradingSystem == null ||
      (gradingSystem is String && gradingSystem.isEmpty)) {
    MarksCache._allMarks = [];
    MarksCache._lastFetchTime = DateTime.now();
    return [];
  }

  MarksCache._gradingSystem = gradingSystem;

  // Fetch all marks in single query
  PostgrestList marks = await supabaseClient.client
      .schema("grades")
      .from("marks")
      .select("*")
      .eq("user_id", await getUserID());

  // Fetch all required subjects at once
  final uniqueSubjectIds =
      marks.map((mark) => mark["subject"].toString()).toSet().toList();
  final subjects = await Future.wait(
      uniqueSubjectIds.map((id) => fetchSubjectByID(int.parse(id))));

  // Create a lookup map for faster subject access
  MarksCache._subjectCache = Map.fromIterables(uniqueSubjectIds, subjects);

  // Parse all marks
  List<Mark> parsedMarks = [];

  for (var mark in marks) {
    String subjectId = mark["subject"].toString();
    Subject? subject = MarksCache._subjectCache?[subjectId];

    // Skip marks with missing subjects
    if (subject == null) {
      logger.w("Skipping mark with ID ${mark["id"]} - Subject not found");
      continue;
    }

    // Find exam type
    ExamType? examType;
    try {
      examType = gradingSystem.examTypes.firstWhere(
        (e) => e.id == mark["exam_type"],
      );
    } catch (e) {
      logger.w("Skipping mark with ID ${mark["id"]} - Exam type not found");
      continue;
    }

    // Create mark
    parsedMarks.add(Mark.parse(
      id: mark["id"],
      createdAt: DateTime.parse(mark["created_at"]),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: examType!,
      description: mark["description"],
      value: mark["value"],
      isConsidered: mark["consider"],
    ));
  }

  // Store in cache
  MarksCache._allMarks = parsedMarks;
  MarksCache._lastFetchTime = DateTime.now();

  return parsedMarks;
}

/// Fetches all marks, with optional filtering for considered marks only
Future<List<Mark>> fetchMarks(
    {bool onlyConsiderated = false, bool forceRefresh = false}) async {
  final allMarks = await _loadAllMarksData(forceRefresh: forceRefresh);

  if (onlyConsiderated) {
    return allMarks.where((mark) => mark.isConsidered).toList();
  }

  return allMarks;
}

/// Fetches marks organized by subject
Future<Map<Subject, Map<String, Object>>> fetchMarksBySubjects(
    {bool onlyConsiderated = false, bool forceRefresh = false}) async {
  final List<Mark> marks = await fetchMarks(
      onlyConsiderated: onlyConsiderated, forceRefresh: forceRefresh);

  var markMap = groupBy(marks, (Mark mark) => mark.subject);
  var marksPerExamType = markMap.map((subject, marks) =>
      MapEntry(subject, groupBy(marks, (Mark mark) => mark.examType)));

  return markMap.map((subject, markList) => MapEntry(subject, {
        "marks": markList,
        "marksPerExamType": marksPerExamType[subject]!,
      }));
}

/// Fetches marks for a specific subject
Future<List<Mark>> fetchMarksForSubject(Subject subject,
    {bool onlyConsiderated = false, bool forceRefresh = false}) async {
  final allMarks = await fetchMarks(
      onlyConsiderated: onlyConsiderated, forceRefresh: forceRefresh);

  return allMarks.where((mark) => mark.subject.id == subject.id).toList();
}

/// Calculates average mark for a specific subject
Future<double?> calculateAverageMarkForSubject(Subject subject,
    {bool onlyConsiderated = false, bool forceRefresh = false}) async {
  final List<Mark> subjectMarks = await fetchMarksForSubject(subject,
      onlyConsiderated: onlyConsiderated, forceRefresh: forceRefresh);

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

/// Calculates average marks grouped by subjects and exam types
Future<Map<Subject, Map<ExamType, double?>>>
    calculateAverageMarksBySubjectsAndExamTypes(List<Subject> subjects,
        {bool onlyConsiderated = false, bool forceRefresh = false}) async {
  final Map<Subject, List<Mark>> subjectMarksMap = {};

  // Get all marks first
  final allMarks = await fetchMarks(
      onlyConsiderated: onlyConsiderated, forceRefresh: forceRefresh);

  // Group marks by subject
  for (final subject in subjects) {
    subjectMarksMap[subject] =
        allMarks.where((mark) => mark.subject.id == subject.id).toList();
  }

  // Calculate averages
  Map<Subject, Map<ExamType, double?>> results = {};

  for (final subject in subjects) {
    final List<Mark> subjectMarks = subjectMarksMap[subject] ?? [];
    if (subjectMarks.isEmpty) {
      results[subject] = {};
      continue;
    }

    if (subjectMarks.isNotEmpty) {
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
        results[subject] = averagePerExamType;
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
        results[subject] = averagePerExamType;
      } else {
        results[subject] = {};
      }
    } else {
      results[subject] = {};
    }
  }

  return results;
}

/// Calculates average marks for all subjects
Future<Map<Subject, double?>> calculateAverageMarksBySubjects(
    List<Subject> subjects,
    {bool onlyConsiderated = false,
    bool forceRefresh = false}) async {
  final allMarks = await fetchMarks(
      onlyConsiderated: onlyConsiderated, forceRefresh: forceRefresh);

  Map<Subject, double?> results = {};

  for (final subject in subjects) {
    final subjectMarks =
        allMarks.where((mark) => mark.subject.id == subject.id).toList();

    if (subjectMarks.isEmpty) {
      results[subject] = null;
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
        results[subject] = null;
        continue;
      }

      double weightedAverage =
          averagePerExamType.entries.fold(0.0, (sum, entry) {
        double weight =
            (entry.key.evaluationData.percentage ?? 0) / totalWeight;
        return sum + (entry.value * weight);
      });

      results[subject] = weightedAverage;
    } else if (subjectMarks.first.examType.evaluationData.evaluationMethod ==
        EvaluationMethod.multiplication) {
      List<Mark> parsedMarks = List.from(subjectMarks);
      List<Mark> resultMarks = [];

      while (parsedMarks.any((mark) =>
          mark.examType.evaluationData.multiplicationChildType != null)) {
        List<Mark> nextIterationMarks = [];

        for (Mark mark in parsedMarks) {
          final childType =
              mark.examType.evaluationData.multiplicationChildType;
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

      if (resultMarks.isEmpty) {
        results[subject] = null;
        continue;
      }

      double avg = resultMarks
              .map((mark) => parseMark(mark.toRawString()))
              .reduce((a, b) => a + b) /
          resultMarks.length;

      results[subject] = avg;
    } else {
      results[subject] = null;
    }
  }

  return results;
}

/// Helper function to parse mark values
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

/// Creates a string representation of a mark
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

/// Inserts a new mark
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

  // Invalidate cache to reflect new data
  MarksCache.invalidateCache();
}

/// Updates an existing mark
Future<void> updateMark(Mark oldMark, Mark newMark) async {
  await supabaseClient.client
      .schema("grades")
      .from("marks")
      .update({
        "user_id": await getUserID(),
        "subject": newMark.subject.id,
        "value": newMark.toRawString(),
        "grading_system": (await fetchGradingSystem()).id,
        "exam_type": newMark.examType.id,
        "description": newMark.description
      })
      .eq("user_id", await getUserID())
      .eq("id", oldMark.id);

  // Invalidate cache to reflect updated data
  MarksCache.invalidateCache();
}

/// Fetches most recent marks for multiple subjects
Future<Map<Subject, List<Mark>>> fetchMostRecentMarksForSubjects(
    GradingSystem gradingSystem, List<Subject> subjects,
    {int limitPerSubject = 3, bool forceRefresh = false}) async {
  // First try to use cached data if available
  final allMarks = await fetchMarks(forceRefresh: forceRefresh);

  Map<Subject, List<Mark>> result = {};

  for (Subject subject in subjects) {
    // Filter and sort marks for this subject
    List<Mark> subjectMarks = allMarks
        .where((mark) => mark.subject.id == subject.id)
        .toList()
      ..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by most recent

    // Take only the requested number of marks
    result[subject] = subjectMarks.take(limitPerSubject).toList();
  }

  return result;
}

/// Deletes a mark
Future<void> deleteMark(Mark mark) async {
  await supabaseClient.client
      .schema("grades")
      .from("marks")
      .delete()
      .eq("user_id", await getUserID())
      .eq("id", mark.id);

  // Invalidate cache to reflect deleted data
  MarksCache.invalidateCache();

  logger.i("Deleted Mark with ID ${mark.id}");
}
