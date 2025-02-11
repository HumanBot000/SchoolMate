import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

class DayProgressBar extends StatefulWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DayProgressBar({
    Key? key,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  State<DayProgressBar> createState() => _DayProgressBarState();
}

class _DayProgressBarState extends State<DayProgressBar>
    with SingleTickerProviderStateMixin {
  double progress = 0.0; // Value between 0.0 and 1.0
  Timer? timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    // Initialize with a tween that does nothing initially.
    _animation = Tween<double>(begin: progress, end: progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _updateProgress();
    // Update progress every 100ms for smooth yet efficient animations.
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateProgress();
    });
  }

  void _updateProgress() {
    final now = DateTime.now();
    final totalDuration = widget.endTime
        .toDateTime()
        .difference(widget.startTime.toDateTime())
        .inMilliseconds;
    final elapsed =
        now.difference(widget.startTime.toDateTime()).inMilliseconds;

    double newProgress;
    if (elapsed < 0) {
      newProgress = 0.0;
    } else if (elapsed >= totalDuration) {
      newProgress = 1.0;
      timer?.cancel();
    } else {
      newProgress = elapsed / totalDuration;
    }

    // Animate from the current progress to the new progress.
    _animation = Tween<double>(begin: progress, end: newProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(from: 0);
    progress = newProgress;
    setState(() {}); // Trigger a rebuild to update texts etc.
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _getRemainingTime() {
    final now = DateTime.now();
    // Assume getVisualTimeTillDate returns a list like [hours, minutes]
    final visualTime = getVisualTimeTillDate(now, widget.endTime.toDateTime());
    return "${visualTime[0]} ${visualTime[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule, size: 28, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  "School Day Progress",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Circular progress indicator with animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: CircleProgressPainter(progress: _animation.value),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: Text(
                        "${(_animation.value * 100).toStringAsFixed(2)}%",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Remaining time text
            Text(
              "Remaining: ${_getRemainingTime()}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress; // Value from 0.0 to 1.0

  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10; // Leave space for stroke width

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground arc (progress)
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: (2 * math.pi * progress) - math.pi / 2,
      colors: [Colors.blue, Colors.blueAccent],
    );

    final foregroundPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final angle = 2 * math.pi * progress;
    // Draw the arc starting from the top (-pi/2)
    canvas.drawArc(rect, -math.pi / 2, angle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
