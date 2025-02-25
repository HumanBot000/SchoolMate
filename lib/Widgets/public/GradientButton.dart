import 'package:flutter/material.dart';

class IconGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String tooltip;
  final double size;
  final Gradient gradient;

  const IconGradientButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.size = 56.0, // Default circular button size
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Makes it perfectly round
          gradient: gradient,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          color: Colors.white, // Ensures icon is visible on gradient
          tooltip: tooltip, // Tooltip when hovered or long-pressed
        ),
      ),
    );
  }
}

class ElevatedGradientButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const ElevatedGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ??
        BorderRadius.circular(8); // Default rounded corners
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}
