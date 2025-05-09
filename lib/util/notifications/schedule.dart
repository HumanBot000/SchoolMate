import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/util/notifications/debug.dart';
import 'package:timezone/timezone.dart' as tz;

import 'homework.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> clearAllScheduledNotifications() async {
  for (PendingNotificationRequest notification
      in await flutterLocalNotificationsPlugin.pendingNotificationRequests()) {
    if (notification.payload == "PreLessonNotification") {
      await flutterLocalNotificationsPlugin.cancel(notification.id);
    }
  }
  logger.i("Cleared all pre-lesson notifications");
}

Future<void> requestExactAlarmPermission() async {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

/// Updates the pre-lesson notifications for the current day (gets called with worker every day at 00:00)
Future<void> initNotificationPlugin() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // Handle foreground UI interactions here
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

Future<void> schedulePreLessonNotificationsForCurrentDay({
  required Future<dynamic> Function() fetchSchedule,
  required Future<List<List<dynamic>>> Function() preLessonNotificationsFetcher,
}) async {
  await initNotificationPlugin();
  await clearAllScheduledNotifications();
  await requestExactAlarmPermission();
  Schedule schedule = await fetchSchedule();
  List<List<dynamic>> preLessonNotifications =
      await preLessonNotificationsFetcher();
  if (kDebugMode) {
    await testPushMessages();
  }
  for (Lesson lesson in schedule.lessons) {
    if (lesson.temporalData.weekday != DateTime.now().weekday ||
        !lesson.temporalData.alternatingWeeks
            .contains(schedule.metadata.currentAlternatedWeek)) {
      continue;
    }
    for (List<dynamic> notification in preLessonNotifications) {
      var scheduledNotificationTime = lesson.temporalData.startDateTime;
      if (notification[0] == "seconds") {
        scheduledNotificationTime = scheduledNotificationTime
            .subtract(Duration(seconds: notification[1]));
      } else if (notification[0] == "minutes") {
        scheduledNotificationTime = scheduledNotificationTime
            .subtract(Duration(minutes: notification[1]));
      } else if (notification[0] == "hours") {
        scheduledNotificationTime = scheduledNotificationTime
            .subtract(Duration(hours: notification[1]));
      } else if (notification[0] == "days") {
        scheduledNotificationTime =
            scheduledNotificationTime.subtract(Duration(days: notification[1]));
      }

      if (scheduledNotificationTime.isBefore(DateTime.now())) {
        continue;
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch.hashCode & 0x7FFFFFFF,
        // Ensures a unique positive 32-bit integer
        lesson.name,
        lesson.location ?? "Your lesson starts soon!",
        tz.TZDateTime.from(scheduledNotificationTime.toUtc(), tz.UTC),
        const NotificationDetails(
            android: AndroidNotificationDetails('2', 'Pre-Lesson Notification',
                channelDescription:
                    'A notification that is sent every lesson on a set pre-time-interval',
                importance: Importance.max)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: "PreLessonNotification",
      );
      logger.i(
          "Scheduled pre-lesson notification at ${scheduledNotificationTime.toUtc()}");
    }
  }
}
