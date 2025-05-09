import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/pages/settings/notifications/PreLessonNotificationSetup.dart';

import '../notifications/HomeworkReminderNotificationSetup.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Lottie.asset(
              'assets/animations/running_time.json',
              alignment: Alignment.topCenter,
              fit: BoxFit.contain,
            ),
          ),
        ),
        ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("Pre-Lesson Notifications"),
              subtitle: Text(
                "Get notified before a lesson yo you don't have to lookup the location",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PreLessonNotificationSetup(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Homework Reminders"),
              subtitle: Text(
                "Decide how often and when you want to get reminded about open homework",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const HomeworkReminderNotificationSetup(),
                ));
              },
            )
          ],
        ),
      ],
    );
  }
}
