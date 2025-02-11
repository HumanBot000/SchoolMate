import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_mate/util/notifications/schedule.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> testPushMessages() async {
  await flutterLocalNotificationsPlugin.show(
    0,
    "Debug Push Notification",
    "This is a debug push notification",
    const NotificationDetails(
        android: AndroidNotificationDetails('1', 'Debug Push Notification',
            channelDescription:
                'A notification that is sent every lesson on a set pre-time-interval',
            importance: Importance.max)),
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Debug Push Notification",
      "This is a debug scheduled push notification",
      tz.TZDateTime.from(
          DateTime.now().add(const Duration(minutes: 1)).toUtc(), tz.UTC),
      const NotificationDetails(
          android: AndroidNotificationDetails('3', 'Pre-Lesson Notification',
              channelDescription:
                  'A notification that is sent every lesson on a set pre-time-interval',
              importance: Importance.max)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
