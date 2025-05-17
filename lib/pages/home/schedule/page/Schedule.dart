import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/lessons.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/schedule/lessons/ConfigureLesson.dart';
import 'package:school_mate/pages/home/schedule/page/Widgets/ScheduleGridView.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';
import 'package:school_mate/pages/home/schedule/subjects/SubjectsListPage.dart';

class SchedulePage extends StatelessWidget {
  final Schedule schedule;
  final bool showBreaks;
  final Function(TimeOfDay, TimeOfDay, int) onBreakSelection;
  final bool showLessonTapCallback;
  final Function(Lesson, DateTime) onLessonSelection;
  final bool crossOutPastLessons;
  final List<Homework> homeworks;
  final bool showBottomNavBar;

  const SchedulePage(
      {super.key,
      required this.schedule,
      this.showBreaks = false,
      this.onBreakSelection = _defaultBreakSelection,
      this.showLessonTapCallback = true,
      this.onLessonSelection = _defaultOnLessonSelection,
      this.crossOutPastLessons = false,
      this.homeworks = const [],
      this.showBottomNavBar = true});

  // Just a static func that does nothing to pass as default for constructor
  static void _defaultBreakSelection(
      TimeOfDay start, TimeOfDay end, int weekdays) {}

  static void _defaultOnLessonSelection(Lesson lesson, DateTime date) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Expanded(
              child: Text(
                "Schedule",
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
                tooltip: "Back to Present",
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SchedulePage(
                        schedule: schedule,
                        showLessonTapCallback: showLessonTapCallback,
                        onBreakSelection: onBreakSelection,
                        showBreaks: showBreaks),
                  ));
                },
                icon: const Icon(
                  Icons.access_time_filled,
                ),
                iconSize: 30,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.inversePrimary),
                  iconColor: WidgetStateProperty.all(Colors.white),
                )),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNavBar
          ? const HomeNavBar(
              currentIndex: 1,
            )
          : null,
      body: Stack(
        children: [
          ScheduleGridView(
            schedule: schedule,
            onBreakSelection: onBreakSelection,
            showBreaks: showBreaks,
            showLessonTapCallback: showLessonTapCallback,
            onLessonSelection: onLessonSelection,
            crossOutLessonsInPast: crossOutPastLessons,
            homeworks: homeworks,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: IconButton(
                  tooltip: "Add Lesson",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubjectList(
                        subjects: schedule.subjects,
                        onSubjectSelected: (selectedSubject) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LessonConfigurationPage(
                                        subject: selectedSubject,
                                        schedule: schedule,
                                        onUpdate: (subject,
                                            startTime,
                                            endTime,
                                            weekday,
                                            alternatingWeeks,
                                            room) async {
                                          await addLesson(
                                              subject,
                                              startTime,
                                              endTime,
                                              weekday,
                                              alternatingWeeks,
                                              room);
                                          // Update the UI
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) => FutureBuilder(
                                              future: fetch_schedule
                                                  .fetchSchedule(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  logger.e(snapshot.error);
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else if (snapshot.hasData) {
                                                  if (snapshot.data is String &&
                                                      snapshot.data!.isEmpty) {
                                                    return const ScheduleSetupPage();
                                                  }
                                                  return SchedulePage(
                                                      schedule: snapshot.data!);
                                                } else {
                                                  return const Text(
                                                      'No data available.');
                                                }
                                              },
                                            ),
                                          ));
                                        },
                                      )));
                        },
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  iconSize: 30,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
