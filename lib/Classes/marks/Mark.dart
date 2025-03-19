import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

class Mark {
  final int id;
  final DateTime createdAt;
  final Subject subject;
  final GradingSystem gradingSystem;
  final ExamType examType;
  final String value;
  final String description;

  Mark(
      {required this.id,
      required this.createdAt,
      required this.subject,
      required this.gradingSystem,
      required this.examType,
      required this.value,
      required this.description});
}
