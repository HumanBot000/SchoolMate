import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/main.dart';

Future<void> setGradingSystem(GradingSystem gradingSystem) async {
  try {
    gradingSystem.isValid();
  } catch (e) {
    throw ArgumentError("Grading system is not valid: $e");
  }
  final List<ExamType> orderedInsertionSequenceOfExamTypes =
      gradingSystem.sortExamTypesForDatabaseInsertion();
  // uses hashCode
  Map<int?, int?> dbMultiplicationChildTypeCrossReferenceLookupTable = {
    null: null
  };

  // clear exam_types table
  await supabaseClient.client
      .schema("grades")
      .from("exam_types")
      .delete()
      .eq("user_id", await getUserID());
  await supabaseClient.client
      .schema("grades")
      .from("grading_systems")
      .delete()
      .eq("user_id", await getUserID());

  final system_table_response = await supabaseClient.client
      .schema("grades")
      .from("grading_systems")
      .insert({
        "user_id": await getUserID(),
        "best_mark": gradingSystem.range[0],
        "worst_mark": gradingSystem.range[1],
        "modifiers": gradingSystem.modifiers,
        "evaluation_method":
            gradingSystem.examTypes[0].evaluationData.evaluationMethod ==
                    EvaluationMethod.percentage
                ? "percentage"
                : "multiplication",
      })
      .select()
      .single();

  for (ExamType examType in orderedInsertionSequenceOfExamTypes) {
    final response = await supabaseClient.client
        .schema("grades")
        .from("exam_types")
        .insert({
          "user_id": await getUserID(),
          "name": examType.name,
          "multiplication_base":
              dbMultiplicationChildTypeCrossReferenceLookupTable[
                  examType.evaluationData.multiplicationChildType.hashCode],
          "multiplication_factor": examType.evaluationData.multiplicationFactor,
          "percentage": examType.evaluationData.percentage
        })
        .select()
        .single();

    dbMultiplicationChildTypeCrossReferenceLookupTable[examType.hashCode] =
        response["id"];
  }
}
