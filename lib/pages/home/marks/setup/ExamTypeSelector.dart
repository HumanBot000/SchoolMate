import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';

class ExamTypeSelector extends StatefulWidget {
  final EvaluationMethod? selectedEvaluationMethod;
  final Function(EvaluationMethod) onChanged;
  final List<TextEditingController> evaluationMethodNameTextControllers;
  final List<ExamType> examTypes;
  final Function(List<ExamType>) onExamTypeChanges;

  const ExamTypeSelector({
    super.key,
    required this.onChanged,
    this.selectedEvaluationMethod,
    required this.evaluationMethodNameTextControllers,
    required this.examTypes,
    required this.onExamTypeChanges,
  });

  @override
  State<ExamTypeSelector> createState() => _ExamTypeSelectorState();
}

class _ExamTypeSelectorState extends State<ExamTypeSelector> {
  @override
  Widget build(BuildContext context) {
    // Use Column instead of ListView to avoid nested scrolling issues.
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Percentage",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Multiplication-based",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.selectedEvaluationMethod != null &&
            widget.selectedEvaluationMethod == EvaluationMethod.percentage) ...[
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
        if (widget.selectedEvaluationMethod != null &&
            widget.selectedEvaluationMethod ==
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
                              "For example, if a class paper is worth twice as much as a normal test, it will be counted as two exams when calculating the final grade\n\n",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.pink.shade200,
                                  ),
                        ),
                        const TextSpan(
                            text:
                                "This way, some exams contribute more to the final result than others"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (widget.examTypes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildExamTypeCards(widget.examTypes),
          ),
        if (widget.selectedEvaluationMethod != null)
          IconGradientButton(
            onPressed: () async {
              List<ExamType> newExamTypes = widget.examTypes;
              newExamTypes.add(ExamType.basic());
              await widget.onExamTypeChanges(newExamTypes);
            },
            icon: Icon(Icons.add),
            tooltip: "Add a new Exam Type",
          )
      ],
    );
  }

  // Using a ListView.builder with shrinkWrap is acceptable here, since we set physics to never scroll.
  Widget _buildExamTypeCards(List<ExamType> examTypes) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: examTypes.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            elevation: 4.0,
            shadowColor: Colors.blueAccent.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller:
                        widget.evaluationMethodNameTextControllers[index],
                    onChanged: (value) async {},
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.text_snippet, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "before the lesson starts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      List<ExamType> newExamTypes = widget.examTypes;
                      newExamTypes.removeAt(index);
                      await widget.onExamTypeChanges(newExamTypes);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
