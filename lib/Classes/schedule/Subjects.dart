import 'package:flutter/material.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';

class Subject {
  final String name;
  final Teacher teacher;
  final Color color; // With alpha

  Subject({required this.name, required this.teacher, required this.color});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      teacher: Teacher.fromJson(json['teacher']),
      color: Color(json['color']),
    );
  }
}
