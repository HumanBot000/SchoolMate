import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/util/extensions/dates.dart';

class LessonBox extends StatelessWidget {
  final String title;
  final Color color;
  final double height;
  final double width;
  final LessonTemporalData
      temporalData; // Just optical, need to handle width and height outside

  const LessonBox(
      {super.key,
      required this.title,
      required this.color,
      required this.height,
      required this.width,
      required this.temporalData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(),
      width: width.toDouble(),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
          border: Border.all(color: color, width: 3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(DateFormat("HH:mm").format(temporalData.startTime.toDateTime())),
          Text(title),
          Text(DateFormat("HH:mm").format(temporalData.endTime.toDateTime())),
        ],
      ),
    );
  }
}
