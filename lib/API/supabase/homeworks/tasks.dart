import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/API/supabase/auth/userData.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

Future<Homework> addTask(String title, bool handIn, Subject subject,
    {DateTime? dueDate,
    TimeOfDay? handInTime,
    String note = "",
    bool completed = false,
    List<Uri> attachments = const []}) async {
  if (handIn) {
    if (dueDate == null || handInTime == null) {
      throw ArgumentError(
          'If handIn is true, a dueDate and handInTime must be provided.');
    }
    dueDate =
        dueDate.copyWith(hour: handInTime.hour, minute: handInTime.minute);
  }
  final response = await supabaseClient.client
      .schema("homework")
      .from("tasks")
      .insert({
        "user_id": await getUserID(),
        "subject_id": subject.id,
        "completed": completed,
        "complete_due": dueDate == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss").format(dueDate.toUtc()),
        "submit": handIn,
        "title": title,
        "note": note,
        "attachments": attachments,
      })
      .select()
      .single();
  return Homework.fromJson(response);
}

Future<List<Homework>> fetchHomeworks() async {
  final response = await supabaseClient.client
      .schema("homework")
      .from("tasks")
      .select()
      .eq("user_id", await getUserID());
  List<Homework> taskList = [];
  for (var task in response) {
    taskList.add(await Homework.fromJson(task));
  }
  return taskList;
}

Future<void> changeTaskCompletionStatus(Homework task) async {
  await supabaseClient.client
      .schema("homework")
      .from("tasks")
      .update({"completed": !task.isCompleted})
      .eq("user_id", await getUserID())
      .eq("homework_id", task.taskID);
}

// specially designed to run self-sufficient and in the background
Future<void> markTaskCompletedPerID(
    SupabaseClient supabaseClient, int taskID) async {
  await supabaseClient
      .schema("homework")
      .from("tasks")
      .update({"completed": true})
      .eq("user_id", supabaseClient.auth.currentUser!.id)
      .eq("homework_id", taskID);
}

Future<void> deleteTask(Homework task) async {
  await supabaseClient.client
      .schema("homework")
      .from("tasks")
      .delete()
      .eq("user_id", await getUserID())
      .eq("homework_id", task.taskID);
}

Future<Homework> updateTask(
    Homework oldTask, String title, bool handIn, Subject subject,
    {DateTime? dueDate,
    TimeOfDay? handInTime,
    String note = "",
    bool completed = false,
    List<Uri> attachments = const []}) async {
  if (handIn) {
    if (dueDate == null || handInTime == null) {
      throw ArgumentError(
          'If handIn is true, a dueDate and handInTime must be provided.');
    }
    dueDate =
        dueDate.copyWith(hour: handInTime.hour, minute: handInTime.minute);
  }
  final response = await supabaseClient.client
      .schema("homework")
      .from("tasks")
      .update({
        "user_id": await getUserID(),
        "subject_id": subject.id,
        "completed": completed,
        "complete_due": dueDate == null
            ? null
            : DateFormat("yyyy-MM-dd HH:mm:ss").format(dueDate.toUtc()),
        "submit": handIn,
        "title": title,
        "note": note,
        "attachments": attachments,
      })
      .eq("user_id", await getUserID())
      .eq("homework_id", oldTask.taskID)
      .select()
      .single();
  return Homework.fromJson(response);
}
