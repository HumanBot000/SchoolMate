import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/ScheduleMetadata.dart';
import 'package:school_mate/main.dart';

Future<dynamic> fetchSchedule() async {
  final response = await supabaseClient.client
      .schema("schedule")
      .from("schedule_metadata_with_current_week")
      .select()
      .eq("user_id", await getUserID());
  if (response.isEmpty) {
    return ""; // Can't return null because FutureBuilder thinks it didn't finish yet
  }

  return Schedule(ScheduleMetadata.fromSupabaseDBResponse(response.single));
}
