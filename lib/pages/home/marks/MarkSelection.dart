import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

import 'overview/MarksOverviewPage.dart';

class MarkSelector extends StatelessWidget {
  final GradingSystem gradingSystem;
  final Function(double) onMarkSelected;
  final String title;

  const MarkSelector(
      {super.key,
      required this.gradingSystem,
      required this.onMarkSelected,
      this.title = "Add a mark"});

  Widget _buildDecimalMarkSelector() {
    final int minMark = parseMark(gradingSystem.range[0]).toInt();
    final int maxMark = parseMark(gradingSystem.range[1]).toInt();
    double selectedValue = minMark.toDouble();

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  markRepresentation(selectedValue, gradingSystem),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getMarkColor(
                          bestMark: minMark,
                          worstMark: maxMark,
                          valueMark: selectedValue,
                          colors: markColors,
                        ),
                      ),
                ),
                ElevatedButton(
                  onPressed: () => onMarkSelected(selectedValue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getMarkColor(
                      bestMark: minMark,
                      worstMark: maxMark,
                      valueMark: selectedValue,
                      colors: markColors,
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
              value: selectedValue,
              min: minMark.toDouble(),
              max: maxMark.toDouble(),
              divisions: (maxMark - minMark) * 10,
              // Allow for decimals (0.1 increments)
              label: markRepresentation(selectedValue, gradingSystem),
              onChanged: (value) {
                setState(() {
                  selectedValue = double.parse(
                      value.toStringAsFixed(1)); // Round to 1 decimal place
                });
              },
              activeColor: getMarkColor(
                bestMark: minMark,
                worstMark: maxMark,
                valueMark: selectedValue,
                colors: markColors,
              ),
            ),
          ],
        );
      },
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
              Text(title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 12),
              if (!gradingSystem.modifiers.contains("."))
                Column(
                  children: List.generate(
                    ((parseMark(gradingSystem.range[1]).toInt() -
                                parseMark(gradingSystem.range[0]).toInt() +
                                1) /
                            3)
                        .ceil(),
                    (rowIndex) {
                      final startIndex = rowIndex * 3;
                      final endIndex = (rowIndex * 3 + 3).clamp(
                          0,
                          parseMark(gradingSystem.range[1]).toInt() -
                              parseMark(gradingSystem.range[0]).toInt() +
                              1);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            endIndex - startIndex,
                            (collumnIndex) {
                              final index = startIndex + collumnIndex;
                              final markValue =
                                  parseMark(gradingSystem.range[0]).toInt() +
                                      index;

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: collumnIndex < 2 ? 8.0 : 0.0,
                                  ),
                                  child: SizedBox(
                                    height: 60,
                                    child: Material(
                                      color: getMarkColor(
                                        bestMark:
                                            parseMark(gradingSystem.range[0])
                                                .toInt(),
                                        worstMark:
                                            parseMark(gradingSystem.range[1])
                                                .toInt(),
                                        valueMark: markValue.toDouble(),
                                        colors: markColors,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      elevation: 2,
                                      child: InkWell(
                                        onTap: () {
                                          onMarkSelected(markValue.toDouble());
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Center(
                                          child: Text(
                                            markRepresentation(
                                                markValue.toDouble(),
                                                gradingSystem),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (gradingSystem.modifiers.contains("."))
                _buildDecimalMarkSelector(),
            ],
          ),
        ),
      ),
    );
  }
}
