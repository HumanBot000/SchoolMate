import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/lessons.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/homework/add/AddHomework.dart';
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
            callbackForLessonsInPast: false,
            onLessonSelection: onLessonSelection == _defaultOnLessonSelection
                ? (lesson, time) {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1a1a2e).withOpacity(0.95),
                                const Color(0xFF16213e).withOpacity(0.95),
                                const Color(0xFF0f3460).withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF00d4ff).withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00d4ff).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header with glow effect
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              const Color(0xFF00d4ff)
                                                  .withOpacity(0.3),
                                              const Color(0xFF00d4ff)
                                                  .withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.assignment_add,
                                          color: Color(0xFF00d4ff),
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Add Assignment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 2,
                                        width: 60,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Color(0xFF00d4ff),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Main option button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => AddHomeworkPage(
                                        schedule: schedule,
                                        initialDate: time,
                                        initialSubject: lesson.subject,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF00d4ff)
                                              .withOpacity(0.2),
                                          const Color(0xFF0099cc)
                                              .withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: const Color(0xFF00d4ff)
                                            .withOpacity(0.4),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00d4ff)
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00d4ff)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.schedule,
                                            color: Color(0xFF00d4ff),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Add Homework due this lesson',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Create assignment for this lesson',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  fontSize: 12,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: const Color(0xFF00d4ff)
                                              .withOpacity(0.7),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Cancel button
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                : onLessonSelection,
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
