import 'package:collection/collection.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';

class GradingSystem {
  final List<String> range;
  final List<String> modifiers;
  final List<ExamType> examTypes;
  final int? id;

  GradingSystem(
      {required this.range,
      required this.modifiers,
      required this.examTypes,
      this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradingSystem &&
        other.range.length == range.length &&
        other.modifiers.length == modifiers.length &&
        const ListEquality().equals(other.range, range) &&
        const ListEquality().equals(other.modifiers, modifiers);
  }

  @override
  int get hashCode => Object.hash(
        range.length,
        modifiers.length,
        range.join(','),
        modifiers.join(','),
      );

  /// Uses Cycle Detection in a Directed Graph to check if the multiplication exam types form a circular pattern
  /// What we consider a circular pattern: (A → B → C → A)
  bool multiplicationExamTypesCircularPatternCheck() {
    if (examTypes.isEmpty ||
        examTypes[0].evaluationData.evaluationMethod !=
            EvaluationMethod.multiplication) {
      return false;
    }
    List<ExamType> valid = [];
    for (var element in examTypes) {
      if (element.evaluationData.multiplicationChildType == null) {
        // is base type
        valid.add(element);
        continue;
      }

      List<ExamType> visited = [];
      ExamType destination = element.evaluationData.multiplicationChildType!;
      while (destination.evaluationData.multiplicationChildType != null) {
        if (valid.contains(destination)) {
          // if we already know this path is valid we don't need to check further
          for (var element in visited) {
            valid.add(element);
          }
          break;
        }
        if (visited.contains(destination)) {
          // we already visited this exam type -> circular pattern
          return true;
        }
        visited.add(destination);
        destination = destination.evaluationData.multiplicationChildType!;
      }

      for (var element in visited) {
        valid.add(element);
      }
    }

    return false;
  }

  /// Ensures exam types are inserted in the correct order.
  /// Prevents referencing non-existent types using an iterative topological sort.
  // might not be the fastest algorithm, but we don't expect >10 ExamTypes
  List<ExamType> sortExamTypesForDatabaseInsertion() {
    if (examTypes.isEmpty ||
        examTypes[0].evaluationData.evaluationMethod !=
            EvaluationMethod.multiplication) {
      return examTypes;
    }

    List<ExamType> sortedList = [];
    Set<ExamType> seen = {};

    while (sortedList.length != examTypes.length) {
      bool progressMade = false;

      for (var element in examTypes) {
        if ((element.evaluationData.multiplicationChildType == null ||
                sortedList.contains(
                    element.evaluationData.multiplicationChildType)) &&
            !seen.contains(element)) {
          sortedList.add(element);
          seen.add(element);
          progressMade = true;
        }
      }

      if (!progressMade) {
        // check this before! This is only a fallback so the function doesn't run with O(∞) runtime
        throw Exception("Cyclic dependency detected in exam types!");
      }
    }

    return sortedList;
  }

  /// Checks if the GradingSystem is valid
  void isValid() {
    if (range.length != 2) {
      throw ArgumentError("Range must have exactly two values. (start, end)");
    }
    if (examTypes.isEmpty) {
      throw ArgumentError("Grading system must have at least one exam type");
    }
    // don't check if range is ordered because of non-numeric values

    bool hasSeenDefaultExamType = false;
    var lastExamEvaluationMethod = examTypes[0].evaluationData.evaluationMethod;
    double sum = 0;
    for (int i = 0; i < examTypes.length; i++) {
      if (lastExamEvaluationMethod !=
          examTypes[i].evaluationData.evaluationMethod) {
        throw ArgumentError(
            "All exam types must have the same evaluation method");
      }

      if (examTypes[i].name.isEmpty) {
        throw ArgumentError("All exam types must have a name");
      }
      if (lastExamEvaluationMethod == EvaluationMethod.percentage &&
          examTypes[i].evaluationData.percentage == null) {
        throw ArgumentError("All percentage exam types must have a percentage");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationFactor == null) {
        throw ArgumentError(
            "All multiplication exam types must have a multiplication factor");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationChildType == null) {
        if (hasSeenDefaultExamType) {
          throw ArgumentError(
              "There must be only one default multiplication exam type");
        } else {
          hasSeenDefaultExamType = true;
        }
      }
      if (examTypes.where((e) => e.name == examTypes[i].name).length > 1) {
        throw ArgumentError("Exam type names must be unique");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          (examTypes[i].evaluationData.multiplicationFactor ?? 0) <= 0) {
        throw ArgumentError("Multiplication factor must be greater than zero");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.percentage) {
        sum += examTypes[i].evaluationData.percentage!;
      }
    }

    if (lastExamEvaluationMethod == EvaluationMethod.percentage && sum != 100) {
      throw ArgumentError("The sum of all percentages must be 100");
    }
    if (multiplicationExamTypesCircularPatternCheck()) {
      throw ArgumentError("Multiplication exam types must not form a circle");
    }
  }

  factory GradingSystem.fromJson(Map<String, dynamic> gradingSystemJson,
      List<Map<String, dynamic>> examTypeJson) {
    List<ExamType> examTypes = [];

    Map<int, ExamType> multiplicationChildTypeCrossReferenceLookupTable = {};
    for (var element in examTypeJson) {
      ExamType examType = ExamType(
          id: element["id"],
          name: element["name"],
          evaluationData: EvaluationData(
              evaluationMethod: EvaluationMethod.values.firstWhere(
                  (evaluationMethod) =>
                      evaluationMethod.name ==
                      gradingSystemJson["evaluation_method"]),
              multiplicationFactor: element["multiplication_factor"],
              percentage: element["percentage"] is int
                  ? element["percentage"].toDouble()
                  : double.tryParse(element["percentage"].toString()),
              multiplicationChildType: element["multiplication_base"] == null
                  ? null
                  : multiplicationChildTypeCrossReferenceLookupTable[
                      element["multiplication_base"]]));

      multiplicationChildTypeCrossReferenceLookupTable[element["id"]] =
          examType;
      examTypes.add(examType);
    }

    return GradingSystem(
      range: [
        gradingSystemJson["best_mark"] is int
            ? gradingSystemJson["best_mark"].toDouble().toString()
            : gradingSystemJson["best_mark"]!.toString(),
        gradingSystemJson["worst_mark"] is int
            ? gradingSystemJson["worst_mark"].toDouble().toString()
            : gradingSystemJson["worst_mark"]!.toString(),
      ],
      modifiers: gradingSystemJson["modifiers"].cast<String>(),
      examTypes: examTypes,
      id: gradingSystemJson["id"],
    );
  }
}
