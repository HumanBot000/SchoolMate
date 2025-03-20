import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/MultipleStepPageIndicator.dart';
import 'package:school_mate/pages/home/marks/MarkSelection.dart';
import 'package:school_mate/pages/home/marks/add/subpages/gradingSytemSelector.dart';
import 'package:school_mate/pages/home/marks/add/subpages/subject.dart';

class AddMarkPage extends StatefulWidget {
  final GradingSystem gradingSystem;
  final Subject? subject;
  final double? mark;

  const AddMarkPage(
      {super.key, required this.gradingSystem, this.subject, this.mark});

  @override
  State<AddMarkPage> createState() => _AddMarkPageState();
}

class _AddMarkPageState extends State<AddMarkPage> {
  late Subject? subject;
  late double? mark;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    subject = widget.subject;
    mark = widget.mark;
    if (subject == null) {
      currentPage = 1;
      return;
    }
    if (mark == null) {
      currentPage = 2;
      return;
    }
    currentPage = 3;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              BackButton(onPressed: _onBackButtonPressed),
              Padding(
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
            ],
          ),
          if (currentPage == 1)
            AddMarkSubjectSelector(onSelection: _onSubjectSelection),
          if (currentPage == 2)
            MarkSelector(
              gradingSystem: widget.gradingSystem,
              onMarkSelected: _onMarkValueSelection,
              title: "Select Mark",
            ),
          if (currentPage == 3)
            GradingSystemSelector(
              gradingSystem: widget.gradingSystem,
            )
        ],
      ),
    );
  }
}
