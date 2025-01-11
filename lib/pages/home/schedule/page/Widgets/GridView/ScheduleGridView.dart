import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Classes/schedule/ScheduleMetadata.dart';
import 'package:school_mate/pages/home/schedule/page/Widgets/LessonBox.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

class ScheduleGridView extends StatefulWidget {
  final Schedule schedule;

  const ScheduleGridView({super.key, required this.schedule});

  @override
  State<ScheduleGridView> createState() => _ScheduleGridViewState();
}

class _ScheduleGridViewState extends State<ScheduleGridView> {
  DateTime currentFocusedScheduleWeek = DateTime.now();
  bool _isSwiping = false;
  final GlobalKey _buildAreaKey = GlobalKey();
  final GlobalKey _tableHeaderRowKey = GlobalKey();
  RenderBox? _tableHeaderRowRenderBox;

  late double _widthPerDay = 1;
  late int _dailyWorkdayLength;
  late List<int> _workdays;
  late List<List<Lesson>> _lessonsByDay = [];
  late int _pixelHeightPerMinute = 1;
  late List<DateTime> _filteredWeekdaysAtWork = [];

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
      _dailyWorkdayLength = _calculateDailyWorkdayLength(schedule);
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

  /// Updates the lessons grouped by day
  void _updateLessonsByDay() {
    final schedule = widget.schedule;
    final allLessonsThisWeek = schedule.lessons.where((lesson) {
      return lesson.temporalData.alternatingWeeks.contains(
        schedule.metadata
            .alternatedWeekForDate(currentFocusedScheduleWeek)
            .toString(),
      );
    }).toList();
    setState(() {
      _lessonsByDay = List.generate(7, (index) {
        return allLessonsThisWeek
            .where((lesson) => lesson.temporalData.weekday == index)
            .toList();
      });
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

  /// Calculates pixel height per minute
  void _calculatePixelHeight() {
    final height = _buildAreaKey.currentContext?.size?.height;
    if (height != null) {
      setState(() {
        _pixelHeightPerMinute = height ~/ _dailyWorkdayLength;
        _tableHeaderRowRenderBox =
            _tableHeaderRowKey.currentContext?.findRenderObject() as RenderBox;
      });
    }
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
            Positioned(
              top: _tableHeaderRowRenderBox == null
                  ? 0
                  : _tableHeaderRowRenderBox!.localToGlobal(Offset.zero).dy +
                      widget.schedule.metadata.visualLessonTimes[1][0]
                              .difference(
                                  widget.schedule.metadata.firstLessonTime)
                              .inMinutes *
                          _pixelHeightPerMinute,
              left: 16, // The default left margin for this screen
              child: LessonBox(
                title: "1",
                color: Colors.grey,
                height: (widget.schedule.metadata.visualLessonTimes[1][1]
                            .difference(widget
                                .schedule.metadata.visualLessonTimes[1][0])
                            .inMinutes *
                        _pixelHeightPerMinute)
                    .toDouble(),
                width: _widthPerDay,
                temporalData: widget.schedule.lessons[0].temporalData,
              ),
            ),
            _buildScheduleTable(),
          ],
        ),
      ),
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
            ..._filteredWeekdaysAtWork
                .map((day) => _buildDayCell(day))
                .toList(),
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
