import 'package:flutter/material.dart';
import 'package:school_mate/pages/home/schedule/start.dart';

Container buildNoSubjectsForGradingNoticePage(BuildContext context) =>
    Container(
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
            child: Text("You have no subjects",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              Text(
                  "Create some subjects via the schedule page to start tracking marks!",
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>
                      const ScheduleNavigationIntersection()));
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.grey),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, color: Colors.white),
                SizedBox(width: 8),
                Text("Take me there", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
