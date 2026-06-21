import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/pages/home/schedule/page/Schedule.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectsListPage.dart';

class HomeworkSubjectChooser extends StatelessWidget {
  final Subject? selectedSubject;
  final dynamic schedule;
  final Function(Lesson, DateTime) onLessonSelection;
  final Function(Subject) onSubjectSelection;

  const HomeworkSubjectChooser(
      {super.key,
      this.selectedSubject,
      required this.schedule,
      required this.onLessonSelection,
      required this.onSubjectSelection});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          //todo settings
          if (false) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubjectList(
                  subjects: schedule.subjects,
                  onSubjectSelected: onSubjectSelection),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SchedulePage(
                schedule: schedule,
                onLessonSelection: onLessonSelection,
                crossOutPastLessons: true,
                showBottomNavBar: false,
              ),
            ));
          }
        },
        child: ListTile(
          title: Text(
              selectedSubject == null ? l10n.subject : selectedSubject!.name),
          subtitle: Text(l10n.whichSubjectHomeworkFor),
          leading: selectedSubject == null
              ? const Icon(Icons.book_sharp)
              : selectedSubject!.avatar(context),
        ),
      ),
    );
  }
}
