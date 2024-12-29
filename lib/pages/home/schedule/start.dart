import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/schedule/fetchSchedule.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/schedule/page/Schedule.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart'
    as schedule_setup;

class ScheduleNavigationIntersection extends StatefulWidget {
  const ScheduleNavigationIntersection({super.key});

  @override
  State<ScheduleNavigationIntersection> createState() =>
      _ScheduleNavigationIntersectionState();
}

FutureBuilder scheduleExistsNavigation(BuildContext context) => FutureBuilder(
    future: fetchSchedule(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasData) {
        if (snapshot.data is String && snapshot.data!.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Wait for the build to finish
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const schedule_setup.ScheduleSetupPage(),
            ));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SchedulePage(),
                  )));
        }
      } else if (snapshot.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Something went wrong. Please try again."),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ));
        throw snapshot.error is Exception
            ? snapshot.error as Exception
            : Exception(snapshot.error.toString());
      }

      return const Placeholder();
    });

class _ScheduleNavigationIntersectionState
    extends State<ScheduleNavigationIntersection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HomeNavBar(
        currentIndex: 1,
      ),
      body: scheduleExistsNavigation(context),
    );
  }
}
