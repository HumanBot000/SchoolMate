import 'package:collection/collection.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';

class GradingSystem {
  final List<String> range;
  final List<String> modifiers;
  final List<ExamType> examTypes;

  GradingSystem(
      {required this.range, required this.modifiers, required this.examTypes});

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
  int get hashCode =>
      Object.hash(
        range.length,
        modifiers.length,
        range.join(','),
        modifiers.join(','),
      );

  /// Checks if the GradingSystem is valid, but doesn't check if all exam types have an ID
  void isValid() {
    if (range.length != 2) {
      throw ArgumentError("Range must have exactly two values. (start, end)");
    }
    if (examTypes.isEmpty) {
      throw ArgumentError("Grading system must have at least one exam type.");
    }

    bool hasSeenDefaultExamType = false;
    var lastExamEvaluationMethod = examTypes[0].evaluationData.evaluationMethod;
    int sum = 0;
    for (int i = 1; i < examTypes.length; i++) {
      if (lastExamEvaluationMethod !=
          examTypes[i].evaluationData.evaluationMethod) {
        throw ArgumentError(
            "All exam types must have the same evaluation method.");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.percentage &&
          examTypes[i].evaluationData.percentage == null) {
        throw ArgumentError(
            "All percentage exam types must have a percentage.");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationFactor == null) {
        throw ArgumentError(
            "All multiplication exam types must have a multiplication factor.");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationChildTyp == null) {
        if (hasSeenDefaultExamType) {
          throw ArgumentError(
              "There must be only one default multiplication exam type.");
        } else {
          hasSeenDefaultExamType = true;
        }
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication) {
        sum += examTypes[i].evaluationData.multiplicationFactor!;
      }
    }


    if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
        !hasSeenDefaultExamType) {
      throw ArgumentError(
          "There must be only one default multiplication exam type.");
    }

    if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
        sum != 100) {
      throw ArgumentError(
          "The sum of all multiplication factors must be 100.");
    }
  }
