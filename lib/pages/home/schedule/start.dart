import 'package:app/pages/home/schedule/setup/scheduleSetup.dart'
    as schedule_setup;
import 'package:flutter/material.dart';

import '../../../API/supabase/schedule/fetchSchedule.dart';
import '../Widgets/BottomNavBar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

FutureBuilder scheduleExistsNavigation(BuildContext context) => FutureBuilder(
    future: fetchSchedule(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const schedule_setup.ScheduleSetupPage(),
          ));
        }
      } else if (snapshot.hasError) {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Something went wrong. Please try again."),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ));
        throw snapshot.error as Exception;
      }

      return const Placeholder();
    });

class _SchedulePageState extends State<SchedulePage> {
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
