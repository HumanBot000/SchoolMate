import 'package:flutter_test/flutter_test.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Classes/persons/Gender.dart';
import 'package:flutter/material.dart';

void main() {
  group('Subject Tests', () {
    test('Subject.fromJson with pre-fetched teacher', () async {
      final json = {
        "name": "Maths",
        "color": "ffff0000",
        "subject_id": 42,
        "teacher": 5
      };
      final preFetchedTeacher = Teacher("Mr. Smith", Gender.male(), 5);

      final subject = await Subject.fromJson(json, teacher: preFetchedTeacher);

      expect(subject.name, equals("Maths"));
      expect(subject.color, equals(const Color(0xffff0000)));
      expect(subject.id, equals(42));
      expect(subject.teacher, equals(preFetchedTeacher));
    });
  });
}
