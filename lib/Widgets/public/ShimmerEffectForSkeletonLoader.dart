//https://dribbble.com/shots/20561027-YouTube-Shorts-App-Skeleton-Screen-loader
import 'package:flutter/material.dart';

class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Color _baseColor = Colors.grey[300]!;
  final Color _highlightColor = Colors.grey[100]!;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
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
        return _Shimmer(
          controller: _controller,
          baseColor: _baseColor,
          highlightColor: _highlightColor,
          child: widget.child,
        );
      },
    );
  }
}

class _Shimmer extends StatelessWidget {
  final AnimationController controller;
  final Color baseColor;
  final Color highlightColor;
  final Widget child;

  const _Shimmer({
    required this.controller,
    required this.baseColor,
    required this.highlightColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            baseColor,
            highlightColor,
            highlightColor,
            baseColor,
          ],
          stops: const [
            0.0,
            0.3,
            0.5,
            1.0,
          ],
          begin: Alignment(-1.0 + (controller.value * 2), 0.0), // Animation
          end: Alignment(1.0 + (controller.value * 2), 0.0), // Animation
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
