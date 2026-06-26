import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';
import 'package:school_mate/l10n/app_localizations.dart';

void onTap(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final data = await fetchSchedule();

    if (!context.mounted) return;
    Navigator.of(context).pop();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleSetupPage(
        headerTitle: data == null
            ? l10n.defaultScheduleSetupHeader
            : l10n.scheduleCorruptionWarning,
        existingSchedule: data,
      ),
    ));
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context).pop(); // Remove loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.somethingWentWrong),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
