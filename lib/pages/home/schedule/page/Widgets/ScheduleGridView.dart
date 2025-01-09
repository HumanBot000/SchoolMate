import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/util/dates.dart';

class ScheduleGridView extends StatefulWidget {
  final Schedule schedule;

  const ScheduleGridView({super.key, required this.schedule});

  @override
  State<ScheduleGridView> createState() => _ScheduleGridViewState();
}

class _ScheduleGridViewState extends State<ScheduleGridView> {
  // Any day of the week
  DateTime currentFocusedScheduleWeek = DateTime.now();
  bool _isSwiping = false;

  @override
  Widget build(BuildContext context) {
    final filteredWeekdays = weekdaysAbbreviations
        .asMap()
        .entries
        .where((entry) => widget.schedule.metadata.workdays.contains(entry.key))
        .toList();

    // Contains the days of the current week, but only if they are workdays
    final List<DateTime> filteredWeekdaysAtWork = List.generate(7, (index) {
      return getStartOfWeek(currentFocusedScheduleWeek)
          .add(Duration(days: index));
    }).where((date) {
      return widget.schedule.metadata.workdays.contains(date.weekday - 1);
    }).toList();

    return GestureDetector(
      onPanUpdate: (details) {
        if (_isSwiping) {
          return; // ensures the user can only swipe one time and after that he must lift his finger first
        }
        // Swiping in right direction (previous week)
        if (details.delta.dx > 0) {
          setState(() {
            currentFocusedScheduleWeek =
                currentFocusedScheduleWeek.subtract(const Duration(days: 7));
            _isSwiping = true;
          });
        }

        // Swiping in left direction (next week)
        if (details.delta.dx < 0) {
          setState(() {
            currentFocusedScheduleWeek =
                currentFocusedScheduleWeek.add(const Duration(days: 7));
            _isSwiping = true;
          });
        }
      },
      onPanEnd: (details) {
        setState(() {
          _isSwiping = false;
        });
      },
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
                style: BorderStyle.solid,
                color: Colors.grey.shade400,
                width: 1.0),
            verticalInside: BorderSide(
                style: BorderStyle.solid,
                color: Colors.grey.shade400,
                width: 1.0),
          ),
          children: [
            // Header Row
            TableRow(
              children: [
                TableCell(
                  child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            widget.schedule.metadata
                                .alternatedWeekForDate(
                                    currentFocusedScheduleWeek)
                                .toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "CW ${getIsoWeekNumber(currentFocusedScheduleWeek)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )),
                ),
                ...List.generate(filteredWeekdaysAtWork.length, (index) {
                  final currentIterationDay = filteredWeekdaysAtWork[index];
                  final isMonthChanged = index > 0 &&
                      currentIterationDay.month !=
                          filteredWeekdaysAtWork[index - 1].month;
                  return TableCell(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: currentIterationDay ==
                                    currentFocusedScheduleWeek
                                ? Colors.green
                                : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              weekdaysAbbreviations[
                                  currentIterationDay.weekday - 1],
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                          ),
                        ),
                        if (index == 0 || isMonthChanged)
                          Text(DateFormat("d. MMM").format(currentIterationDay))
                        else
                          Text(DateFormat("d").format(currentIterationDay)),
                      ],
                    ),
                  );
                }),
              ],
            ),

            ...List.generate(
              widget.schedule.metadata.workdays.length,
              (rowIndex) => TableRow(
                children: [
                  TableCell(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'X',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ),
                  ...filteredWeekdays.map((_) {
                    return TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
