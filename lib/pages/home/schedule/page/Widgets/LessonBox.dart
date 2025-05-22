import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/util/extensions/dates.dart';

class LessonBox extends StatelessWidget {
  final String title;
  final Color color;
  final double height;
  final double width;
  final LessonTemporalData? temporalData;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? location;
  final String? teacherName;
  final bool crossedOut;
  final Color? specialIndicatorColor;
  final Container? subContent;

  const LessonBox({
    super.key,
    required this.title,
    required this.color,
    required this.height,
    required this.width,
    this.temporalData,
    this.startTime,
    this.endTime,
    this.location,
    this.teacherName,
    this.crossedOut = false,
    this.specialIndicatorColor,
    this.subContent,
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
      color: color.computeLuminance() >= 0.5
          ? color.withValues(alpha: 0.1)
          : Colors.white.withValues(alpha: 0.1),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            height: height.toDouble(),
            width: width.toDouble(),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 3),
            ),
            child: FittedBox(
              alignment: startTime != null || temporalData != null
                  ? Alignment.center
                  : Alignment.topCenter,
              fit: BoxFit.scaleDown,
              child: Column(
                children: [
                  if (startTime != null || temporalData != null)
                    Text(DateFormat("HH:mm").format(_startTime())),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color.computeLuminance() >= 0.5
                              ? color
                              : Colors.white,
                        ),
                  ),
                  if (startTime != null || temporalData != null)
                    Text(DateFormat("HH:mm").format(_endTime())),
                  if (location != null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        location!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: color.computeLuminance() >= 0.5
                                  ? color
                                  : Colors.white,
                            ),
                      ),
                    ),
                  if (specialIndicatorColor != null)
                    Icon(
                      Icons.circle,
                      color: specialIndicatorColor,
                      size: 20,
                    ),
                  if (teacherName != null && specialIndicatorColor == null)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        teacherName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: color.computeLuminance() >= 0.5
                                  ? color
                                  : Colors.white,
                            ),
                      ),
                    ),
                  if (subContent != null) subContent!,
                ],
              ),
            ),
          ),
          if (crossedOut)
            Positioned.fill(
              child: CustomPaint(
                painter: CrossOutPainter(),
              ),
            ),
        ],
      ),
    );
  }
}

class CrossOutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
