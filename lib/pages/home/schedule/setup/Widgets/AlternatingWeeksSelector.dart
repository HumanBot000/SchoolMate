import 'package:app/Widgets/public/GradientButton.dart';
import 'package:app/util/dates.dart';
import 'package:flutter/material.dart';

class AlternatingWeeksSelector extends StatefulWidget {
  final int alternatingWeeksCount;
  final int activePage;
  final Function(int) onActivePageChange;
  final int selectedAlternatingWeek;
  final Function(int, int) onWeekChange;

  const AlternatingWeeksSelector(
      {super.key,
      required this.alternatingWeeksCount,
      required this.activePage,
      required this.onActivePageChange,
      required this.selectedAlternatingWeek,
      required this.onWeekChange});

  @override
  State<AlternatingWeeksSelector> createState() =>
      _AlternatingWeeksSelectorState();
}

class _AlternatingWeeksSelectorState extends State<AlternatingWeeksSelector> {
  late int _scrollViewSelectedWeek;

  @override
  void initState() {
    super.initState();
    _scrollViewSelectedWeek = widget.selectedAlternatingWeek;
  }

  Widget _deactivatedPage() {
    return Row(
      children: [
        Flexible(
            child: InkWell(
          onTap: () => widget.onWeekChange(0, 0),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                shape: BoxShape.rectangle,
                color: widget.alternatingWeeksCount == 0
                    ? Colors.green
                    : Colors.grey),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A Weeks"),
              ],
            ),
          ),
        )),
        Flexible(
            child: InkWell(
          onTap: () => widget.onWeekChange(1, widget.selectedAlternatingWeek),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                shape: BoxShape.rectangle,
                color: widget.alternatingWeeksCount == 1
                    ? Colors.yellow
                    : Colors.grey),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "A/B Weeks",
                  style: widget.alternatingWeeksCount == 1
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors
                              .black) // White text on yellow base isn't readable
                      : null,
                ),
              ],
            ),
          ),
        )),
        Flexible(
            child: InkWell(
          onTap: () => widget.onWeekChange(2, widget.selectedAlternatingWeek),
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                shape: BoxShape.rectangle,
                color: widget.alternatingWeeksCount == 2
                    ? Colors.red
                    : Colors.grey),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A/B/C Weeks"),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void _showCurrentAlternatingWeekSelectorDialog() {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      "What type of week is the current one?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const Text("Week",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 120,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                _scrollViewSelectedWeek = index;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                final isSelected =
                                    index == _scrollViewSelectedWeek;
                                return Center(
                                  child: Text(
                                    ["A", "B", "C"][index],
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              },
                              childCount: widget.alternatingWeeksCount + 1,
                            ),
                          ),
                        ),
                      ],
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
                            Navigator.of(context).pop();
                            widget.onWeekChange(widget.alternatingWeeksCount,
                                _scrollViewSelectedWeek);
                          },
                          child: const Text("Select"),
                        ),
                      ],
                    ),
                  ])));
        });
  }

  int _getWeekType(DateTime currentDate, int currentWeekType,
      int totalWeekTypes, DateTime newDate) {
    // This function is only for the visual validation. The actual week type will be calculated in a postgresql function, that's also why this function isn't in a separate file, because it's only used one time
    //totalWeekTypes is 0-indexed
    totalWeekTypes += 1;
    int dayDifference = newDate.difference(currentDate).inDays;
    int weekDifference = (dayDifference / 7).floor();
    int newWeekType = (currentWeekType + weekDifference) % totalWeekTypes;
    if (newWeekType < 0) {
      newWeekType = (newWeekType + totalWeekTypes) % totalWeekTypes;
    }
    return newWeekType;
  }

  Widget _activatedPage() {
    return Column(
      children: [
        Text(
          "Which week is today?",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Text("We will calculate the following weeks for you!"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedGradientButton(
              borderRadius: BorderRadius.circular(12),
              onPressed: () => _showCurrentAlternatingWeekSelectorDialog(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.calendar_month, color: Colors.white),
                ],
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: ListView.builder(
            itemBuilder: (context, index) {
              // Return the visual data for the last,current and next week
              return Text(
                "CW: ${getIsoWeekNumber(DateTime.now().add(Duration(days: (index - 1) * 7)))} ${[
                  "A",
                  "B",
                  "C"
                ][_getWeekType(DateTime.now(), widget.selectedAlternatingWeek, widget.alternatingWeeksCount, DateTime.now().add(Duration(days: (index - 1) * 7)))]}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        index == 1 ? Colors.greenAccent.shade100 : Colors.white,
                    fontWeight: FontWeight.bold),
              );
            },
            itemCount: 3,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:
            widget.activePage == 2 ? null : () => widget.onActivePageChange(2),
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
                if (widget.activePage == 2) _activatedPage(),
              ],
            ),
          ),
        ));
  }
}
