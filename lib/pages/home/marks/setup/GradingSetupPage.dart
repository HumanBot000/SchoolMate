import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/pages/home/marks/setup/ExamTypeSelector.dart';

import '../../../../main.dart';

class GradingSetupPage extends StatefulWidget {
  final GradingSystem? selectedGradingSystem;

  const GradingSetupPage({super.key, this.selectedGradingSystem});

  @override
  State<GradingSetupPage> createState() => _GradingSetupPageState();
}

class _GradingSetupPageState extends State<GradingSetupPage> {
  GradingSystem? _selectedGradingSystem;
  late EvaluationMethod? _selectedEvaluationMethod;
  List<List<TextEditingController>> _examTypeTextControllers = [];
  List<ExamType> _examTypes = [];

  @override
  void initState() {
    super.initState();
    _selectedGradingSystem ??= GradingSystem(
        range: ["1", "6"], modifiers: ["+"], examTypes: [ExamType.basic()]);
    _selectedEvaluationMethod = widget
        .selectedGradingSystem?.examTypes[0].evaluationData.evaluationMethod;
    _examTypes = widget.selectedGradingSystem?.examTypes ?? [];

    logger.d(_selectedGradingSystem!.examTypes.length);
    if (_selectedGradingSystem != null) {
      _examTypeTextControllers = List.generate(
        _examTypes.length,
        (index) => [
          TextEditingController(text: _examTypes[index].name),
          TextEditingController(
              text: _examTypes[index].evaluationData.evaluationMethod ==
                      EvaluationMethod.multiplication
                  ? _examTypes[index]
                      .evaluationData
                      .multiplicationFactor
                      .toString()
                  : _examTypes[index].evaluationData.percentage.toString())
        ],
      );
    }
  }

  @override
  void dispose() {
    // Dispose all TextEditingControllers to avoid memory leaks.
    for (var controller in _examTypeTextControllers) {
      for (var controller in controller) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _onEvaluationMethodChange(
      EvaluationMethod? evaluationMethod) async {
    setState(() {
      _selectedEvaluationMethod = evaluationMethod;
    });
  }

  Future<void> _onExamTypeChanges(List<ExamType> examTypes) async {
    setState(() {
      _examTypes = examTypes;

      // Ensure controllers exist for each exam type
      for (int i = 0; i < _examTypes.length; i++) {
        if (i >= _examTypeTextControllers.length) {
          // If new exam types are added, create new controllers
          _examTypeTextControllers.add([
            TextEditingController(text: _examTypes[i].name),
            TextEditingController(
                text: _examTypes[i].evaluationData.evaluationMethod ==
                        EvaluationMethod.multiplication
                    ? _examTypes[i]
                        .evaluationData
                        .multiplicationFactor
                        .toString()
                    : _examTypes[i].evaluationData.percentage.toString())
          ]);
        } else {
          // Update existing controllers to avoid losing focus
          _examTypeTextControllers[i][0].text = _examTypes[i].name;
          _examTypeTextControllers[i][1].text =
              _examTypes[i].evaluationData.evaluationMethod ==
                      EvaluationMethod.multiplication
                  ? _examTypes[i].evaluationData.multiplicationFactor.toString()
                  : _examTypes[i].evaluationData.percentage.toString();
        }
      }

      // Remove excess controllers if exam types are reduced
      while (_examTypeTextControllers.length > _examTypes.length) {
        _examTypeTextControllers.removeLast();
      }
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
          initialSelection: _selectedGradingSystem!,
          leadingIcon: const Icon(Icons.numbers),
          width: double.infinity,
          enableSearch: false,
          hintText: "Grading System",
          onSelected: (GradingSystem? value) {
            setState(() {
              _selectedGradingSystem = value;
              // Update the controllers to match the new exam types.
              _examTypeTextControllers = List.generate(
                _selectedGradingSystem!.examTypes.length,
                (index) => [
                  TextEditingController(text: _examTypes[index].name),
                  TextEditingController(
                      text: _examTypes[index].evaluationData.evaluationMethod ==
                              EvaluationMethod.multiplication
                          ? _examTypes[index]
                              .evaluationData
                              .multiplicationFactor
                              .toString()
                          : _examTypes[index]
                              .evaluationData
                              .percentage
                              .toString())
                ],
              );
            });
          },
          dropdownMenuEntries: [
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["1", "6"],
                  modifiers: ["+", "-"],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "1-6 (±)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["15", "0"],
                  modifiers: [],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "15-0 Points"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["15", "0"],
                  modifiers: ["."],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "15-0 Points (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["1", "6"],
                  modifiers: ["."],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "1-6 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["100", "0"],
                  modifiers: [],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "100%-0%"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["1", "5"],
                  modifiers: ["."],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "1-5 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["6", "1"],
                  modifiers: ["."],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
                label: "6-1 (With Decimals)"),
            DropdownMenuEntry<GradingSystem>(
                value: GradingSystem(
                  range: ["A", "F"],
                  modifiers: ["+", "-"],
                  examTypes: _selectedGradingSystem?.examTypes ?? [],
                ),
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
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                "It is possible to assign decimal values",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
        ),
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
        evaluationMethodNameTextControllers: _examTypeTextControllers,
        examTypes: _examTypes,
        onExamTypeChanges: _onExamTypeChanges,
      ),
    ]);
  }
}
