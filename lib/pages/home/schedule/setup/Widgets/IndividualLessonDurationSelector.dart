import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/Widgets/public/TimePicker.dart';
import 'package:school_mate/util/extensions/dates.dart';

class IndividualLessonDurationSelector extends StatefulWidget {
  final int activePage;
  final Function(int) onActivePageChange;
  final Function(int) onLessonDurationChange;
  final Function(int) onCustomLessonDurationChange;
  final Function(List<List<TimeOfDay>>) onVisualLessonTimesChange;

  // In Minutes (Maybe Duration would be better? But I think int is okay)
  final int selectedCustomLessonDuration;
  final int lessonDuration;
  final List<List<TimeOfDay>> visualLessonTimes;
  final TimeOfDay starOfDay;

  const IndividualLessonDurationSelector({
    super.key,
    required this.activePage,
    required this.onActivePageChange,
    this.selectedCustomLessonDuration = 90,
    required this.lessonDuration,
    required this.onLessonDurationChange,
    required this.onCustomLessonDurationChange,
    this.visualLessonTimes = const [],
    required this.starOfDay,
    required this.onVisualLessonTimesChange,
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

  Widget _visualIndividualLessonTimeSelector() {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.visualLessonTimes.length,
            itemBuilder: (context, index) {
              if (index == widget.visualLessonTimes.length) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey,
                      )),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              color: index == 0
                                  ? Colors.green
                                  : index == widget.visualLessonTimes.length - 1
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) => CustomTimePicker(
                                    initialTime: widget.visualLessonTimes[index]
                                        [0],
                                    onTimeSelected: (time) {
                                      List<List<TimeOfDay>> updatedLessonTimes =
                                          widget.visualLessonTimes;
                                      updatedLessonTimes[index][0] = time;
                                      // Set the default lesson end
                                      updatedLessonTimes[index][1] = TimeOfDay(
                                        hour: updatedLessonTimes[index][0]
                                            .toDateTime()
                                            .add(Duration(
                                                minutes: widget.lessonDuration))
                                            .hour,
                                        minute: updatedLessonTimes[index][0]
                                            .toDateTime()
                                            .add(Duration(
                                                minutes: widget.lessonDuration))
                                            .minute,
                                      );
                                      widget.onVisualLessonTimesChange(
                                          updatedLessonTimes);
                                    },
                                    headline: "When does this lesson start?",
                                  ),
                                );
                              },
                              child: Text(
                                DateFormat("HH:mm").format(DateTime(
                                  0,
                                  0,
                                  0,
                                  widget.visualLessonTimes[index][0].hour,
                                  widget.visualLessonTimes[index][0].minute,
                                )),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("-"),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showAdaptiveDialog(
                                  context: context,
                                  builder: (context) => CustomTimePicker(
                                    initialTime: widget.visualLessonTimes[index]
                                        [1],
                                    onTimeSelected: (time) {
                                      List<List<TimeOfDay>> updatedLessonTimes =
                                          widget.visualLessonTimes;
                                      updatedLessonTimes[index][1] = time;
                                      widget.onVisualLessonTimesChange(
                                          updatedLessonTimes);
                                    },
                                    headline: "When does this lesson end?",
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade300,
                                        Colors.orange.shade300,
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                DateFormat("HH:mm").format(DateTime(
                                  0,
                                  0,
                                  0,
                                  widget.visualLessonTimes[index][1].hour,
                                  widget.visualLessonTimes[index][1].minute,
                                )),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index == widget.visualLessonTimes.length - 1 &&
                        index != 0) //last lesson
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        color: Colors.redAccent,
                        onPressed: () {
                          widget.onVisualLessonTimesChange(
                            widget.visualLessonTimes
                                .sublist(0, index), // remove last lesson
                          );
                        },
                        tooltip: "Delete this lesson",
                      ),
                  ],
                ),
              );
            }),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () {
              showAdaptiveDialog(
                context: context,
                builder: (context) => CustomTimePicker(
                  initialTime: widget.visualLessonTimes[
                          widget.visualLessonTimes.length - 1]
                      [1], // Default to end of last lesson
                  onTimeSelected: (time) {
                    List<List<TimeOfDay>> updatedLessonTimes =
                        widget.visualLessonTimes;
                    updatedLessonTimes.add([
                      time,
                      time.add(Duration(minutes: widget.lessonDuration))
                    ]);
                    widget.onVisualLessonTimesChange(updatedLessonTimes);
                  },
                  headline: "When does this lesson start?",
                ),
              );
            },
            child: Text(
              "Add a new lesson",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
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
        ),
        const SizedBox(height: 16),
        _visualIndividualLessonTimeSelector()
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
