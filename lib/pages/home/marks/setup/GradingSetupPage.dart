import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/gradingSystem.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/marks/Grades.dart';
import 'package:school_mate/pages/home/marks/setup/ExamTypeSetup.dart';
import 'package:school_mate/pages/home/marks/setup/GradingSystemDropdown.dart';

class GradingSetupPage extends StatefulWidget {
  final GradingSystem? selectedGradingSystem;

  const GradingSetupPage({super.key, this.selectedGradingSystem});

  @override
  State<GradingSetupPage> createState() => _GradingSetupPageState();
}

class _GradingSetupPageState extends State<GradingSetupPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  GradingSystem? _selectedGradingSystem;
  EvaluationMethod? _selectedEvaluationMethod;
  List<List<TextEditingController>> _examTypeTextControllers = [];
  List<ExamType> _examTypes = [];

  @override
  void initState() {
    super.initState();
    _initializeGradingSystem();
  }

  void _initializeGradingSystem() {
    _selectedGradingSystem = widget.selectedGradingSystem ??
        GradingSystem(
            range: ["1", "6"], modifiers: ["+"], examTypes: [ExamType.basic()]);
    _selectedEvaluationMethod =
        _selectedGradingSystem!.examTypes.first.evaluationData.evaluationMethod;
    _examTypes = _selectedGradingSystem!.examTypes;
    _updateExamTypeControllers();
  }

  @override
  void dispose() {
    for (var controllers in _examTypeTextControllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _onEvaluationMethodChange(EvaluationMethod? method) async {
    List<ExamType> newExamTypes = (method == EvaluationMethod.percentage)
        ? [ExamType.basic()]
        : [ExamType.basicAsMultiplicationSystem()];
    setState(() {
      _selectedEvaluationMethod = method;
      _examTypes = newExamTypes;
    });
    _updateExamTypeControllers();
  }

  void _updateExamTypeControllers() {
    _examTypeTextControllers = _examTypes
        .map((examType) => [
              TextEditingController(text: examType.name),
              TextEditingController(
                  text: examType.evaluationData.evaluationMethod ==
                          EvaluationMethod.multiplication
                      ? examType.evaluationData.multiplicationFactor.toString()
                      : examType.evaluationData.percentage.toString())
            ])
        .toList();
  }

  Future<void> _onSave() async {
    if (_selectedGradingSystem == null) {
      _showErrorSnackbar(
          "Select an evaluation system with at least one exam type!");
      return;
    }

    GradingSystem builtGradingSystem = GradingSystem(
        range: _selectedGradingSystem!.range,
        modifiers: _selectedGradingSystem!.modifiers,
        examTypes: _examTypes,
        id: -1);

    try {
      builtGradingSystem.isValid();
    } on ArgumentError catch (e) {
      _handleValidationError(e.message);
      return;
    }

    try {
      await setGradingSystem(builtGradingSystem);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MarksPage()));
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  void _handleValidationError(String errorMessage) {
    final errors = {
      "Range must have exactly two values. (start, end)":
          "Please select a grading system from the dropdown.",
      "Grading system must have at least one exam type":
          "Create at least one exam type!",
      "All exam types must have the same evaluation method":
          "All exam types must have the same evaluation method!",
      "All exam types must have a name": "Fill in a name for each exam type!",
      "All percentage exam types must have a percentage":
          "Fill in a percentage for each percentage-based exam type!",
      "All multiplication exam types must have a multiplication factor":
          "Fill in a multiplication factor for each multiplication-based exam type!",
      "There must be only one default multiplication exam type":
          "There may only be one base multiplication exam type!",
      "The sum of all percentages must be 100":
          "The sum of all percentages must be 100",
      "Multiplication factor must be greater than zero":
          "The multiplication factor must be greater than zero!",
      "Multiplication exam types must not form a circle":
          "Avoid circular dependency in multiplication-based exam types!",
      "Exam type names must be unique":
          "Each exam type must have a unique name!"
    };
    logger.w(errorMessage);
    _showErrorSnackbar(errors[errorMessage] ?? "An unknown error occurred.");
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildHeader(),
        const Divider(thickness: 1.5),
        GradingSystemDropdown(
          selectedGradingSystem: _selectedGradingSystem,
          onChanged: (value) => setState(() => _selectedGradingSystem = value),
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
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold),
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
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold),
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
        const Divider(thickness: 1.5),
        ExamTypeSetupPage(
          onChanged: _onEvaluationMethodChange,
          selectedEvaluationMethod: _selectedEvaluationMethod,
          evaluationMethodNameTextControllers: _examTypeTextControllers,
          examTypes: _examTypes,
          onExamTypeChanges: (examTypes) {
            setState(() => _examTypes = examTypes);
            _updateExamTypeControllers();
          },
        ),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(l10n.gradingSetupTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(l10n.gradingSetupSubtitle,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedGradientButton(
        onPressed: _onSave,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.save,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
