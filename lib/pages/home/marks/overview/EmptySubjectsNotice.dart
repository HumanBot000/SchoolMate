import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

Container buildNoSubjectsForGradingNoticePage(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(l10n.noSubjectsTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: [
            Text(l10n.createSubjectsToTrackMarks,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ScheduleNavigationIntersection()));
          },
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.grey),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month, color: Colors.white),
              const SizedBox(width: 8),
              Text(l10n.takeMeThere,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    ),
  );
}
