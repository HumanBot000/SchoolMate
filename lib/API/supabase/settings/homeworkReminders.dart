import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/main.dart';

Future<List<List<dynamic>>> fetchHomeworkReminders() async {
  dynamic response = await supabaseClient.client
      .schema("settings")
      .from("notifications")
      .select("homework_reminders")
      .eq("user_id", await getUserID())
      .single();
  response = response["homework_reminders"];
  List<List<dynamic>> notifications = [];
  if (response == null || response.isEmpty) {
    return [];
  }
  for (var notification in response) {
    notifications.add(
        [notification["unit"].toString().toLowerCase(), notification["value"]]);
  }
  return notifications;
}

Future<void> updateHomeworkReminderSetup(
    List<List<dynamic>> notifications) async {
  List<Map<String, dynamic>> encodedNotifications =
      notifications.map((notification) {
    return {"unit": notification[0], "value": notification[1]};
  }).toList();

  await supabaseClient.client.schema("settings").from("notifications").upsert(
    {"user_id": await getUserID(), "homework_reminders": encodedNotifications},
    onConflict: "user_id",
  );
}
