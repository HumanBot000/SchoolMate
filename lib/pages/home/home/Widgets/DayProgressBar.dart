import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';

class DayProgressBar extends StatefulWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime widgetBuildTime;

  const DayProgressBar({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.widgetBuildTime,
  });

  @override
  State<DayProgressBar> createState() => _DayProgressBarState();
}

class _DayProgressBarState extends State<DayProgressBar>
    with SingleTickerProviderStateMixin {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  double progress = 0.0;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  OverlayEntry? _overlayEntry;
  bool showCelebration = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: progress, end: progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _updateProgress();
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
      // We need to make sure that the animation is only playing when the endTime gets reached and this widget is currently shown. Not everytime we build the widget after the endTime
      if (!showCelebration &&
          widget.widgetBuildTime.isBefore(widget.endTime.toDateTime())) {
        showCelebration = true;
        _showCelebrationAnimation();
      }
    } else {
      newProgress = elapsed / totalDuration;
    }

    // Only trigger setState if progress is actually changing.
    if (progress != newProgress) {
      _animation = Tween<double>(begin: progress, end: newProgress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
      progress = newProgress;
      setState(() {}); // This will trigger a rebuild, which should happen once.
    }
  }

  void _showCelebrationAnimation() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: Stack(
            children: List.generate(30, (index) {
              final random = math.Random();
              final left =
                  random.nextDouble() * screenWidth; // Random X position
              final duration = Duration(
                  milliseconds: random.nextInt(2500) + 1500); // 1.5s - 4s
              final size = random.nextDouble() * 20 + 24; // Random size 24 - 44
              return FallingEmoji(
                left: left,
                duration: duration,
                size: size,
                screenHeight: screenHeight,
              );
            }),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        showCelebration = false;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  String _getRemainingTime() {
    final now = DateTime.now();
    // Assume getVisualTimeTillDate returns a list like [hours, minutes]
    final visualTime = getVisualTimeTillDate(now, widget.endTime.toDateTime());
    return "${visualTime[0]} ${getLocalizedUnit(l10n, visualTime[1])}";
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule, size: 28, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  l10n.schoolDayProgress,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                        "${_animation.value < 1 ? (_animation.value * 100).toStringAsFixed(2) : "100"}%",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.remainingTime(_getRemainingTime()),
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
      colors: progress < 1
          ? [Colors.blue, Colors.blueAccent]
          : [Colors.green, Colors.green],
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

class FallingEmoji extends StatefulWidget {
  final double left;
  final Duration duration;
  final double size;
  final double screenHeight;

  const FallingEmoji({
    super.key,
    required this.left,
    required this.duration,
    required this.size,
    required this.screenHeight,
  });

  @override
  _FallingEmojiState createState() => _FallingEmojiState();
}

class _FallingEmojiState extends State<FallingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fallAnimation = Tween<double>(begin: -50, end: widget.screenHeight)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _fallAnimation.value,
          left: widget.left,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: widget.size),
            child: const Text(
              "🎉",
            ),
          ),
        );
      },
    );
  }
}
