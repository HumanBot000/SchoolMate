import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/pages/home/marks/setup/ExamTypeSelector.dart';

class GradingSetupPage extends StatefulWidget {
  final EvaluationMethod? selectedEvaluationMethod;

  const GradingSetupPage({super.key, this.selectedEvaluationMethod});

  @override
  State<GradingSetupPage> createState() => _GradingSetupPageState();
}

class _GradingSetupPageState extends State<GradingSetupPage> {
  GradingSystem? _selectedGradingSystem;
  late EvaluationMethod? _selectedEvaluationMethod;

  @override
  void initState() {
    super.initState();
    _selectedEvaluationMethod = widget.selectedEvaluationMethod;
  }

  Future<void> _onEvaluationMethodChange(
      EvaluationMethod? evaluationMethod) async {
    setState(() {
      _selectedEvaluationMethod = evaluationMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(
        "Grading Setup",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Before we can Start, we need to know some last details about your grading system.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      const SizedBox(height: 16),
      Divider(
        color: Theme.of(context).colorScheme.secondary,
        thickness: 1.5,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownMenu(
          leadingIcon: const Icon(Icons.numbers),
          initialSelection: _selectedGradingSystem,
          width: double.infinity,
          enableSearch: false,
          hintText: "Grading System",
          onSelected: (GradingSystem? value) {
            setState(() {
              _selectedGradingSystem = value;
            });
          },
          dropdownMenuEntries: [
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["1", "6"], modifiers: ["+", "-"]),
                label: "1-6 (±)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["15", "0"], modifiers: []),
                label: "15-0 Points"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["15", "0"], modifiers: ["."]),
                label: "15-0 Points (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["1", "6"], modifiers: ["."]),
                label: "1-6 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["100", "0"], modifiers: []),
                label: "100%-0%"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["1", "5"], modifiers: ["."]),
                label: "1-5 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["6", "1"], modifiers: ["."]),
                label: "6-1 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(range: ["A", "F"], modifiers: ["+", "-"]),
                label: "A-F (±)"),
          ],
        ),
      ),
      if (_selectedGradingSystem != null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                "The best mark is ",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                _selectedGradingSystem!.range[0],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.green.shade700, fontWeight: FontWeight.bold),
              ),
              Text(
                " and the worst mark is ",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                _selectedGradingSystem!.range[1],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red.shade700, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      if (_selectedGradingSystem != null &&
          _selectedGradingSystem!.modifiers.contains("+") &&
          _selectedGradingSystem!.modifiers.contains("-"))
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Additionally each mark can also get a ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "+",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " or ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  "-",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red.shade700, fontWeight: FontWeight.bold),
                ),
                Text(
                  " assigned",
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          ),
        )
      else if (_selectedGradingSystem != null &&
          _selectedGradingSystem!.modifiers.contains("."))
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(alignment: WrapAlignment.center, children: [
              Text(
                "It is possible to assign decimal values",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ])),
      Divider(
        color: Theme.of(context).colorScheme.secondary,
        thickness: 1.5,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Are there different types of exams?\n How are your marks weighted?",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      const SizedBox(height: 16),
      ExamTypeSelector(
        onChanged: (evaluationMethod) async {
          await _onEvaluationMethodChange(evaluationMethod);
        },
        selectedEvaluationMethod: _selectedEvaluationMethod,
      ),
    ]);
  }
}
