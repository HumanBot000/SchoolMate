import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/settings/homeworkReminders.dart';
import 'package:school_mate/API/supabase/settings/preLessonNotifications.dart';
import 'package:school_mate/pages/settings/notifications/preNotifications.dart';

//todo special notifications like: on weekends
class HomeworkReminderNotificationSetup extends StatelessWidget {
  const HomeworkReminderNotificationSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationSetup(
      title: 'Homework Reminders',
      itemSuffix: 'before a deadline',
      fetchSettings: () async {
        final list = await fetchHomeworkReminders();
        return list
            .map((e) => NotificationSetting(e[0] as String, e[1] as int))
            .toList();
      },
      updateSettings: (items) async {
        await updateHomeworkReminderSetup(
          items.map((e) => [e.unit, e.value]).toList(),
        );
      },
      validateSettings: (items) {
        return preNotificationListIsValid(
          items.map((e) => [e.unit, e.value]).toList(),
        );
      },
    );
  }
}
