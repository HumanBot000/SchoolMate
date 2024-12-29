import 'package:app/pages/home/Widgets/BottomNavBar.dart';
import 'package:app/pages/home/schedule/setup/Widgets/AlternatingWeeksSelector.dart';
import 'package:app/pages/home/schedule/setup/Widgets/IndividualLessonDurationSelector.dart';
import 'package:app/pages/home/schedule/setup/Widgets/LessonsTimeFrame.dart';
import 'package:app/pages/home/schedule/setup/Widgets/WorkdaySelector.dart';
import 'package:flutter/material.dart';

class ScheduleSetupPage extends StatefulWidget {
  const ScheduleSetupPage({super.key});

  @override
  State<ScheduleSetupPage> createState() => _ScheduleSetupPageState();
}

class _ScheduleSetupPageState extends State<ScheduleSetupPage> {
  // Don't make these vars public and manipulate in child widgets because of single source of truth -> easier debugging
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final List<bool> _selectedWorkdays = List.generate(7, (index) => index < 5);
  int _activePage = 0;
  int _alternatingWeeksCount = 0;
  int _currentAlternatingWeek = 0;
  int _lessonLength = 45;
  int _customLessonLength =
      90; //Don't use this value. It's for an UI build. Use _lessonLength instead
  void _setLessonsTimeFrame(TimeOfDay? startTime, TimeOfDay? endTime) {
    setState(() {
      _startTime = startTime;
      _endTime = endTime;
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
      _selectedWorkdays[index] = value;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const HomeNavBar(currentIndex: 1),
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
                        "Schedule Setup",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Before you can start using the schedule, we need to know some last details about your day.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Please enter the maximum start and end times. You can change this later for each individual day.",
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
                        workdays: _selectedWorkdays,
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
                    )
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
