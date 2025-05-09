import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_mate/util/notifications/schedule.dart';

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
}
