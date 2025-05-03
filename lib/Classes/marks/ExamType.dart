import 'dart:mathrt';

enum EvaluationMethod { percentage, multiplication }

/// There are 2 types of Evaluation Data.
/// The first is `percentage`: From all Exams of this ExamType, the average is being calculated.
/// So if you end up with a group A(30%) and a group B(70%), all exams of group A and B are averaged. Then you haven an ⌀A and ⌀B
/// Than the total result ge's calculated as follows: `(⌀A * 30% + ⌀B * 70%) / 100`.
/// The second type is `multiplication`: Here every exam of a group is counted like `x exams of the child group`.
class EvaluationData {
  final EvaluationMethod evaluationMethod;
  ExamType? multiplicationChildType;
  int? multiplicationFactor;
  double? percentage;

  EvaluationData({
    required this.evaluationMethod,
    this.multiplicationChildType,
    this.multiplicationFactor,
    this.percentage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EvaluationData &&
        other.evaluationMethod == evaluationMethod &&
        other.multiplicationChildType == multiplicationChildType &&
        other.multiplicationFactor == multiplicationFactor &&
        other.percentage == percentage;
  }

  @override
  int get hashCode => Object.hash(
        evaluationMethod,
        multiplicationChildType,
        multiplicationFactor,
        percentage,
      );

  factory EvaluationData.basic() => EvaluationData(
      evaluationMethod: EvaluationMethod.percentage, percentage: 100);

  factory EvaluationData.xTimesAs(int factor, {ExamType? base}) {
    // base = null ==> The default Test, from which all others arrive from
    return EvaluationData(
        evaluationMethod: EvaluationMethod.multiplication,
        multiplicationChildType: base,
        multiplicationFactor: factor);
  }

  factory EvaluationData.totalShare() => EvaluationData(
      evaluationMethod: EvaluationMethod.percentage, percentage: 100);
}

class ExamType {
  String name;
  EvaluationData evaluationData;
  int id;
  final int _uniqueId; // Random unique identifier per instance

  ExamType({
    required this.name,
    required this.id,
    EvaluationData? evaluationData,
  })  : evaluationData = evaluationData ?? EvaluationData.basic(),
        _uniqueId = Random().nextInt(1 << 32); // Generates a random integer

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExamType &&
        other.name == name &&
        other.evaluationData == evaluationData;
  }

  @override
  String toString() {
    return "ExamType $hashCode with name:$name and multiplicationChildType: ${evaluationData.multiplicationChildType.hashCode} and multiplicationFactor: ${evaluationData.multiplicationFactor}";
  }

  @override
  int get hashCode => Object.hash(name, _uniqueId); // Ensures unique hashCode

  factory ExamType.basic() =>
      ExamType(name: "Tests", evaluationData: EvaluationData.basic(), id: -1);

  factory ExamType.basicAsMultiplicationSystem() {
    var eval = EvaluationData.xTimesAs(1);
    return ExamType(name: "Tests", evaluationData: eval, id: -1);
  }
}
