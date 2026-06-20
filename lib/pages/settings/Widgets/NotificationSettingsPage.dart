import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/pages/settings/notifications/PreLessonNotificationSetup.dart';

import '../notifications/HomeworkReminderNotificationSetup.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              title: Text(l10n.preLessonNotificationsTitle),
              subtitle: Text(
                l10n.preLessonNotificationsSubtitle,
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
              title: Text(l10n.homeworkRemindersTitle),
              subtitle: Text(
                l10n.homeworkRemindersSubtitle,
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
