import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/MultipleStepPageIndicator.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/marks/Grades.dart';
import 'package:school_mate/pages/home/marks/MarkSelection.dart';
import 'package:school_mate/pages/home/marks/add/subpages/subject.dart';
import 'package:school_mate/pages/home/marks/add/subpages/type.dart';
import 'package:school_mate/pages/home/marks/add/subpages/validation.dart';

import '../../../../Classes/marks/Mark.dart';

class AddMarkPage extends StatefulWidget {
  final GradingSystem gradingSystem;
  final Subject? subject;
  final double? mark;
  final ExamType? examType;
  final bool isInEditMode;
  final String? markModifier;
  final String description;
  final Mark? oldMark;

  const AddMarkPage(
      {super.key,
      required this.gradingSystem,
      this.subject,
      this.mark,
      this.examType,
      this.isInEditMode = false,
      this.markModifier,
      this.description = "",
      this.oldMark});

  @override
  State<AddMarkPage> createState() => _AddMarkPageState();
}

class _AddMarkPageState extends State<AddMarkPage> {
  late Subject? subject;
  late double? mark;
  late ExamType? selectedExamType;
  late int currentPage;
  final TextEditingController descriptionController = TextEditingController();
  String? markModifier;

  @override
  void initState() {
    super.initState();
    subject = widget.subject;
    mark = widget.mark;
    selectedExamType = widget.examType;
    markModifier = widget.markModifier;
    descriptionController.text = widget.description;
    if (subject == null) {
      currentPage = 1;
      return;
    }
    if (mark == null) {
      currentPage = 2;
      return;
    }
    if (selectedExamType == null) {
      currentPage = 3;
      return;
    }
    currentPage = 4;
  }

  void _onBackButtonPressed() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _onSubjectSelection(Subject selectedSubject) {
    setState(() {
      subject = selectedSubject;
      currentPage = 2;
    });
  }

  void _onMarkValueSelection(double selectedMark) {
    setState(() {
      mark = selectedMark;
      currentPage = 3;
    });
  }

  void _onExamTypeSelection(ExamType selectedExamType) {
    setState(() {
      this.selectedExamType = selectedExamType;
      currentPage = 4;
    });
  }

  void _onModifierChange(String? selectedModifier) {
    setState(() {
      markModifier = selectedModifier;
    });
  }

  Future<void> _onConfirm() async {
    var markString = mark.toString();
    if (markModifier != null) {
      markString = "$markString$markModifier";
    }
    await insertMark(markString, subject!, selectedExamType!,
        description: descriptionController.text);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MarksPage(),
    ));
  }

  Future<void> _onUpdate() async {
    var markString = mark.toString();
    if (markModifier != null) {
      markString = "$markString$markModifier";
    }
    await updateMark(
        widget.oldMark!,
        Mark(
          id: widget.oldMark!.id,
          createdAt: widget.oldMark!.createdAt,
          subject: subject!,
          gradingSystem: widget.gradingSystem,
          examType: selectedExamType!,
          numericValue: mark!,
          modifier: markModifier!,
          description: descriptionController.text,
        ));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Updated Mark successfully!"),
                backgroundColor: Colors.green,
              ),
            ));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MarksPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              BackButton(onPressed: _onBackButtonPressed),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MultipleStepPageIndicator(
                    stepCount: 4,
                    currentStep: currentPage,
                    headTitles: ["Subject", "Mark", "Exam Type", "Confirm"],
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    connectionLineThickness: 4,
                    headTitleStyle: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold),
                    icons: const [
                      Icons.calendar_month_outlined,
                      Icons.numbers,
                      Icons.percent_sharp,
                      Icons.check
                    ],
                    indicatorColor: Colors.blueGrey,
                    waveColor: Colors.blueGrey.shade100,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildCurrentPage(),
          ),
        ],
      ),
    );
  }

  Future<void> _onDelete() async {
    await deleteMark(widget.oldMark!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mark deleted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MarksPage(),
    ));
    logger.d("message");
  }

  Widget _buildCurrentPage() {
    if (currentPage == 1) {
      return AddMarkSubjectSelector(onSelection: _onSubjectSelection);
    } else if (currentPage == 2) {
      return MarkSelector(
        gradingSystem: widget.gradingSystem,
        onMarkSelected: _onMarkValueSelection,
        title: "Select Mark",
      );
    } else if (currentPage == 3) {
      return ExamTypeSelector(
        gradingSystem: widget.gradingSystem,
        onSelected: _onExamTypeSelection,
      );
    } else {
      return AddMarkValidationPage(
        descriptionController: descriptionController,
        subject: subject!,
        markValue: mark!,
        examType: selectedExamType!,
        gradingSystem: widget.gradingSystem,
        onModifierChanged: _onModifierChange,
        modifier: markModifier,
        onSave: widget.isInEditMode ? _onUpdate : _onConfirm,
        isEdit: widget.isInEditMode,
        oldMark: widget.oldMark,
        onMarkDeleteRequested: _onDelete,
      );
    }
  }
}
