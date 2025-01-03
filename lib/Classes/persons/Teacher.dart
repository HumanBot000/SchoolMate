import 'dart:math';

import 'Gender.dart';

class Teacher {
  final String name;
  final Gender gender;
  final int id;

  Teacher(this.name, this.gender, this.id);

  factory Teacher.empty() {
    final List<String> teacherNames = [];
    return Teacher(
        teacherNames[Random().nextInt(teacherNames.length)],
        [Gender.male(), Gender.female()][Random().nextInt(2)],
        -1); // Don't know what about the ID, might need to implement a check on every Update/Delete operation that ID != -1
  }

  factory Teacher.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Teacher.empty();
    return Teacher(
      json['name'],
      Gender.fromLetter(json['gender'], address: json["form_of_address"]),
      json['id'],
    );
  }
}
