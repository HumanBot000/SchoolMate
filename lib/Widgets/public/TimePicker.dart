// I had no clue in what direction I want to go, so I used AI for the first layout iteration
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/util/extensions/dates.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;
  final String headline;
  final LinearGradient gradient;

  const CustomTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
    this.headline = "Pick a Time",
    this.gradient =
        const LinearGradient(colors: [Colors.lightBlue, Color(0x283593FF)]),
  });

  @override
  Widget build(BuildContext context) {
    TimeOfDay selectedTime = initialTime;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              headline,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _TimePickerDial(
              initialTime: initialTime,
              gradient: gradient,
              onTimeChanged: (time) {
                selectedTime = time;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    onTimeSelected(selectedTime);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Set Time"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerDial extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeChanged;
  final Gradient gradient;

  const _TimePickerDial({
    required this.initialTime,
    required this.onTimeChanged,
    required this.gradient,
  });

  @override
  State<_TimePickerDial> createState() => _TimePickerDialState();
}

class _TimePickerDialState extends State<_TimePickerDial> {
  late TimeOfDay _selectedTime;
  final FixedExtentScrollController _minuteScrollController =
      FixedExtentScrollController();
  final FixedExtentScrollController _hourScrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToInitialTime());
  }

  void _jumpToInitialTime() {
    // 40 is the item extent
    _minuteScrollController.jumpTo(
      _minuteScrollController.position.minScrollExtent +
          _selectedTime.minute * 40,
    );
    _hourScrollController.jumpTo(
      _hourScrollController.position.minScrollExtent + _selectedTime.hour * 40,
    );
  }

  void _updateTime(int hour, int minute) {
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
      widget.onTimeChanged(_selectedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration:
              BoxDecoration(shape: BoxShape.circle, gradient: widget.gradient),
          child: Center(
            child: Text(
              DateFormat('HH:mm').format(_selectedTime.toDateTime()),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                  const Text("Hours",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 120,
                    child: ListWheelScrollView.useDelegate(
                      controller: _hourScrollController,
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        _updateTime(index, _selectedTime.minute);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          return Center(
                            child: Text(
                              index.toString(),
                              style: index == _selectedTime.hour
                                  ? const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold)
                                  : const TextStyle(fontSize: 24),
                            ),
                          );
                        },

                        childCount: 24, // Hours 0-23
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text("Minutes",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 120,
                    child: ListWheelScrollView.useDelegate(
                      controller: _minuteScrollController,
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        _updateTime(_selectedTime.hour, index);
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: index == _selectedTime.minute
                                  ? const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold)
                                  : const TextStyle(fontSize: 24),
                            ),
                          );
                        },
                        childCount: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
