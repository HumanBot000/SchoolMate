import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';

class ExamTypeSelector extends StatefulWidget {
  final EvaluationMethod? selectedEvaluationMethod;
  final Function(EvaluationMethod) onChanged;
  final List<List<TextEditingController>> evaluationMethodNameTextControllers;
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
            child: _buildPercentageExamTypeCards(widget.examTypes),
          ),
        if (widget.selectedEvaluationMethod != null)
          IconGradientButton(
            onPressed: () async {
              List<ExamType> newExamTypes = widget.examTypes;
              newExamTypes.add(ExamType.basic());
              await widget.onExamTypeChanges(newExamTypes);
            },
            icon: const Icon(Icons.add),
            tooltip: "Add a new Exam Type",
          )
      ],
    );
  }

  // Using a ListView.builder with shrinkWrap is acceptable here, since we set physics to never scroll.
  Widget _buildPercentageExamTypeCards(List<ExamType> examTypes) =>
      ListView.builder(
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
                        widget.evaluationMethodNameTextControllers[index][0],
                    onEditingComplete: () async {
                      String value = widget
                          .evaluationMethodNameTextControllers[index][0].text
                          .trim();
                      if (value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text("Exam type name cannot be empty"),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      }
                      List<ExamType> newExamTypes = List.from(widget.examTypes);
                      newExamTypes[index].name = value;
                      await widget.onExamTypeChanges(newExamTypes);
                    },
                    decoration: const InputDecoration(
                      prefixIcon:
                          Icon(Icons.text_snippet, color: Colors.blueAccent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "These exams will contribute to your final grade, accounting for",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  TextField(
                    controller:
                        widget.evaluationMethodNameTextControllers[index][1],
                    onEditingComplete: () {
                      String value = widget
                          .evaluationMethodNameTextControllers[index][1].text
                          .trim();
                      double? parsedValue = double.tryParse(value);
                      if (parsedValue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Percentage must be a number"),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      }
                      if (parsedValue < 0 || parsedValue > 100) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text("Percentage must be > 0 and < 100"),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                        return;
                      }

                      List<ExamType> newExamTypes = List.from(widget.examTypes);
                      newExamTypes[index].evaluationData.percentage =
                          parsedValue;
                      widget.onExamTypeChanges(newExamTypes);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffix: Text(
                        "%",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      errorText: double.tryParse(widget
                                      .evaluationMethodNameTextControllers[
                                          index][1]
                                      .text) ==
                                  null ||
                              double.parse(widget
                                      .evaluationMethodNameTextControllers[
                                          index][1]
                                      .text) <
                                  0
                          ? "Enter a valid non-negative number"
                          : null,
                    ),
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
