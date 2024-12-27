import 'package:app/Widgets/public/TimePicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class LessonsTimeFrameSelector extends StatefulWidget {
  final TimeOfDay? startTime, endTime;
  final Function(TimeOfDay?, TimeOfDay?) onTimeChanged;

  const LessonsTimeFrameSelector(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.onTimeChanged});

  @override
  State<LessonsTimeFrameSelector> createState() =>
      _LessonsTimeFrameSelectorState();
}

class _LessonsTimeFrameSelectorState extends State<LessonsTimeFrameSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          children: [
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => CustomTimePicker(
                    initialTime: widget.startTime ?? TimeOfDay.now(),
                    headline: "When does your first lesson start?",
                    onTimeSelected: (time) {
                      widget.onTimeChanged(time, widget.endTime);
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: Text(
                          "Lessons start at",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.startTime != null
                          ? Theme.of(context).colorScheme.primary.withAlpha(80)
                          : Colors.red.withAlpha(80),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.startTime != null
                          ? intl.DateFormat('hh:mm a').format(
                              DateTime(0, 0, 0, widget.startTime!.hour,
                                  widget.startTime!.minute),
                            )
                          : "Set",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => CustomTimePicker(
                    initialTime: widget.endTime ?? TimeOfDay.now(),
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.orange.shade300],
                    ),
                    headline: "When does your last lesson end?",
                    onTimeSelected: (time) {
                      widget.onTimeChanged(widget.startTime, time);
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120, // Fixed width for label alignment
                        child: Text(
                          "Lessons end at",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.endTime != null
                          ? Theme.of(context).colorScheme.primary.withAlpha(80)
                          : Colors.red.withAlpha(80),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.endTime != null
                          ? intl.DateFormat('hh:mm a').format(
                              DateTime(
                                  0,
                                  0,
                                  0,
                                  widget.endTime!.hour,
                                  widget.endTime!
                                      .minute), //Just something because intl can't handle TimeOfDay
                            )
                          : "Set",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
