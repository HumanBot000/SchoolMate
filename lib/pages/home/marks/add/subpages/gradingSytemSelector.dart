import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

class GradingSystemSelector extends StatelessWidget {
  final GradingSystem gradingSystem;

  const GradingSystemSelector({super.key, required this.gradingSystem});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: gradingSystem.examTypes.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(gradingSystem.examTypes[index].name),
        subtitle: gradingSystem.examTypes[index].evaluationData.percentage ==
                null
            ? Text(
                "This Exam Group is worth ${gradingSystem.examTypes[index].evaluationData.multiplicationFactor}x as a mark  of ${gradingSystem.examTypes[index].evaluationData.multiplicationChildType?.name}")
            : Text(
                "This Exam Group is worth ${gradingSystem.examTypes[index].evaluationData.percentage}%"),
      ),
    );
  }
}
