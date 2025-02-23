import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';

class ExamTypeSelector extends StatefulWidget {
  final EvaluationMethod? selectedEvaluationMethod;
  final Function(EvaluationMethod) onChanged;

  const ExamTypeSelector(
      {super.key, required this.onChanged, this.selectedEvaluationMethod});

  @override
  State<ExamTypeSelector> createState() => _ExamTypeSelectorState();
}

class _ExamTypeSelectorState extends State<ExamTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedGradientButton(
                  onPressed: () {
                    widget.onChanged(EvaluationMethod.percentage);
                  },
                  gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.purple]),
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    "Percentage",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedGradientButton(
                  onPressed: () {
                    widget.onChanged(EvaluationMethod.multiplication);
                  },
                  gradient:
                      const LinearGradient(colors: [Colors.teal, Colors.green]),
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    "x-times",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
