import 'dart:convert';

import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/main.dart';

Future<List<List<dynamic>>> fetchPreLessonNotifications() async {
  final response = await supabaseClient.client
      .schema("settings")
      .from("notifications")
      .select("pre_lesson_notifications")
      .eq("user_id", await getUserID());
  List<List<dynamic>> notifications = [];
  for (var notification in response) {
    notification = jsonDecode(notification["notifications"]);
    notifications.add([
      notification["unit"].toString().toLowerCase(),
      int.tryParse(notification["value"])
    ]);
  }
  return notifications;
}
