import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart'
    as fetch_schedule;
import 'package:school_mate/API/supabase/setup.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/util/NavigatorTree.dart';
import 'package:school_mate/util/notifications/homework.dart';
import 'package:school_mate/util/notifications/schedule.dart';
import 'package:school_mate/util/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'API/supabase/homeworks/tasks.dart';
import 'API/supabase/settings/preLessonNotifications.dart';

late final Supabase supabaseClient;
final logger = Logger();
late final SharedPreferences prefs;
final NavigationTreeObserver navigatorTreeObserver = NavigationTreeObserver();

/// Callback function that will be executed at midnight
@pragma('vm:entry-point')
Future<void> scheduleTaskCallback(int id) async {
  logger.d("Executing scheduled task in background isolate");

  // 1. Initialize Supabase client for this isolate
  try {
    await initializeSupabase();
  } catch (e) {
    logger.e("Failed to initialize Supabase in background: $e");
  }

  // 2. Check if a user is logged in before fetching data
  final currentUser = supabaseClient.client.auth.currentUser;
  if (currentUser == null) {
    logger.i("No user logged in. Skipping background scheduled task.");
  } else {
    try {
      await schedulePreLessonNotificationsForCurrentDay(
        fetchSchedule: fetch_schedule.fetchSchedule,
        preLessonNotificationsFetcher: fetchPreLessonNotifications,
      );
      await updateHomeworkNotifications(await fetchHomeworks());
      logger.i("Background scheduled task completed successfully.");
    } catch (e) {
      logger.e("Error executing scheduled task operations: $e");
    }
  }

  // 3. Always schedule the next day's alarm to keep the cycle alive
  DateTime now = DateTime.now();
  DateTime nextMidnight = now.add(const Duration(days: 1)).subtract(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond));
  await AndroidAlarmManager.oneShotAt(nextMidnight, 0, scheduleTaskCallback,
      exact: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      alarmClock: true);
}

Future<void> scheduleDailyTask() async {
  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();
  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.oneShotAt(
      DateTime.now().add(const Duration(seconds: 5)), 0, scheduleTaskCallback,
      exact: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
      alarmClock: true);
  logger.i("Scheduled daily task");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  prefs = await SharedPreferences.getInstance();
  var success = await AndroidAlarmManager.initialize();
  logger.i("Alarm manager initialized with ${success ? "success" : "failure"}");
  await scheduleDailyTask();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'SchoolMate',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A7BD5),
          brightness: Brightness.dark,
        ).copyWith(
            surface: const Color(0xFF2B2B2B), secondary: Colors.greenAccent),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Colors.white, fontSize: 30),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2B2B2B),
          iconTheme: IconThemeData(color: Color(0xFF3A7BD5)),
          titleTextStyle: TextStyle(color: Color(0xFF3A7BD5), fontSize: 20),
          centerTitle: true,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF3A7BD5),
        ),
        scaffoldBackgroundColor: const Color(0xFF2B2B2B),
      ),
    );
  }
}
