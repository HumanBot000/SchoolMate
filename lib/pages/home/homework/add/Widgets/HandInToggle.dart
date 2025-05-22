import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Widgets/public/TimePicker.dart';
import 'package:school_mate/util/extensions/dates.dart';

class HandInHomeworkToggle extends StatelessWidget {
  final void Function(bool) onStateChanged;
  final void Function(TimeOfDay) onTimeSelected;
  final bool value;
  final TimeOfDay? handInTime;

  const HandInHomeworkToggle({
    super.key,
    required this.value,
    required this.onStateChanged,
    required this.handInTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hand in Homework?",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onStateChanged,
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
          if (value)
            Text(
              "We will notify you before the deadline, so you don't forget to submit your work.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade900, fontWeight: FontWeight.bold),
            ),
          if (value)
            Text(
              "We won't notify you if this task is marked as completed!",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          if (value)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => CustomTimePicker(
                      initialTime: handInTime ?? TimeOfDay.now(),
                      onTimeSelected: (time) => onTimeSelected(time),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            handInTime != null
                                ? DateFormat("HH:mm")
                                    .format(handInTime!.toDateTime())
                                : "Select Time",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
