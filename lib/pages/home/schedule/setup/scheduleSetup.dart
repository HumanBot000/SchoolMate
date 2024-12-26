import 'package:flutter/material.dart';

import '../../Widgets/BottomNavBar.dart';

class ScheduleSetupPage extends StatefulWidget {
  const ScheduleSetupPage({super.key});

  @override
  State<ScheduleSetupPage> createState() => _ScheduleSetupPageState();
}

class _ScheduleSetupPageState extends State<ScheduleSetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HomeNavBar(
        currentIndex: 1,
      ),
      appBar: AppBar(
        title: const Text("Schedule Setup"),
      ),
      body: ListView(
        children: [
          Container(
            child: Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Schedule Setup",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Before you can start using the schedule, we need to know some last details about your day.",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
