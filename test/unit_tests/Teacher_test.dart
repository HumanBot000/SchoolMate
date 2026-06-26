import 'package:flutter_test/flutter_test.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';

void main() {
  group('Teacher Tests', () {
    test('Teacher.empty() does not crash and returns default values', () {
      final teacher = Teacher.empty();
      expect(teacher.name, equals('Unknown Teacher'));
      expect(teacher.id, equals(-1));
      expect(teacher.gender, isNotNull);
    });

    test('Teacher.fromJson handles null input safely by falling back to Teacher.empty()', () {
      final teacher = Teacher.fromJson(null);
      expect(teacher.name, equals('Unknown Teacher'));
      expect(teacher.id, equals(-1));
    });
  });
}
