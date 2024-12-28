import 'dart:math' as math;

import 'package:app/config/generic.dart';
import 'package:flutter/material.dart';

class WorkDaysSelector extends StatefulWidget {
  final List<bool> workdays;
  final int activePage;
  final Function(int) onActivePageChange;
  final Function(int, bool) onWorkdayChange;

  const WorkDaysSelector({
    super.key,
    required this.workdays,
    required this.onActivePageChange,
    required this.activePage,
    required this.onWorkdayChange,
  });

  @override
  State<WorkDaysSelector> createState() => _WorkDaysSelectorState();
}

class _WorkDaysSelectorState extends State<WorkDaysSelector> {
  Widget _activatedPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        return Expanded(
          child: Column(
            children: [
              Text(
                weekdaysAbbreviations[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Transform.rotate(
                  angle: math.pi / 2, // 180 degrees
                  child: Switch(
                    value: widget.workdays[index],
                    onChanged: (value) {
                      widget.onWorkdayChange(index, value);
                    },
                  ),
                ),
              ),
              Icon(
                widget.workdays[index] ? Icons.work : Icons.work_off,
                color: widget.workdays[index] ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Row> _deactivatedPage() {
    return List.generate(7, (index) {
      if (widget.workdays[index]) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                weekdaysAbbreviations[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.work, color: Colors.green),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                weekdaysAbbreviations[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.work_off, color: Colors.red),
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.activePage == 1 ? null : () => widget.onActivePageChange(1),
      // don't pass clicks of the individual sliders of to the cell selection
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: widget.activePage == 1
                  ? [_activatedPage()]
                  : _deactivatedPage()),
        ),
      ),
    );
  }
}
