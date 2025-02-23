enum EvaluationMethod { percentage, multiplication }

/// There are 2 types of Evaluation Data.
/// The first is `percentage`: From all Exams of this ExamType, the average is being calculated.
/// So if you end up with a group A(30%) and a group B(70%), all exams of group A and B are averaged. Then you haven an ⌀A and ⌀B
/// Than the total result ge's calculated as follows: `(⌀A * 30% + ⌀B * 70%) / 100`.
/// The second type is `multiplication`: Here every exam of a group is counted like `x exams of the child group`.
class EvaluationData {
  final EvaluationMethod evaluationMethod;
  final ExamType? multiplicationChildType;
  final int? multiplicationFactor;
  final double? percentage;

  EvaluationData({
    required this.evaluationMethod,
    this.multiplicationChildType,
    this.multiplicationFactor,
    this.percentage,
  });

  factory EvaluationData.basic() => EvaluationData(
      evaluationMethod: EvaluationMethod.percentage, percentage: 100);

  factory EvaluationData.xTimesAs(ExamType base, int factor) => EvaluationData(
      evaluationMethod: EvaluationMethod.multiplication,
      multiplicationChildType: base,
      multiplicationFactor: factor);

  factory EvaluationData.totalShare() => EvaluationData(
      evaluationMethod: EvaluationMethod.percentage, percentage: 100);
}

class ExamType {
  final String name;
  final int id;
  final String description;

  ExamType({
    required this.name,
    required this.id,
    this.description = "",
  });
}
