import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/API/supabase/schedule/subjects.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

class Homework {
  final int taskID;
  final String title;
  final String note;
  final bool isCompleted;
  final DateTime? dueDate;
  final bool handIn;
  final List<Uri> attachments;
  final DateTime? createdAt;
  final Subject subject;

  Homework(this.subject, this.taskID, this.title,
      {this.isCompleted = false,
      this.note = "",
      this.attachments = const [],
      this.handIn = false,
      this.dueDate,
      this.createdAt});

  static Future<Homework> fromJson(Map<String, dynamic> json) async {
    List<Uri> parsedAttachments = [];
    if (json["attachments"] != null) {
      parsedAttachments = (json["attachments"] as List<dynamic>)
          .map((e) => Uri.parse(e.toString()))
          .toList();
    }

    return Homework(
      await fetchSubjectByID(json["subject_id"]),
      json["homework_id"],
      json["title"],
      isCompleted: json["completed"],
      note: json["note"],
      attachments: parsedAttachments,
      handIn: json["submit"],
      dueDate: json["complete_due"] != null
          ? DateTime.parse(json["complete_due"]).toLocal()
          : null,
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
    );
  }

  Future<void> toggleCompletion() async {
    await changeTaskCompletionStatus(this);
  }
}
