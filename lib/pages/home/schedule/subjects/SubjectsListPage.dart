import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectListWidget.dart';

class SubjectList extends StatefulWidget {
  final List<Subject> subjects;
  final Function(Subject) onSubjectSelected;
  final bool popAfterSelection;

  const SubjectList(
      {super.key,
      required this.subjects,
      required this.onSubjectSelected,
      this.popAfterSelection = true});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  late List<Subject> _subjects;

  @override
  void initState() {
    super.initState();
    _subjects = widget.subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n.selectSubjectToAddToSchedule,
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(overflow: TextOverflow.visible, fontSize: 20)),
          leading: const PreviousPage()),
      body: SubjectListWidget(
        subjects: _subjects,
        onSubjectSelected: widget.onSubjectSelected,
        popAfterSelection: widget.popAfterSelection,
      ),
    );
  }
}
