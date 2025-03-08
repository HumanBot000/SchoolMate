import 'package:flutter/material.dart';

class GradientCircleAvatar extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;
  final ImageProvider? foregroundImage;
  final ImageErrorListener? onBackgroundImageError;
  final ImageErrorListener? onForegroundImageError;
  final Color? foregroundColor;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;
  final Gradient gradient;

  const GradientCircleAvatar({
    super.key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    required this.gradient,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null);

  @override
  Widget build(BuildContext context) {
    double effectiveRadius = radius ?? 30.0;

    return ClipOval(
      child: Container(
        width: effectiveRadius * 2,
        height: effectiveRadius * 2,
        decoration: BoxDecoration(
          gradient: gradient,
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage!,
                  onError: onBackgroundImageError,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (foregroundImage != null)
              Image(
                image: foregroundImage!,
                fit: BoxFit.cover,
              ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
