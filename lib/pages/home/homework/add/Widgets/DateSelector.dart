import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/util/dates.dart';

class HomeworkDateSelector extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const HomeworkDateSelector(
      {super.key, required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          final newSelectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: selectedDate ?? DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)));
          if (newSelectedDate == null) return;
          onDateSelected(newSelectedDate);
        },
        child: ListTile(
          title: Text(selectedDate == null
              ? "Date"
              : DateFormat("dd.MM.yyyy").format(selectedDate!)),
          subtitle: Text(
            selectedDate == null
                ? "When does this homework need to be completed?"
                : "In ${getVisualTimeTillDate(DateTime.now(), selectedDate!)[0]} ${getVisualTimeTillDate(DateTime.now(), selectedDate!)[1]}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          leading: const Icon(Icons.calendar_month),
        ),
      ),
    );
  }
}
