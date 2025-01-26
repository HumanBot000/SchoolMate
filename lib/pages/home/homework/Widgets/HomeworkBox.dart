import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/util/dates.dart';

class HomeworkBox extends StatefulWidget {
  final Homework homework;
  final Future<void> Function() onCompletionToggle;

  const HomeworkBox({
    super.key,
    required this.homework,
    required this.onCompletionToggle,
  });

  @override
  State<HomeworkBox> createState() => _HomeworkBoxState();
}

class _HomeworkBoxState extends State<HomeworkBox> {
  late bool _checkboxIsActivated;

  @override
  void initState() {
    super.initState();
    _checkboxIsActivated = widget.homework.isCompleted;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleCompletionToggle() async {
    await widget.onCompletionToggle();

    setState(() {
      _checkboxIsActivated = !_checkboxIsActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.homework.subject.avatar(context),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.homework.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            decoration: _checkboxIsActivated
                                ? TextDecoration.lineThrough
                                : null,
                            decorationThickness: 2.0,
                            decorationColor: Colors.red),
                      ),
                      if (widget.homework.handIn)
                        const Icon(
                          Icons.watch_later,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.homework.subject.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  if (widget.homework.dueDate != null)
                    Text(
                        "${weekdaysAbbreviations[widget.homework.dueDate!.weekday - 1]}. ${DateFormat("d. MMM").format(widget.homework.dueDate!)} | In ${getVisualTimeTillDate(DateTime.now(), widget.homework.dueDate!)[0]} ${getVisualTimeTillDate(DateTime.now(), widget.homework.dueDate!)[1]}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: widget.homework.dueDate!
                                        .difference(DateTime.now())
                                        .inHours >
                                    24
                                ? Colors.white
                                : Colors.red)),
                ],
              ),
            ),
            Checkbox(
              value: _checkboxIsActivated,
              onChanged: (value) async {
                await _handleCompletionToggle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
