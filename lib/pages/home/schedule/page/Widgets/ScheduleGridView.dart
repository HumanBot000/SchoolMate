// This file ended up a bit long, but splitting it up is hard, because of cross references, private vars and setState()
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/API/supabase/schedule/lessons.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Classes/schedule/ScheduleMetadata.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/schedule/lessons/ConfigureLesson.dart';
import 'package:school_mate/pages/home/schedule/page/Schedule.dart';
import 'package:school_mate/pages/home/schedule/page/Widgets/LessonBox.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

class ScheduleGridView extends StatefulWidget {
  // Don't Navigate to this page! Navigate to SchedulePage instead
  final Schedule schedule;
  final bool showBreaks;
  final Function(TimeOfDay, TimeOfDay, int) onBreakSelection;
  final bool showLessonTapCallback;
  final Function(Lesson, DateTime) onLessonSelection;
  final bool crossOutLessonsInPast;
  final List<Homework> homeworks;
  final bool callbackForLessonsInPast;
  final bool navBarVisible;

  const ScheduleGridView(
      {super.key,
      required this.schedule,
      this.showBreaks = false,
      required this.onBreakSelection,
      required this.showLessonTapCallback,
      required this.onLessonSelection,
      required this.crossOutLessonsInPast,
      this.homeworks = const [],
      this.navBarVisible = true,
      this.callbackForLessonsInPast = false});

  @override
  State<ScheduleGridView> createState() => _ScheduleGridViewState();
}

class _ScheduleGridViewState extends State<ScheduleGridView> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  DateTime currentFocusedScheduleWeek = DateTime.now();
  bool _isSwiping = false;
  final GlobalKey _buildAreaKey = GlobalKey();
  final GlobalKey _tableHeaderRowKey = GlobalKey();
  RenderBox? _tableHeaderRowRenderBox;

  late double _widthPerDay = 1;
  late int _dailyWorkdayMinutes;
  late List<int> _workdays;
  late List<List<Lesson>> _lessonsByDay = [];
  late double _pixelHeightPerMinute = 1; // precision needed
  late List<DateTime> _filteredWeekdaysAtWork = [];
  late List<List<List<TimeOfDay>>> _breaksByDay = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeSchedule());

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _calculatePixelHeight());
  }

  /// Initializes schedule-related values
  void _initializeSchedule() {
    final schedule = widget.schedule.metadata;
    setState(() {
      _workdays = schedule.workdays;
      _dailyWorkdayMinutes = _calculateDailyWorkdayLength(schedule);
      _filteredWeekdaysAtWork = _calculateFilteredWeekdays();
      _widthPerDay = (MediaQuery.of(context).size.width - 7 * 16) /
          7; // The default left margin for this screen is 16
    });
    _updateLessonsByDay();
  }

  /// Calculates the daily workday length in minutes
  int _calculateDailyWorkdayLength(ScheduleMetadata schedule) {
    final start = schedule.firstLessonTime;
    final end = schedule.lastLessonTime;
    return (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
  }

  /// Calculates breaks
  List<List<List<TimeOfDay>>> _constructBreaks(
      List<List<Lesson>> lessonsByDay) {
    //AI generated
    final defaultLessonLength = widget.schedule.metadata.defaultLessonLength;
    // Initialize breaksByDay with empty lists
    final breaksByDay = List.generate(7, (index) => <List<TimeOfDay>>[]);

    // Calculate breaks for each workday
    for (var day = 0; day < 7; day++) {
      if (!_workdays.contains(day)) {
        lessonsByDay[day] = [];
        continue;
      }

      final lessonsForDay = lessonsByDay[day];
      final breaksForDay = <List<TimeOfDay>>[];

      // Function to split a break into chunks of defaultLessonLength
      void addBreaksInChunks(TimeOfDay start, TimeOfDay end) {
        int startInMinutes = start.hour * 60 + start.minute;
        int endInMinutes = end.hour * 60 + end.minute;

        while (endInMinutes - startInMinutes > defaultLessonLength) {
          final chunkEndInMinutes = startInMinutes + defaultLessonLength;
          breaksForDay.add([
            TimeOfDay(hour: startInMinutes ~/ 60, minute: startInMinutes % 60),
            TimeOfDay(
                hour: chunkEndInMinutes ~/ 60, minute: chunkEndInMinutes % 60),
          ]);
          startInMinutes = chunkEndInMinutes;
        }

        breaksForDay.add([
          TimeOfDay(hour: startInMinutes ~/ 60, minute: startInMinutes % 60),
          TimeOfDay(hour: endInMinutes ~/ 60, minute: endInMinutes % 60),
        ]);
      }

      // If there are no lessons, the whole workday is a break
      if (lessonsForDay.isEmpty) {
        addBreaksInChunks(
          widget.schedule.metadata.firstLessonTime,
          widget.schedule.metadata.lastLessonTime,
        );
      } else {
        // Add a break from the start of the workday to the first lesson
        if (lessonsForDay.first.temporalData.startTime !=
            widget.schedule.metadata.firstLessonTime) {
          addBreaksInChunks(
            widget.schedule.metadata.firstLessonTime,
            lessonsForDay.first.temporalData.startTime,
          );
        }

        // Add breaks between consecutive lessons
        for (var i = 0; i < lessonsForDay.length - 1; i++) {
          final currentLesson = lessonsForDay[i];
          final nextLesson = lessonsForDay[i + 1];

          if (currentLesson.temporalData.endTime !=
              nextLesson.temporalData.startTime) {
            addBreaksInChunks(
              currentLesson.temporalData.endTime,
              nextLesson.temporalData.startTime,
            );
          }
        }

        // Add a break from the last lesson to the end of the workday
        if (lessonsForDay.last.temporalData.endTime !=
            widget.schedule.metadata.lastLessonTime) {
          addBreaksInChunks(
            lessonsForDay.last.temporalData.endTime,
            widget.schedule.metadata.lastLessonTime,
          );
        }
      }

      breaksByDay[day] = breaksForDay;
    }
    return breaksByDay;
  }

  /// Updates the lessons grouped by day
  void _updateLessonsByDay() {
    // Filter lessons for the current focused week
    final allLessonsThisWeek = widget.schedule.lessons.where((lesson) {
      return lesson.temporalData.alternatingWeeks.contains(
        widget.schedule.metadata
            .alternatedWeekForDate(currentFocusedScheduleWeek)
            .toString(),
      );
    }).toList();

    // Group lessons by day of the week
    final lessonsByDay = List.generate(7, (index) {
      return allLessonsThisWeek
          .where((lesson) => lesson.temporalData.weekday - 1 == index)
          .toList()
        ..sort((a, b) => a.temporalData.startTime
            .compareTo(b.temporalData.startTime)); // Sort lessons by start time
    });

    setState(() {
      _lessonsByDay = lessonsByDay;
      _breaksByDay = _constructBreaks(lessonsByDay);
    });
  }

  /// Calculates the filtered weekdays that are workdays
  List<DateTime> _calculateFilteredWeekdays() {
    return List.generate(7, (index) {
      return getStartOfWeek(currentFocusedScheduleWeek)
          .add(Duration(days: index));
    }).where((date) {
      return _workdays.contains(date.weekday - 1);
    }).toList();
  }

  /// Calculates pixel height per minute (
  void _calculatePixelHeight() {
    // It took me 5+ Hours to figure out that the BottomNavBar is laid over the Scaffold via a stack and I need to subtract its height
    int? height = _buildAreaKey.currentContext?.size?.height.toInt();
    if (height != null &&
        bottomNavBarKey.currentContext?.size?.height != null) {
      height -= bottomNavBarKey.currentContext!.size!.height.floor();
    }
    if (height != null) {
      height -= 16; // Bottom margin
    }

    // idk... just works
    if (!widget.navBarVisible && height != null) {
      height -= (MediaQuery.of(context).size.height * 0.05).toInt();
    }
    if (height != null) {
      setState(() {
        _pixelHeightPerMinute = height! / _dailyWorkdayMinutes.toDouble();
        _tableHeaderRowRenderBox =
            _tableHeaderRowKey.currentContext?.findRenderObject() as RenderBox;
      });
    }
    logger.d(height);
  }

  /// Handles swiping to change the week
  void _handleSwipe(double deltaX) {
    setState(() {
      if (deltaX > 0) {
        currentFocusedScheduleWeek =
            currentFocusedScheduleWeek.subtract(const Duration(days: 7));
      } else {
        currentFocusedScheduleWeek =
            currentFocusedScheduleWeek.add(const Duration(days: 7));
      }
      _updateLessonsByDay();
      _filteredWeekdaysAtWork = _calculateFilteredWeekdays();
    });
  }

  List<Widget> _buildTimeIndicators() {
    return List.generate(widget.schedule.metadata.visualLessonTimes.length,
        (index) {
      double topPosition = _tableHeaderRowRenderBox == null ||
              !_tableHeaderRowRenderBox!.attached
          ? 0
          : (_tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
              widget.schedule.metadata.visualLessonTimes[index][0]
                      .difference(widget.schedule.metadata.firstLessonTime)
                      .inMinutes *
                  _pixelHeightPerMinute);

      double visualHeight = (widget
              .schedule.metadata.visualLessonTimes[index][1]
              .difference(widget.schedule.metadata.visualLessonTimes[index][0])
              .inMinutes *
          _pixelHeightPerMinute);

      return Positioned(
        top: topPosition - 30,
        left: 16, // Default margin
        child: LessonBox(
          title: (index + 1).toString(),
          color: Colors.grey,
          height: visualHeight,
          width: _widthPerDay,
          startTime: widget.schedule.metadata.visualLessonTimes[index][0],
          endTime: widget.schedule.metadata.visualLessonTimes[index][1],
        ),
      );
    });
  }

  List<Widget> _buildBreakBoxes() {
    if (_breaksByDay.isEmpty) return [];
    List<Widget> breakBoxes = [];
    for (var day = 0; day < 7; day++) {
      bool isEven = true;
      for (var lessonBreak in _breaksByDay[day]) {
        breakBoxes.add(
          Positioned(
              top: _tableHeaderRowRenderBox == null
                  ? 0
                  : (_tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
                          (lessonBreak[0]
                                  .difference(
                                      widget.schedule.metadata.firstLessonTime)
                                  .inMinutes *
                              _pixelHeightPerMinute)) +
                      8,
              left: ((32 + _widthPerDay) * (day + 1)) -
                  (day == widget.schedule.metadata.workdays.last ? 16 : 0),
              child: InkWell(
                onTap: () => widget.showBreaks
                    ? widget.onBreakSelection(
                        lessonBreak[0], lessonBreak[1], day)
                    : null,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: isEven ? Colors.blueAccent : Colors.greenAccent,
                  dashPattern: const [10, 10],
                  child: Container(
                    color: Colors.blueGrey.shade900,
                    width: _widthPerDay,
                    height:
                        (lessonBreak[1].difference(lessonBreak[0]).inMinutes *
                                _pixelHeightPerMinute) -
                            16.toDouble(),
                    child:
                        lessonBreak[1].difference(lessonBreak[0]).inMinutes > 30
                            ? const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Icon(
                                  Icons.coffee,
                                  color: Colors.blueGrey,
                                ),
                              )
                            : const SizedBox.shrink(),
                  ),
                ),
              )),
        );
        isEven = !isEven;
      }
    }
    return breakBoxes;
  }

  void _editDeleteLessonDialog(Offset offset, Lesson lesson) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  lesson.subject.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LessonConfigurationPage(
                        schedule: widget.schedule,
                        subject: lesson.subject,
                        existingLesson: lesson,
                        selectedRoomNumber: lesson.location,
                        onUpdate: (subject, startTime, endTime, weekday,
                            alternatingWeeks, roomNumber) async {
                          await editLesson(
                            lesson,
                            subject,
                            startTime,
                            endTime,
                            weekday,
                            alternatingWeeks,
                            roomNumber,
                          );
                          _refreshSchedule(context);
                        },
                      ),
                    ));
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(l10n.edit),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await deleteLesson(lesson);
                    _refreshSchedule(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: Text(l10n.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshSchedule(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FutureBuilder<dynamic>(
          future: fetch_schedule.fetchSchedule(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Scaffold(
                body: Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data;
              if (data == null) {
                return const ScheduleSetupPage();
              }
              return SchedulePage(schedule: data);
            } else {
              return Scaffold(
                body: Center(
                  child: Text(l10n.noDataAvailable),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildLessonBoxes() {
    if (_lessonsByDay.isEmpty) return [];

    final startOfWeek = currentFocusedScheduleWeek.startOfWeek();

    return [
      for (var dayIndex = 0;
          dayIndex < widget.schedule.metadata.workdays.length;
          dayIndex++)
        ..._lessonsByDay[widget.schedule.metadata.workdays[dayIndex]]
            .map((lesson) {
          final lessonDate = startOfWeek
              .add(Duration(days: widget.schedule.metadata.workdays[dayIndex]));

          final startTimeOffset = lesson.temporalData.startTime
                  .difference(widget.schedule.metadata.firstLessonTime)
                  .inMinutes *
              _pixelHeightPerMinute;

          final matchingHomeworks = widget.homeworks.where((homework) {
            final dueDate = homework.dueDate;
            return dueDate != null &&
                homework.subject.id == lesson.subject.id &&
                dueDate.year == lessonDate.year &&
                dueDate.month == lessonDate.month &&
                dueDate.day == lessonDate.day;
          }).toList();

          final specialIndicatorColor = matchingHomeworks.isEmpty
              ? null
              : (matchingHomeworks.first.isCompleted
                  ? Colors.grey
                  : Colors.red);

          final subContent = matchingHomeworks.isEmpty
              ? null
              : Container(
                  color: lesson.color.withValues(alpha: 0.15),
                  width: _widthPerDay,
                  child: Text(
                    matchingHomeworks.first.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );

          final isCrossedOut = widget.crossOutLessonsInPast &&
              lessonDate.isBefore(DateTime.now());

          return Positioned(
            top: _tableHeaderRowRenderBox == null
                ? 0
                : _tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
                    startTimeOffset -
                    30,
            left: ((32 + _widthPerDay) * (dayIndex + 1)) -
                (dayIndex ==
                        widget.schedule.metadata.workdays[
                            widget.schedule.metadata.workdays.length - 1]
                    ? 24
                    : 4 * dayIndex),
            child: GestureDetector(
              onTap: () {
                if (!lessonDate.isBefore(DateTime.now()) ||
                    (widget.callbackForLessonsInPast &&
                        lessonDate.isBefore(DateTime.now()))) {
                  if (!widget.crossOutLessonsInPast || !isCrossedOut) {
                    widget.onLessonSelection(lesson, lessonDate);
                  }
                }
              },
              onLongPressStart: (details) {
                if (widget.showLessonTapCallback) {
                  _editDeleteLessonDialog(details.globalPosition, lesson);
                }
              },
              child: LessonBox(
                specialIndicatorColor: specialIndicatorColor,
                subContent: subContent,
                location: lesson.location,
                teacherName: lesson.teacher.name,
                title: lesson.name,
                color: lesson.color,
                height: (lesson.temporalData.endTime
                            .difference(lesson.temporalData.startTime)
                            .inMinutes *
                        _pixelHeightPerMinute)
                    .toDouble(),
                width: _widthPerDay + 16,
                crossedOut: isCrossedOut,
              ),
            ),
          );
        }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      key: _buildAreaKey,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (_isSwiping) return;
          _isSwiping = true;
          _handleSwipe(details.delta.dx);
        },
        onPanEnd: (_) {
          _isSwiping = false;
        },
        child: Stack(
          children: [
            if (widget.showBreaks) ..._buildBreakBoxes(),
            ..._buildTimeIndicators(),
            if (_lessonsByDay.isNotEmpty) ..._buildLessonBoxes(),
            _buildScheduleTable(),
            _buildCurrentTimeIndicator()
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTimeIndicator() {
    DateTime now = DateTime.now();
    if (!widget.schedule.metadata.workdays.contains(now.weekday - 1)) {
      return const SizedBox.shrink();
    }
    if (!now.toTimeOfDay().isBetween(widget.schedule.metadata.firstLessonTime,
        widget.schedule.metadata.lastLessonTime)) {
      return const SizedBox.shrink();
    }
    final startTimeOffset = now
            .toTimeOfDay()
            .difference(widget.schedule.metadata.firstLessonTime)
            .inMinutes *
        _pixelHeightPerMinute;

    return Stack(
      children: [
        Positioned(
          top: _tableHeaderRowRenderBox == null
              ? 0
              : _tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
                  startTimeOffset -
                  30,
          child: Container(
            height: 1, //stroke
            width: MediaQuery.of(context).size.width,
            color: Colors.red.withValues(alpha: 0.8),
          ),
        ),
        Positioned(
          top: _tableHeaderRowRenderBox == null
              ? 0
              : _tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
                  startTimeOffset -
                  20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: Colors.black.withValues(alpha: 0.2),
            child: Text(
              DateFormat("HH:mm").format(now.toLocal()),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the schedule table
  Widget _buildScheduleTable() {
    return Table(
      key: _tableHeaderRowKey,
      border: TableBorder(
        horizontalInside: BorderSide(
            style: BorderStyle.solid, color: Colors.grey.shade400, width: 1.0),
        verticalInside: BorderSide(
            style: BorderStyle.solid, color: Colors.grey.shade400, width: 1.0),
      ),
      children: [
        TableRow(
          children: [
            _buildHeaderCell(),
            ..._filteredWeekdaysAtWork.map((day) => _buildDayCell(day)),
          ],
        ),
      ],
    );
  }

  /// Builds the header cell
  Widget _buildHeaderCell() {
    return TableCell(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.schedule.metadata
                  .alternatedWeekForDate(currentFocusedScheduleWeek)
                  .toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "CW ${getIsoWeekNumber(currentFocusedScheduleWeek)}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day) {
    final index = _filteredWeekdaysAtWork.indexOf(day);
    final isMonthChanged =
        index > 0 && day.month != _filteredWeekdaysAtWork[index - 1].month;
    return TableCell(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: day == currentFocusedScheduleWeek
                  ? Colors.green
                  : Colors.blueGrey,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                weekdaysAbbreviations[day.weekday - 1],
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          if (index == 0 || isMonthChanged)
            Text(DateFormat("d. MMM").format(day))
          else
            Text(DateFormat("d").format(day)),
        ],
      ),
    );
  }
}
