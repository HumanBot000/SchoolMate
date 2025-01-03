import 'package:school_mate/Classes/persons/Gender.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/main.dart';

import '../auth/userData.dart';

Future<List<Teacher>> fetchTeachers() async {
  final response = await supabaseClient.client
      .schema("schedule")
      .from("teachers")
      .select()
      .eq("used_by", await getUserID());
  return response.map((teacher) => Teacher.fromJson(teacher)).toList();
}

Future<Teacher> addTeacher(String name, Gender gender) async {
  try {
    final response = await supabaseClient.client
        .schema("schedule")
        .from("teachers")
        .insert({
          "used_by": await getUserID(),
          "name": name,
          "gender": gender.genderLetter,
          "form_of_address": gender.address
        })
        .select()
        .single();
    return Teacher(response["name"], gender, response["id"]);
  } catch (e) {
    logger.e(e);
    rethrow;
  }
}

Future<void> deleteTeacher(Teacher teacher) async {
  if (teacher.id < 0) {
    throw Exception(
        "The provided Teacher element wasn't created via the DB->Teacher factory and therefore hasn't an ID. It can't be deleted without an ID.");
  }
  await supabaseClient.client
      .schema("schedule")
      .from("teachers")
      .delete()
      .eq("used_by", await getUserID())
      .eq("id", teacher.id);
}

Future<Teacher> updateTeacher(Teacher oldTeacher, Teacher newTeacher) async {
  if (oldTeacher.id < 0) {
    throw Exception(
        "The provided Teacher element wasn't created via the DB->Teacher factory and therefore hasn't an ID. It can't be updated without an ID.");
  }
  final response = await supabaseClient.client
      .schema("schedule")
      .from("teachers")
      .update({
        "name": newTeacher.name,
        "gender": newTeacher.gender.genderLetter,
        "form_of_address": newTeacher.gender.address
      })
      .eq("used_by", await getUserID())
      .eq("id", oldTeacher.id)
      .select()
      .single();
  return Teacher(response["name"], newTeacher.gender, response["id"]);
}
