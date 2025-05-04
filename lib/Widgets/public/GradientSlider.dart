import 'package:flutter/material.dart';

class GradientSlider extends StatelessWidget {
  final double sliderRadius;
  final Gradient gradient;
  final Color thumbColor;
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int precision;
  final TextStyle? textStyle;
  final bool isThumbAbove;
  final Color inactiveColor; // Color for sections beyond slider value

  const GradientSlider({
    super.key,
    required this.sliderRadius,
    required this.gradient,
    required this.value,
    this.onChanged,
    required this.thumbColor,
    this.min = 0,
    this.max = 1,
    this.precision = 0,
    this.textStyle,
    this.isThumbAbove = false,
    this.inactiveColor = Colors.grey, // Default gray for inactive sections
  });

  double get _normalizedValue => (value - min) / (max - min);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          // Background Track (inactive color)
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: inactiveColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(sliderRadius),
            ),
          ),

          // Dynamic Gradient Track
          ClipRRect(
            borderRadius: BorderRadius.circular(sliderRadius),
            child: SizedBox(
              height: 8,
              width: constraints.maxWidth,
              child: CustomPaint(
                size: Size(constraints.maxWidth, 8),
                painter: DynamicGradientPainter(
                  gradient: gradient,
                  normalizedValue: _normalizedValue,
                ),
              ),
            ),
          ),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 0,
              thumbShape: CircleThumbShape(
                thumbRadius: sliderRadius,
                text: value.toStringAsFixed(precision),
                thumbColor: thumbColor,
                textStyle: textStyle,
                isAbove: isThumbAbove,
              ),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              min: min,
              max: max,
              value: value,
              onChanged: onChanged != null
                  ? (newValue) {
                      final rounded =
                          double.parse(newValue.toStringAsFixed(precision));
                      onChanged!(rounded);
                    }
                  : null,
            ),
          ),
        ],
      );
    });
  }
}

// Custom painter for dynamic gradient
class DynamicGradientPainter extends CustomPainter {
  final Gradient gradient;
  final double normalizedValue;

  DynamicGradientPainter({
    required this.gradient,
    required this.normalizedValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Extract gradient colors and stops
    List<Color> colors = [];
    List<double> stops = [];

    if (gradient is LinearGradient) {
      colors = (gradient as LinearGradient).colors;
      stops = (gradient as LinearGradient).stops ??
          List.generate(colors.length, (i) => i / (colors.length - 1));
    }

    // If we don't have valid gradient data, exit
    if (colors.isEmpty) return;

    // Create a dynamic gradient based on the slider position
    List<Color> dynamicColors = [];
    List<double> dynamicStops = [];

    // First color is always the first color of the gradient
    dynamicColors.add(colors.first);
    dynamicStops.add(0.0);

    // Add intermediate colors, scaling their positions based on slider value
    for (int i = 1; i < colors.length; i++) {
      double originalStop = stops[i];

      // If this stop is beyond our current slider value
      if (originalStop > normalizedValue) {
        // Calculate the color at the edge of our slider position
        if (i > 0) {
          // Find the proportion between the previous stop and this one
          double prevStop = stops[i - 1];
          double interval = originalStop - prevStop;
          double proportion = (normalizedValue - prevStop) / interval;

          // If proportion is valid (between 0 and 1)
          if (proportion > 0 && proportion < 1) {
            // Interpolate the color
            Color lerpedColor =
                Color.lerp(colors[i - 1], colors[i], proportion)!;
            dynamicColors.add(lerpedColor);
            dynamicStops.add(normalizedValue);
            break;
          }
        }
      } else {
        // This color stop is within our slider value
        dynamicColors.add(colors[i]);

        // Scale the stop position to fit within our normalized value
        double scaledStop = originalStop;
        dynamicStops.add(scaledStop);
      }
    }

    // Create the paint with our dynamic gradient
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: dynamicColors,
        stops: dynamicStops,
      ).createShader(
          Rect.fromLTWH(0, 0, size.width * normalizedValue, size.height));

    // Draw only up to the slider position
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width * normalizedValue, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final String text;
  final TextStyle? textStyle;
  final Color thumbColor;
  final bool isAbove;

  CircleThumbShape({
    required this.thumbRadius,
    required this.text,
    required this.thumbColor,
    this.textStyle,
    this.isAbove = false,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbRadius * 2, thumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final circleOffset = isAbove
        ? Offset(center.dx, center.dy - thumbRadius * 1.5) // Above track
        : Offset(center.dx, center.dy + thumbRadius * 1.5); // Below track

    // Draw the circle
    final paint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    // Draw shadow
    canvas.drawCircle(
        circleOffset,
        thumbRadius + 2,
        Paint()
          ..color = Colors.black.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));

    // Draw circle
    canvas.drawCircle(circleOffset, thumbRadius, paint);

    // Create the text painter
    final effectiveTextStyle = textStyle ??
        TextStyle(
          color: Colors.white,
          fontSize: thumbRadius * 0.8,
          fontWeight: FontWeight.bold,
        );

    // Use FittedBox for text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: effectiveTextStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // Save canvas state
    canvas.save();

    // Calculate the available space for text
    final textBoxWidth = thumbRadius * 1.6;
    final textBoxHeight = thumbRadius * 1.2;

    // Create a FittedBox effect by scaling if needed
    double scale = 1.0;
    if (textPainter.width > textBoxWidth ||
        textPainter.height > textBoxHeight) {
      final widthScale = textBoxWidth / textPainter.width;
      final heightScale = textBoxHeight / textPainter.height;
      scale = widthScale < heightScale ? widthScale : heightScale;
    }

    // Position text in the center of the circle
    final textPosition = Offset(
      circleOffset.dx - (textPainter.width * scale) / 2,
      circleOffset.dy - (textPainter.height * scale) / 2,
    );

    canvas.translate(textPosition.dx, textPosition.dy);

    // Apply scaling for the FittedBox effect
    if (scale < 1.0) {
      canvas.scale(scale);
    }

    // Draw the text
    textPainter.paint(canvas, Offset.zero);

    // Restore canvas state
    canvas.restore();
  }
}
