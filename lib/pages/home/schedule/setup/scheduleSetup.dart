import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/MetadataCRUD.dart'
    as metadata;
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/Widgets/specialThemes/futuristic.dart';
import 'package:school_mate/l10n/app_localizations.dart';
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
  final String? headerTitle;
  final Schedule? existingSchedule;

  const ScheduleSetupPage({super.key, this.existingSchedule, this.headerTitle});

  @override
  State<ScheduleSetupPage> createState() => _ScheduleSetupPageState();
}

class _ScheduleSetupPageState extends State<ScheduleSetupPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

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
        _workdays.fillRange(0, 7, false);
        for (int day in widget.existingSchedule!.metadata.workdays) {
          _workdays[day] = true;
        }
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
                  content: Text(l10n.currentWeekTypeRequired),
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
                  content: Text(l10n.fillAllRequiredFields),
                ),
              ));
      return false;
    }
    if (timeOfDaysOverlap(_visualLessonTimes)) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text(l10n.lessonTimesOverlap),
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
        errorMessage = l10n.lastLessonAfterFirst;
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
        builder: (context) => FutureBuilder<dynamic>(
          future: fetch_schedule.fetchSchedule(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data;
              if (data == null) {
                logger.w("Couldn't find a schedule after creating it.");
                return Scaffold(
                  body: Center(child: Text(l10n.noDataAvailable)),
                );
              }
              return SchedulePage(schedule: data);
            } else {
              logger.w("Couldn't find a schedule after creating it.");
              return Scaffold(
                body: Center(child: Text(l10n.noDataAvailable)),
              );
            }
          },
        ),
      ));
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final firstSnackBar = scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.updatedScheduleSuccess),
          backgroundColor: Colors.green,
        ),
      );

      // Wait until the first SnackBar is closed
      await firstSnackBar.closed;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.yellow,
          content: Text(
            l10n.scheduleCorruptionWarning,
          ),
        ),
      );

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          _isEdit ? l10n.editSchedule : l10n.scheduleSetup,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: _isEdit ? null : const HomeNavBar(currentIndex: 1),
      body: Stack(
        children: [
          buildGradientBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.headerTitle ?? l10n.defaultScheduleSetupHeader,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: l10n.enterStartEndTimesPrompt,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              children: const [
                                TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 24),
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
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.selectLessonDaysPrompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      WorkDaysSelector(
                          workdays: _workdays,
                          onWorkdayChange: _updateWorkday,
                          onActivePageChange: _onPageChanged,
                          activePage: _activePage),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.scheduleChangeWeeksPrompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AlternatingWeeksSelector(
                          alternatingWeeksCount: _alternatingWeeksCount,
                          activePage: _activePage,
                          onActivePageChange: _onPageChanged,
                          selectedAlternatingWeek: _currentAlternatingWeek,
                          onWeekChange: _updateAlternatingWeeks),
                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.lessonDurationPrompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        color: Colors.white.withValues(alpha: 0.1),
                        thickness: 1,
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
                                  Text(_isEdit ? l10n.update : l10n.confirm,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                ],
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.requiredFields,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
