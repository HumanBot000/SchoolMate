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
                    "Multiplication-based",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.selectedEvaluationMethod == EvaluationMethod.percentage) ...[
          Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Percentage-based Evaluation:",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "The final grade is calculated by averaging all exams within each category (e.g., homework and tests). Then, each category's average is weighted based on its importance to determine the overall result.\n\nFor example, if homework and tests contribute differently to the final grade, the formula would be:\n",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text:
                              "Final Grade = (Average of Homework × its weight + Average of Tests × its weight) / Total weight",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.pink.shade200,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (widget.selectedEvaluationMethod ==
            EvaluationMethod.multiplication) ...[
          Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Multiplication-based Evaluation:",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                        const TextSpan(
                            text:
                                "In this method, each exam in a group is counted as multiple exams based on its weight.\n\n"),
                        TextSpan(
                          text:
                              "For example, if a class paper is worth twice as much as a normal test, it will be counted as two exams when calculating the final grade\n\n ",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.pink.shade200,
                                  ),
                        ),
                        const TextSpan(
                            text:
                                "This way, some exams contribute more to the final result than others")
                      ])),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
