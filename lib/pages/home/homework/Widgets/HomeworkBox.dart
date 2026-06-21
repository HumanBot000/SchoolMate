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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F36).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.homework.subject.avatar(context),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.homework.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            decoration: _checkboxIsActivated
                                ? TextDecoration.lineThrough
                                : null,
                            decorationThickness: 2.0,
                            decorationColor: Colors.red),
                      ),
                    ),
                    if (widget.homework.handIn)
                      const Icon(
                        Icons.watch_later,
                        color: Colors.white60,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.homework.subject.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                if (widget.homework.dueDate != null)
                  Text(
                      "${weekdaysAbbreviations[widget.homework.dueDate!.weekday - 1]}. ${DateFormat("d. MMM").format(widget.homework.dueDate!)} | In ${getVisualTimeTillDate(DateTime.now(), widget.homework.dueDate!)[0]} ${getVisualTimeTillDate(DateTime.now(), widget.homework.dueDate!)[1]}",
                      style: TextStyle(
                          fontSize: 13,
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
            activeColor: const Color(0xFF3A7BFF),
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white60, width: 1.5),
            onChanged: (value) async {
              await _handleCompletionToggle();
            },
          ),
        ],
      ),
    );
  }
}
