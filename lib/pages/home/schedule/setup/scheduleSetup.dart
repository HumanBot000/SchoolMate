import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/MetadataCRUD.dart'
    as metadata;
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/schedule/page/Schedule.dart';
import 'package:school_mate/pages/home/schedule/setup/Widgets/AlternatingWeeksSelector.dart';
import 'package:school_mate/pages/home/schedule/setup/Widgets/IndividualLessonDurationSelector.dart';
import 'package:school_mate/pages/home/schedule/setup/Widgets/LessonsTimeFrame.dart';
import 'package:school_mate/pages/home/schedule/setup/Widgets/WorkdaySelector.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ScheduleSetupPage extends StatefulWidget {
  final String headerTitle;
  final Schedule? existingSchedule;

  const ScheduleSetupPage(
      {super.key,
      this.existingSchedule,
      this.headerTitle =
          "Before you can start using the schedule, we need to know some last details about your day."});

  @override
  State<ScheduleSetupPage> createState() => _ScheduleSetupPageState();
}

class _ScheduleSetupPageState extends State<ScheduleSetupPage> {
  // Don't make these vars public and manipulate in child widgets because of single source of truth -> easier debugging
  int _activePage = 0;
  TimeOfDay _startTime = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _endTime;
  final List<bool> _workdays = List.generate(7, (index) => index < 5);
  int _alternatingWeeksCount = 0;
  int _currentAlternatingWeek = 0;
  int _lessonLength = 45;
  int _customLessonLength =
      90; //Don't use this value. It's for an UI build. Use _lessonLength instead
  late List<List<TimeOfDay>> _visualLessonTimes;
  late final bool _isEdit = widget.existingSchedule != null;
  late var lessons = widget.existingSchedule?.lessons;

  @override
  void initState() {
    if (_isEdit) {
      setState(() {
        lessons!.sort((lesson1, lesson2) => lesson1.temporalData.startTime
            .compareTo(lesson2.temporalData.startTime));
        _startTime = lessons!.first.temporalData.startTime;
        _endTime = lessons!.last.temporalData.endTime;
        _workdays[widget.existingSchedule!.metadata.workdays[0]] = true;
        _alternatingWeeksCount =
            widget.existingSchedule!.metadata.numberOfAlternateWeeks - 1;
        _currentAlternatingWeek = ["A", "B", "C", "D", "E", "F", "G"]
            .indexOf(widget.existingSchedule!.metadata.currentAlternatedWeek);
        _lessonLength = widget.existingSchedule!.metadata.defaultLessonLength;
        _visualLessonTimes =
            widget.existingSchedule!.metadata.visualLessonTimes;
        _customLessonLength = _lessonLength;
      });
    } else {
      _visualLessonTimes = [
        [
          TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
          TimeOfDay(
              hour: _startTime
                  .toDateTime()
                  .add(Duration(minutes: _lessonLength))
                  .hour,
              minute: _startTime
                  .toDateTime()
                  .add(Duration(minutes: _lessonLength))
                  .minute)
        ]
      ];
    }
    super.initState();
  }

  void _setLessonsTimeFrame(TimeOfDay startTime, TimeOfDay? endTime) {
    setState(() {
      _startTime = startTime;
      _endTime = endTime;
    });
  }

  void _updateLessonTimes(List<List<TimeOfDay>> times) {
    setState(() {
      _visualLessonTimes = times;
    });
  }

  void _onPageChanged(int index) {
    if (_activePage == index) return;
    setState(() {
      _activePage = index;
    });
  }

  void _updateWorkday(int index, bool value) {
    setState(() {
      _workdays[index] = value;
    });
  }

  void _updateAlternatingWeeks(int numberOfWeeks, int currentWeek) {
    if (currentWeek > numberOfWeeks) {
      // This case should be made impossible via the ui, this is just a fallback
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                      "The current week type must be included in the number of weeks"),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ));
      setState(() {
        _alternatingWeeksCount = numberOfWeeks;
        _currentAlternatingWeek = 0;
      });
      return;
    }
    setState(() {
      _alternatingWeeksCount = numberOfWeeks;
      _currentAlternatingWeek = currentWeek;
    });
  }

  void _updateLessonLength(int value) {
    setState(() {
      _lessonLength = value;
    });
  }

  void _updateCustomLessonLength(int value) {
    setState(() {
      _customLessonLength = value;
    });
  }

  bool _validateSettings() {
    if (_endTime == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text("Please fill in all required fields"),
                ),
              ));
      return false;
    }
    if (timeOfDaysOverlap(_visualLessonTimes)) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text(
                      "The provided lesson times may not overlap each other"),
                ),
              ));
      return false;
    }
    return true;
  }

  Future<void> _onSave() async {
    if (!_validateSettings()) return;
    try {
      await metadata.insertScheduleMetadata(
          _startTime,
          _endTime!,
          _workdays,
          _alternatingWeeksCount,
          _currentAlternatingWeek,
          _lessonLength,
          _visualLessonTimes,
          idEdit: _isEdit);
    } catch (e) {
      String errorMessage;

      if (e is PostgrestException &&
          e.message == "last_lesson must be after first_lesson") {
        errorMessage =
            "Your last lesson must end after your first lesson starts.";
      } else {
        errorMessage = e.toString();
      }

      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(errorMessage),
                ),
              ));
      return;
    }
    if (!_isEdit) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: fetch_schedule.fetchSchedule(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return SchedulePage(schedule: snapshot.data!);
            } else {
              logger.w("Couldn't find a schedule after creating it.");
              return const Text('No data available.');
            }
          },
        ),
      ));
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final firstSnackBar = scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Updated Schedule Successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Wait until the first SnackBar is closed
      await firstSnackBar.closed;

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          backgroundColor: Colors.yellow,
          content: Text(
            "Please note, that this might corrupt your current schedule. We highly encourage you to clear all lessons.",
          ),
        ),
      );

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _isEdit ? null : const HomeNavBar(currentIndex: 1),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        _isEdit ? "Edit Schedule" : "Schedule Setup",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.headerTitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      children: [
                        RichText(
                          text: const TextSpan(
                            // Ensures that the * is always at the end of the last line of the text and not in a separate line
                            text:
                                "Please enter the maximum start and end times.\n You can change this later for each individual day. ",
                            children: [
                              TextSpan(
                                text: "*",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 32),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    LessonsTimeFrameSelector(
                        startTime: _startTime,
                        endTime: _endTime,
                        onTimeChanged: _setLessonsTimeFrame),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Please select the days you have lessons.",
                    ),
                    WorkDaysSelector(
                        workdays: _workdays,
                        onWorkdayChange: _updateWorkday,
                        onActivePageChange: _onPageChanged,
                        activePage: _activePage),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Does your schedule change every x weeks?",
                    ),
                    AlternatingWeeksSelector(
                        alternatingWeeksCount: _alternatingWeeksCount,
                        activePage: _activePage,
                        onActivePageChange: _onPageChanged,
                        selectedAlternatingWeek: _currentAlternatingWeek,
                        onWeekChange: _updateAlternatingWeeks),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "How long are your lessons?",
                    ),
                    IndividualLessonDurationSelector(
                      activePage: _activePage,
                      onActivePageChange: _onPageChanged,
                      lessonDuration: _lessonLength,
                      onLessonDurationChange: _updateLessonLength,
                      onCustomLessonDurationChange: _updateCustomLessonLength,
                      selectedCustomLessonDuration: _customLessonLength,
                      starOfDay: _startTime,
                      visualLessonTimes: _visualLessonTimes,
                      onVisualLessonTimesChange: _updateLessonTimes,
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedGradientButton(
                            borderRadius: BorderRadius.circular(12),
                            onPressed: () async {
                              await _onSave();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_isEdit ? "Update" : "Confirm",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                              ],
                            ))),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "* Required fields",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
