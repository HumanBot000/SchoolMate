import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

import 'overview/MarksOverviewPage.dart';

class MarkSelector extends StatefulWidget {
  final GradingSystem gradingSystem;
  final Function(double) onMarkSelected;
  final String title;
  final double? selectedMark;

  const MarkSelector({
    super.key,
    required this.gradingSystem,
    required this.onMarkSelected,
    this.title = "Add a mark",
    this.selectedMark,
  });

  @override
  State<MarkSelector> createState() => _MarkSelectorState();
}

class _MarkSelectorState extends State<MarkSelector> {
  late double selectedMark;

  @override
  void initState() {
    super.initState();
    selectedMark = widget.selectedMark ??
        min(parseMark(widget.gradingSystem.range[0]),
            parseMark(widget.gradingSystem.range[1]));
  }

  Widget _buildMarkSelector() {
    final double bestMark = parseMark(widget.gradingSystem.range[0]).toDouble();
    final double worstMark =
        parseMark(widget.gradingSystem.range[1]).toDouble();
    final int precision = widget.gradingSystem.modifiers.contains(".") ? 1 : 0;

    // Ensure slider min <= max
    final double sliderMin = min(bestMark, worstMark);
    final double sliderMax = max(bestMark, worstMark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              markRepresentation(selectedMark, widget.gradingSystem),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: getMarkColor(
                      bestMark: bestMark.toInt(),
                      worstMark: worstMark.toInt(),
                      valueMark: selectedMark,
                      colors: (bestMark < worstMark)
                          ? markColors
                          : markColors.reversed.toList(),
                    ),
                  ),
            ),
            ElevatedButton(
              onPressed: () => widget.onMarkSelected(selectedMark),
              style: ElevatedButton.styleFrom(
                backgroundColor: getMarkColor(
                  bestMark: bestMark.toInt(),
                  worstMark: worstMark.toInt(),
                  valueMark: selectedMark,
                  colors: (bestMark < worstMark)
                      ? markColors
                      : markColors.reversed.toList(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Select',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Slider(
          value: selectedMark,
          min: sliderMin,
          max: sliderMax,
          divisions:
              ((sliderMax - sliderMin) * (precision == 1 ? 10 : 1)).round(),
          label: markRepresentation(selectedMark, widget.gradingSystem),
          onChanged: (value) {
            setState(() {
              selectedMark = double.parse(value.toStringAsFixed(precision));
            });
          },
          activeColor: getMarkColor(
            bestMark: bestMark.toInt(),
            worstMark: worstMark.toInt(),
            valueMark: selectedMark,
            colors: (bestMark < worstMark)
                ? markColors
                : markColors.reversed.toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildMarkSelector(),
            ],
          ),
        ),
      ),
    );
  }
}
