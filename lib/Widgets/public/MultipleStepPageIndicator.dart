// inspiration: https://dribbble.com/shots/24193179-slothUI-World-s-Laziest-Design-System-Step-Progress-UIUX
import 'package:flutter/material.dart';

class MultipleStepPageIndicator extends StatefulWidget {
  static const Color defaultIndicatorColor = Colors.purple;
  static const Duration defaultWaveDuration = Duration(milliseconds: 1500);
  static const double defaultIndicatorSize = 26.0;
  static const double defaultConnectionLineThickness = 2.0;

  final int stepCount;
  final int currentStep;
  final Color indicatorColor;
  final Color backgroundColor;
  final List<String>? headTitles;
  final List<String>? subTitles;
  final List<IconData>? icons;
  final Color waveColor;
  final Duration waveDuration;
  final double waveMaxRadius;
  final double indicatorSize;
  final double connectionLineThickness;
  final TextStyle? headTitleStyle;
  final TextStyle? subTitleStyle;
  final bool showTitles;
  final double? titleWidth;
  final EdgeInsetsGeometry titlePadding;
  final Function(int)? onStepTapped;
  final bool showShadow;
  final List<BoxShadow>? customShadow;
  final ShapeBorder? indicatorShape;
  final Gradient? indicatorGradient;

  const MultipleStepPageIndicator({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.indicatorColor = defaultIndicatorColor,
    this.backgroundColor = Colors.white,
    this.headTitles,
    this.subTitles,
    this.icons,
    this.waveColor = defaultIndicatorColor,
    this.waveDuration = defaultWaveDuration,
    this.waveMaxRadius = 10.0,
    this.indicatorSize = defaultIndicatorSize,
    this.connectionLineThickness = defaultConnectionLineThickness,
    this.headTitleStyle,
    this.subTitleStyle,
    this.showTitles = true,
    this.titleWidth,
    this.titlePadding = const EdgeInsets.all(8.0),
    this.onStepTapped,
    this.showShadow = true,
    this.customShadow,
    this.indicatorShape,
    this.indicatorGradient,
  });

  @override
  State<MultipleStepPageIndicator> createState() =>
      _MultipleStepPageIndicatorState();
}

class _MultipleStepPageIndicatorState extends State<MultipleStepPageIndicator>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    )..repeat();
    _waveAnimation = Tween(begin: 0.0, end: 1.0).animate(_waveController);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15, // Adjusted for titles
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.backgroundColor,
        boxShadow: widget.showShadow
            ? widget.customShadow ??
                [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ]
            : null,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStepIndicatorsWithTitles(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStepIndicatorsWithTitles() {
    List<Widget> indicators = [];
    for (int i = 0; i < widget.stepCount; i++) {
      indicators.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIndicator(i),
            if (widget.showTitles) _buildTitles(i),
          ],
        ),
      );
      if (i < widget.stepCount - 1) {
        indicators.add(
          Padding(
            padding: const EdgeInsets.only(top: 20), // Adjust for title spacing
            child: _buildConnectionLine(i),
          ),
        );
      }
    }
    return indicators;
  }

  Widget _buildConnectionLine(int index) {
    bool isActive = widget.currentStep > index + 1;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: widget.connectionLineThickness,
      color: isActive ? widget.indicatorColor : Colors.grey[300],
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = widget.currentStep > index;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (index == widget.currentStep - 1)
          AnimatedWaveEffect(
            animation: _waveAnimation,
            color: widget.waveColor,
            size: widget.indicatorSize,
            maxRadius: widget.waveMaxRadius,
          ),
        InkWell(
          onTap: () => widget.onStepTapped?.call(index),
          child: Container(
            height: widget.indicatorSize,
            width: widget.indicatorSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? widget.indicatorColor : Colors.grey[300],
              boxShadow: widget.showShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: widget.icons != null
                  ? Icon(
                      widget.icons![index],
                      color: Colors.white,
                      size: widget.indicatorSize * 0.6,
                    )
                  : Text(
                      "${index + 1}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitles(int index) {
    return SizedBox(
      width: widget.titleWidth,
      child: Padding(
        padding: widget.titlePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.headTitles != null && widget.headTitles!.length > index)
              Text(
                widget.headTitles![index],
                style: widget.headTitleStyle ??
                    Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            if (widget.subTitles != null && widget.subTitles!.length > index)
              Text(
                widget.subTitles![index],
                style: widget.subTitleStyle ??
                    Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class AnimatedWaveEffect extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final double size;
  final double maxRadius;

  const AnimatedWaveEffect({
    super.key,
    required this.animation,
    required this.color,
    required this.size,
    this.maxRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double scale = 1 + (animation.value * (maxRadius / size));
        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 1 - animation.value),
            ),
          ),
        );
      },
    );
  }
}
