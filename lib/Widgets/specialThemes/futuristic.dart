import 'dart:math';

import 'package:flutter/material.dart';

Widget buildGradientBackground() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0A0E27),
          Color(0xFF1A1F36),
          Color(0xFF2D3561),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    ),
  );
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final int particleCount = 15;
  final List<Offset> positions = [];
  final Random rnd = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < particleCount; i++) {
        positions.add(Offset(
            rnd.nextDouble() * size.width, rnd.nextDouble() * size.height));
      }
      setState(() {});
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ParticlePainter(
              positions: positions,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Offset> positions;
  final double progress;

  _ParticlePainter({
    required this.positions,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A7BFF).withValues(alpha: 0.1 * progress)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    for (int i = 0; i < positions.length; i++) {
      final radius = 2.0 + (i % 3) * 1.0;
      canvas.drawCircle(positions[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) {
    return old.progress != progress;
  }
}

Widget futuristicAppBar(BuildContext context, String title, Icon icon,
    Animation<double> fadeAnimation, AnimationController fadeController,
    {Widget trailing = const SizedBox(), bool showBackButtonInstead = false}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF3A7BFF).withValues(alpha: 0.1),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      border: Border(
        bottom: BorderSide(
          color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    ),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FadeTransition(
        opacity: fadeAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: showBackButtonInstead
                  ? IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : icon,
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
              ).createShader(bounds),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: fadeAnimation,
              child: trailing,
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF3A7BFF)),
    ),
  );
}
