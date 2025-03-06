import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/setGradingSystem.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/marks/setup/ExamTypeSelector.dart';

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
    _examTypes = widget.selectedGradingSystem?.examTypes ??
        _selectedGradingSystem!.examTypes;
    _onExamTypeChanges(_examTypes);
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
    List<ExamType> newExamTypes;
    if (evaluationMethod == EvaluationMethod.percentage) {
      newExamTypes = [ExamType.basic()];
    } else {
      newExamTypes = [ExamType.basicAsMultiplicationSystem()];
    }
    setState(() {
      _selectedEvaluationMethod = evaluationMethod;
      _examTypes = newExamTypes;
    });
    await _onExamTypeChanges(newExamTypes);
  }

  Future<void> _onExamTypeChanges(List<ExamType> examTypes) async {
    setState(() {
      _examTypes = examTypes;
      if (_examTypes.isNotEmpty) {
        if (examTypes[0].evaluationData.percentage != null) {
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
              _examTypeTextControllers[i][1].text = _examTypes[i]
                          .evaluationData
                          .evaluationMethod ==
                      EvaluationMethod.multiplication
                  ? _examTypes[i].evaluationData.multiplicationFactor.toString()
                  : _examTypes[i].evaluationData.percentage.toString();
            }
          }

          // Remove excess controllers if exam types are reduced
          while (_examTypeTextControllers.length > _examTypes.length) {
            _examTypeTextControllers.removeLast();
          }
        } else if (examTypes[0].evaluationData.multiplicationFactor != null) {
          for (int i = 0; i < _examTypes.length; i++) {
            if (i >= _examTypeTextControllers.length) {
              _examTypeTextControllers.add([
                TextEditingController(text: _examTypes[i].name),
                TextEditingController(
                    text: _examTypes[i]
                        .evaluationData
                        .multiplicationFactor
                        .toString())
              ]);
            } else {
              _examTypeTextControllers[i][0].text = _examTypes[i].name;
              _examTypeTextControllers[i][1].text =
                  _examTypes[i].evaluationData.multiplicationFactor.toString();
            }
          }
        }
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
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedGradientButton(
            onPressed: () async => await _onSave(),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  "Save",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            )),
      )
    ]);
  }

  Future<void> _onSave() async {
    if (_selectedGradingSystem == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text(
                      "Select an evaluation system with at least one exam type!"),
                ),
              ));

      return;
    }

    GradingSystem builtGradingSystem = GradingSystem(
        range: _selectedGradingSystem!.range,
        modifiers: _selectedGradingSystem!.modifiers,
        examTypes: _examTypes);

    try {
      builtGradingSystem.isValid();
    } on ArgumentError catch (e) {
      switch (e.message) {
        case "Range must have exactly two values. (start, end)":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "Please select an grading system from the dropdown"),
                    ),
                  ));
        case "Grading system must have at least one exam type":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text("Create at least one exam type!"),
                    ),
                  ));
        case "All exam types must have the same evaluation method":
          // This should not happen because it's impossible to do this via the UI, but a check is always worth it
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "All exam types must have the same evaluation method!"),
                    ),
                  ));
        case "All percentage exam types must have a percentage":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "Fill in a percentage for each percentage based exam type!"),
                    ),
                  ));

        case "All exam types must have a name":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text("Fill in a name for each exam type!"),
                    ),
                  ));
        case "All multiplication exam types must have a multiplication factor":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "Fill in a multiplication factor for each multiplication based exam type!"),
                    ),
                  ));

        case "There must be only one default multiplication exam type":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "There may only be one base multiplication exam type!"),
                    ),
                  ));

        case "The sum of all multiplication factors must be 100":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "The sum of all multiplication factors must be 100!"),
                    ),
                  ));
        case "Multiplication factor must be greater than zero":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "The multiplication factor for every exam type must be greater than zero!"),
                    ),
                  ));
        case "Multiplication exam types must not form a circle":
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      content: const Text(
                          "Make sure that a chain of multiplication based exam types doesn't result in a circular pattern!"),
                    ),
                  ));
        default:
          logger.e(e);
          rethrow;
      }
      return;
    }
    await setGradingSystem(builtGradingSystem);
  }
}
