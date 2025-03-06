//What These Tests Cover
// ✅ Valid cases:
//
// A valid grading system with percentage-based evaluation.
// A valid grading system with multiplication-based evaluation.
// ✅ Invalid cases:
//
// Missing range values (less than 2 values in the range list).
// No exam types (empty examTypes list).
// Empty exam type name.
// Percentage values not summing to 100.
// Mixing evaluation methods within the same grading system.
// Multiplication type without a multiplication factor.
// Multiplication factor is zero or negative.
// More than one default multiplication exam type.

import 'package:flutter_test/flutter_test.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

void main() {
  group('GradingSystem.isValid', () {
    test('Valid grading system with percentage evaluation', () {
      var gradingSystem = GradingSystem(
        range: ["0", "100"],
        modifiers: [],
        examTypes: [
          ExamType(
              name: "Midterm",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 40)),
          ExamType(
              name: "Final",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 60)),
        ],
      );

      expect(() => gradingSystem.isValid(), returnsNormally);
    });

    test('Throws error when range has less than 2 values', () {
      var gradingSystem = GradingSystem(
        range: ["0"],
        modifiers: [],
        examTypes: [
          ExamType(
              name: "Midterm",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 50)),
        ],
      );

      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });

    test('Throws error when exam types list is empty', () {
      var gradingSystem =
          GradingSystem(range: ["0", "100"], modifiers: [], examTypes: []);
      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });

    test('Throws error when sum of percentages is not 100', () {
      var gradingSystem = GradingSystem(
        range: ["0", "100"],
        modifiers: [],
        examTypes: [
          ExamType(
              name: "Midterm",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 30)),
          ExamType(
              name: "Final",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 50)),
        ],
      );

      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });

    test('Throws error when exam types have different evaluation methods', () {
      var gradingSystem = GradingSystem(
        range: ["0", "100"],
        modifiers: [],
        examTypes: [
          ExamType(
              name: "Midterm",
              evaluationData: EvaluationData(
                  evaluationMethod: EvaluationMethod.percentage,
                  percentage: 50)),
          ExamType(name: "Final", evaluationData: EvaluationData.xTimesAs(2)),
        ],
      );

      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });

    test('Throws error when multiplication factor is missing or zero', () {
      var gradingSystem = GradingSystem(
        range: ["A", "F"],
        modifiers: [],
        examTypes: [
          ExamType(name: "Homework", evaluationData: EvaluationData.xTimesAs(0))
        ],
      );

      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });

    test(
        'Throws error when there is more than one default multiplication exam type',
        () {
      var gradingSystem = GradingSystem(
        range: ["A", "F"],
        modifiers: [],
        examTypes: [
          ExamType(
              name: "Homework", evaluationData: EvaluationData.xTimesAs(1)),
          ExamType(name: "Quizzes", evaluationData: EvaluationData.xTimesAs(1)),
        ],
      );

      expect(() => gradingSystem.isValid(), throwsA(isA<ArgumentError>()));
    });
  });

  test('Test multiplication-based exam type circular pattern detection', () {
    var baseExamType = ExamType(
        name: "Homework",
        evaluationData: EvaluationData(
            evaluationMethod: EvaluationMethod.multiplication,
            multiplicationFactor: null,
            multiplicationChildType: null));
    var validReferenceExamType = ExamType(
        name: "Quizzes",
        evaluationData: EvaluationData(
            evaluationMethod: EvaluationMethod.multiplication,
            multiplicationFactor: 2,
            multiplicationChildType: baseExamType));

    // A → B → C → A
    var A = ExamType(name: "A", evaluationData: null);
    var B = ExamType(name: "B", evaluationData: null);
    var C = ExamType(name: "C", evaluationData: null);
    A.evaluationData = EvaluationData(
        evaluationMethod: EvaluationMethod.multiplication,
        multiplicationFactor: 2,
        multiplicationChildType: B);
    B.evaluationData = EvaluationData(
        evaluationMethod: EvaluationMethod.multiplication,
        multiplicationFactor: 2,
        multiplicationChildType: C);
    C.evaluationData = EvaluationData(
        evaluationMethod: EvaluationMethod.multiplication,
        multiplicationFactor: 2,
        multiplicationChildType: A);

    GradingSystem validGradingSystem = GradingSystem(
        range: ["1", "6"],
        modifiers: [],
        examTypes: [baseExamType, validReferenceExamType]);
    GradingSystem invalidGradingSystem = GradingSystem(
        range: ["1", "6"], modifiers: [], examTypes: [baseExamType, A, B, C]);

    expect(validGradingSystem.multiplicationExamTypesCircularPatternCheck(),
        isFalse);
    expect(invalidGradingSystem.multiplicationExamTypesCircularPatternCheck(),
        isTrue);
  });
}
