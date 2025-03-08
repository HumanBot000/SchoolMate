import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

class GradingSystemDropdown extends StatelessWidget {
  final GradingSystem? selectedGradingSystem;
  final ValueChanged<GradingSystem?> onChanged;

  const GradingSystemDropdown({
    super.key,
    required this.selectedGradingSystem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final gradingSystems = [
      GradingSystem(range: ["1", "6"], modifiers: ["+", "-"], examTypes: []),
      GradingSystem(range: ["15", "0"], modifiers: [], examTypes: []),
      GradingSystem(range: ["15", "0"], modifiers: ["."], examTypes: []),
      GradingSystem(range: ["1", "6"], modifiers: ["."], examTypes: []),
      GradingSystem(range: ["100", "0"], modifiers: [], examTypes: []),
      GradingSystem(range: ["1", "5"], modifiers: ["."], examTypes: []),
      GradingSystem(range: ["6", "1"], modifiers: ["."], examTypes: []),
      GradingSystem(range: ["A", "F"], modifiers: ["+", "-"], examTypes: []),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: DropdownButtonFormField<GradingSystem>(
        value: gradingSystems.firstWhere(
          (gs) =>
              gs.range == selectedGradingSystem?.range &&
              gs.modifiers == selectedGradingSystem?.modifiers,
          orElse: () => gradingSystems.first,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          hintText: "Select Grading System",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2),
          ),
        ),
        isExpanded: true,
        items: gradingSystems.map((gs) {
          String label = "${gs.range.first}-${gs.range.last}";
          if (gs.modifiers.contains("+") || gs.modifiers.contains("-")) {
            label += " (±)";
          } else if (gs.modifiers.contains(".")) {
            label += " (With Decimals)";
          }
          return DropdownMenuItem(
            value: gs,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          );
        }).toList(),
      ),
    );
  }
}
