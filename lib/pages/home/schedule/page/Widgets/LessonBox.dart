import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/util/extensions/dates.dart';

class LessonBox extends StatelessWidget {
  final String title;
  final Color color;
  final double height;
  final double width;
  final LessonTemporalData?
      temporalData; // Just optical, need to handle width and height outside
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  const LessonBox({
    super.key,
    required this.title,
    required this.color,
    required this.height,
    required this.width,
    this.temporalData,
    this.startTime,
    this.endTime,
  });

  DateTime _startTime() {
    if (temporalData != null) {
      return temporalData!.startTime.toDateTime();
    }
    return startTime!.toDateTime();
  }

  DateTime _endTime() {
    if (temporalData != null) {
      return temporalData!.endTime.toDateTime();
    }
    return endTime!.toDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        height: height.toDouble(),
        width: width.toDouble(),
        decoration: BoxDecoration(border: Border.all(color: color, width: 3)),
        child: FittedBox(
          alignment: startTime != null || temporalData != null
              ? Alignment.center
              : Alignment.topCenter,
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              if (startTime != null || temporalData != null)
                Text(DateFormat("HH:mm").format(_startTime())),
              Text(title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      )),
              if (startTime != null || temporalData != null)
                Text(DateFormat("HH:mm").format(_endTime())),
            ],
          ),
        ),
      ),
    );
  }
}
