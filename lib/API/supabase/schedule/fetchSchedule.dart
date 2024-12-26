import 'package:app/Classes/ScheduleMetadata.dart';

import '../../../main.dart';
import '../auth/userData.dart';

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
