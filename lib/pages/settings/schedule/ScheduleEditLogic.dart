import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';

void onTap(BuildContext context) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final data = await fetchSchedule();

    Navigator.of(context).pop();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleSetupPage(
        headerTitle: data == null
            ? "Before you can start using the schedule, we need to know some last details about your day."
            : "Please note, that this might corrupt your current schedule. We highly encourage you to clear all lessons before continuing.",
        existingSchedule: data,
      ),
    ));
  } catch (e) {
    Navigator.of(context).pop(); // Remove loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Something went wrong. Please try again."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
