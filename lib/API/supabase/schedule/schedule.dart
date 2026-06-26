import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Classes/schedule/ScheduleMetadata.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';

Future<Schedule?> fetchSchedule() async {
  final metadata = await supabaseClient.client
      .schema("schedule")
      .from("schedule_metadata_with_current_week")
      .select()
      .eq("user_id", await getUserID());
  if (metadata.isEmpty) {
    return null;
  }

  final subjects = await supabaseClient.client
      .schema("schedule")
      .from("subjects")
      .select()
      .eq("user_id", await getUserID());
  List<Subject> subjectList = [];
  for (var subject in subjects) {
    subjectList.add(await Subject.fromJson(subject));
  }

  final lessons = await supabaseClient.client
      .schema("schedule")
      .from("lessons")
      .select()
      .eq("user_id", await getUserID());

  List<Lesson> lessonList = [];
  for (var lesson in lessons) {
    lessonList.add(Lesson.fromJson(lesson, subjectList));
  }

  return Schedule(ScheduleMetadata.fromSupabaseDBResponse(metadata.single),
      subjectList, lessonList);
}
