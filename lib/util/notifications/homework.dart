import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/util/notifications/schedule.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../API/supabase/schedule/schedule.dart';
import '../../API/supabase/settings/homeworkReminders.dart';
import '../../main.dart';

const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  '3',
  'Homework Notification',
  channelDescription:
      'A notification that is sent when a homework task needs to be finished',
  importance: Importance.defaultImportance,
  priority: Priority.defaultPriority,
  actions: <AndroidNotificationAction>[
    AndroidNotificationAction(
      'mark_complete',
      'Mark as Complete',
      showsUserInterface: false, // do not startup the Apps UI
    ),
    AndroidNotificationAction(
      'remind',
      'Remind me later',
      showsUserInterface: false,
    ),
  ],
);

const NotificationDetails notificationDetails = NotificationDetails(
  android: androidNotificationDetails,
);

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  await Supabase.initialize(
    // when the app runs in background we need to initialize supabase manually because late variables won't work. Not an optimal solution, but couldn't find another way
    url: "https://nopekgcnoeblprvjjpvv.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vcGVrZ2Nub2VibHBydmpqcHZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQwMTU4MzAsImV4cCI6MjA0OTU5MTgzMH0.Ogd1g9yMwaMD5yVhniTP7poxsHQ7c27GkXgFS9zzZi8", //public key
  );
  final supabaseClient = Supabase.instance.client;
  if (notificationResponse.actionId == 'mark_complete') {
    if (notificationResponse.payload != null) {
      markTaskCompletedPerID(supabaseClient,
          int.parse(notificationResponse.payload!.split(":")[1]));
    }
  }

  if (notificationResponse.actionId == 'remind') {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '3',
      'Homework Notification',
      channelDescription:
          'A notification that is sent when a homework task needs to be finished',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'remind',
          'Remind me later',
          showsUserInterface: false,
        ),
      ],
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch.hashCode & 0x7FFFFFFF,
      "Homework Reminder",
      "This is your reminder to complete this task",
      tz.TZDateTime.from(
        DateTime.now().add(const Duration(minutes: 1)).toUtc(),
        tz.UTC,
      ),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

Future<void> clearAllHomeworkNotifications() async {
  for (PendingNotificationRequest notification
      in await flutterLocalNotificationsPlugin.pendingNotificationRequests()) {
    if (notification.payload == null) {
      continue;
    }
    if (notification.payload!.startsWith("HomeworkReminder")) {
      await flutterLocalNotificationsPlugin.cancel(notification.id);
    }
  }
  logger.i("Cleared all homework notifications");
}

Future<void> updateHomeworkNotifications(List<Homework> homeworks) async {
  await initNotificationPlugin();
  await requestExactAlarmPermission();
  await clearAllHomeworkNotifications();
  for (Homework homework in homeworks.where((hw) => !hw.isCompleted)) {
    DateTime dueDate = homework.dueDate!;
    // If the task is a handIn task, it's exact time will be already set.
    if (!homework.handIn) {
      Schedule schedule = await fetchSchedule();
      dueDate = DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
        schedule.metadata.firstLessonTime.hour,
        schedule.metadata.firstLessonTime.minute,
      );
    }
    if (homework.handIn) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          DateTime.now().millisecondsSinceEpoch +
                  Random().nextInt(1000).hashCode &
              0x7FFFFFFF,
          homework.title,
          "Get yourself ready, this task needs to be submitted in 10 minutes.",
          tz.TZDateTime.from(
            dueDate.subtract(const Duration(minutes: 10)).toUtc(),
            tz.UTC,
          ),
          const NotificationDetails(
              // This notification is a top priority delivery! The user relies on us!
              android: AndroidNotificationDetails(
            '4',
            'Homework Notification (High Priority)',
            channelDescription:
                'A notification that is sent when a homework task needs to be finished',
            importance: Importance.max,
            priority: Priority.max,
            enableLights: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            subText: "This task needs your attention right now!",
            ledColor: Colors.red,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'mark_complete',
                'Mark as Complete',
                showsUserInterface: false, // do not startup the Apps UI
              ),
              AndroidNotificationAction(
                'remind',
                'Remind me later',
                showsUserInterface: false,
              ),
            ],
          )),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: "HomeworkReminder:${homework.taskID.toString()}");
      logger.i(
          "Scheduled homework submission reminder for ${homework.title} at ${DateFormat("dd.MM.yyyy").format(homework.dueDate!)}");
    }
    List<dynamic> reminders = await fetchHomeworkReminders();
    for (List<dynamic> reminder in reminders) {
      DateTime reminderDate = dueDate;
      if (reminder[0] == "seconds") {
        reminderDate = reminderDate.subtract(Duration(seconds: reminder[1]));
      } else if (reminder[0] == "minutes") {
        reminderDate = reminderDate.subtract(Duration(minutes: reminder[1]));
      } else if (reminder[0] == "hours") {
        reminderDate = reminderDate.subtract(Duration(hours: reminder[1]));
      } else if (reminder[0] == "days") {
        reminderDate = reminderDate.subtract(Duration(days: reminder[1]));
      }
      if (reminderDate.isBefore(DateTime.now())) {
        continue;
      }
      await flutterLocalNotificationsPlugin.zonedSchedule(
          DateTime.now().millisecondsSinceEpoch +
                  Random().nextInt(1000).hashCode &
              0x7FFFFFFF,
          homework.title,
          "This task needs to be finished by ${DateFormat("dd.MM.yyyy").format(dueDate)}",
          tz.TZDateTime.from(
            reminderDate.toUtc(),
            tz.UTC,
          ),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: "HomeworkReminder:${homework.taskID.toString()}");
      logger.i(
          "Scheduled homework reminder for ${homework.title} at ${DateFormat("dd.MM.yyyy").format(reminderDate)}");
    }
  }

  logger.i("Scheduled homework notifications");
}
