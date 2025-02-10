import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';

Future<Subject> createSubject(Subject subject) async {
  if (subject.teacher.id < 0) {
    throw Exception(
        "The provided Teacher element wasn't created via the DB->Teacher factory and therefore hasn't an ID. It can't be inserted without an ID.");
  }
  // Took me ages to figure out the Flutter Color Class uses doubles from 0 to 1 instead of 0 to 255
  // Update: Took me way to long to figure out that the Flutter Color Class uses AARRGGBB instead of RRGGBBAA...
  final colorHex =
      "${255.toRadixString(16).padLeft(2, '0')}" //Ensures that the color is opaque
      "${(subject.color.r * 255).toInt().toRadixString(16).padLeft(2, '0')}"
      "${(subject.color.g * 255).toInt().toRadixString(16).padLeft(2, '0')}"
      "${(subject.color.b * 255).toInt().toRadixString(16).padLeft(2, '0')}";

  final response = await supabaseClient!.client
      .schema("schedule")
      .from("subjects")
      .insert({
        "name": subject.name,
        "color": colorHex,
        "user_id": await getUserID(),
        "teacher": subject.teacher.id
      })
      .select()
      .single();
  return Subject.fromJson(response);
}

Future<void> deleteSubject(Subject subject) async {
  if (subject.id < 0) {
    throw Exception(
        "The provided Subject element wasn't created via the DB->Subject factory and therefore hasn't an ID. It can't be deleted without an ID.");
  }
  await supabaseClient!.client
      .schema("schedule")
      .from("subjects")
      .delete()
      .eq("user_id", await getUserID())
      .eq("subject_id", subject.id);
}

Future<Subject> editSubject(Subject oldSubject, Subject newSubject) async {
  if (oldSubject.id < 0) {
    throw Exception(
        "The provided Subject element wasn't created via the DB->Subject factory and therefore hasn't an ID. It can't be updated without an ID.");
  }
  final colorHex =
      "${255.toRadixString(16).padLeft(2, '0')}" //Ensures that the color is opaque
      "${(newSubject.color.r * 255).toInt().toRadixString(16).padLeft(2, '0')}"
      "${(newSubject.color.g * 255).toInt().toRadixString(16).padLeft(2, '0')}"
      "${(newSubject.color.b * 255).toInt().toRadixString(16).padLeft(2, '0')}";
  final response = await supabaseClient!.client
      .schema("schedule")
      .from("subjects")
      .update({
        "name": newSubject.name,
        "color": colorHex,
        "teacher": newSubject.teacher.id
      })
      .eq("user_id", await getUserID())
      .eq("subject_id", oldSubject.id)
      .select()
      .single();
  return Subject.fromJson(response);
}

Future<Subject> fetchSubjectByID(int id) async {
  final response = await supabaseClient!.client
      .schema("schedule")
      .from("subjects")
      .select()
      .eq("user_id", await getUserID())
      .eq("subject_id", id)
      .single();
  return Subject.fromJson(response);
}
