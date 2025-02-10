import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/main.dart';

Future<List<List<dynamic>>> fetchPreLessonNotifications() async {
  final response = await supabaseClient!.client
      .schema("settings")
      .from("notifications")
      .select("pre_lesson_notifications")
      .eq("user_id", await getUserID())
      .single();
  List<List<dynamic>> notifications = [];
  if (response.isEmpty) {
    return [];
  }
  for (var notification in response["pre_lesson_notifications"]) {
    notifications.add(
        [notification["unit"].toString().toLowerCase(), notification["value"]]);
  }
  return notifications;
}

Future<void> updatePreLessonNotifications(
    List<List<dynamic>> notifications) async {
  List<Map<String, dynamic>> encodedNotifications =
      notifications.map((notification) {
    return {"unit": notification[0], "value": notification[1]};
  }).toList();

  await supabaseClient!.client.schema("settings").from("notifications").upsert(
    {
      "user_id": await getUserID(),
      "pre_lesson_notifications": encodedNotifications
    },
    onConflict: "user_id",
  );
}

bool preLessonNotificationListIsValid(List<List<dynamic>> notifications) {
  for (var notification in notifications) {
    // Check if the inner list has exactly two elements
    if (notification.length != 2) {
      return false;
    }

    // Check if the first element is a String and is one of the allowed values
    if (notification[0] is! String ||
        !["seconds", "minutes", "hours"].contains(notification[0])) {
      return false;
    }

    // Check if the second element is a non-negative integer
    if (notification[1] is! int || notification[1] < 0) {
      return false;
    }
  }
  return true;
}
