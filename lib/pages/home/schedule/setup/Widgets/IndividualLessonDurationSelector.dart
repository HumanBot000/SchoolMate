import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';

class IndividualLessonDurationSelector extends StatefulWidget {
  final int activePage;
  final Function(int) onActivePageChange;
  final Function(int) onLessonDurationChange;
  final Function(int) onCustomLessonDurationChange;

  // In Minutes (Maybe Duration would be better? But I think int is okay)
  final int selectedCustomLessonDuration;
  final int lessonDuration;

  const IndividualLessonDurationSelector({
    super.key,
    required this.activePage,
    required this.onActivePageChange,
    this.selectedCustomLessonDuration = 90,
    required this.lessonDuration,
    required this.onLessonDurationChange,
    required this.onCustomLessonDurationChange,
  });

  @override
  State<IndividualLessonDurationSelector> createState() =>
      _IndividualLessonDurationSelectorState();
}

class _IndividualLessonDurationSelectorState
    extends State<IndividualLessonDurationSelector> {
  late int _selectedCustomLessonDuration;

  @override
  void initState() {
    super.initState();
    _selectedCustomLessonDuration = widget.selectedCustomLessonDuration;
  }

  Widget _deactivatedPage() {
    return Row(
      children: [
        const Icon(Icons.access_time_filled, color: Colors.grey),
        Container(
            margin: const EdgeInsets.all(8),
            child:
                Text("Each lesson is ${widget.lessonDuration} minutes long")),
      ],
    );
  }

  Widget _activatedPage() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "You can change this later for each individual lesson.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "45 minutes", // Default time -> not changeable
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.access_time_filled, color: Colors.grey[600]),
          ]),
        ),
        Transform.rotate(
          angle: math.pi / 2, // 180 degrees
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: widget.lessonDuration != 45
                    ? [Colors.lightBlue, const Color(0x283593FF)]
                    : [Colors.red.shade300, Colors.orange.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Switch.adaptive(
              value: widget.lessonDuration != 45,
              onChanged: (value) => widget.onLessonDurationChange(
                  value ? widget.selectedCustomLessonDuration : 45),
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Text(
                "${widget.selectedCustomLessonDuration} minutes",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.access_time_filled, color: Colors.grey[600]),
              Icon(Icons.access_time_filled, color: Colors.grey[600]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedGradientButton(
                  onPressed: () => _showCustomLessonDurationSelectorDialog(),
                  borderRadius: BorderRadius.circular(16),
                  child: Text(
                    "Custom",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void _showCustomLessonDurationSelectorDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: StatefulBuilder(
          // I don't know why it's needed here, lib/Widgets/public/TimePicker.dart also works without it, but otherwise the data in the  gradientButton doesn't update properly
          builder: (BuildContext context, StateSetter setDialogState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "How long are your lessons?",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Color(0x283593FF)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$_selectedCustomLessonDuration minutes",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              "Minutes",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 120,
                              child: ListWheelScrollView.useDelegate(
                                itemExtent: 40,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    _selectedCustomLessonDuration = index * 5;
                                  });
                                  setDialogState(() {}); // Update dialog UI
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        (index * 5).toString(),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  childCount:
                                      61, // One child is equivalent to 5 minutes (An interval of 5 minutes can be selected)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onCustomLessonDurationChange(
                              _selectedCustomLessonDuration);
                          widget.onLessonDurationChange(
                              _selectedCustomLessonDuration);
                        },
                        child: Text(
                          "Confirm",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:
            widget.activePage == 3 ? null : () => widget.onActivePageChange(3),
        // don't pass clicks of the individual sliders of to the cell selection
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _deactivatedPage(),
                // This isn't really the deactivated page, it's always shown but when the page is active other things are shown in addition, couldn't find better naming
                if (widget.activePage == 3) _activatedPage(),
              ],
            ),
          ),
        ));
  }
}
