import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_mate/API/supabase/grades/marks.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/persons/Gender.dart';
import 'package:school_mate/Classes/persons/Teacher.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

void main() {
  group('parseMark Tests', () {
    test('Parses standard numeric strings', () {
      expect(parseMark("2"), 2.0);
      expect(parseMark("3.5"), 3.5);
      expect(parseMark("1.25"), 1.25);
    });

    test('Parses localized comma decimal strings', () {
      expect(parseMark("2,5"), 2.5);
      expect(parseMark("3,75"), 3.75);
    });

    test('Parses numbers with modifiers', () {
      expect(parseMark("2+"), 2.0);
      expect(parseMark("3-"), 3.0);
      expect(parseMark("-1"), -1.0);
    });

    test('Parses letter grades', () {
      expect(parseMark("A"), 1.0);
      expect(parseMark("b"), 2.0);
      expect(parseMark("F"), 6.0);
    });
  });

  group('Mark.parse Tests', () {
    late Subject subject;
    late GradingSystem gradingSystem;
    late ExamType midterm;

    setUp(() {
      final teacher = Teacher("Dr. Smith", Gender.male(), 1);
      subject = Subject(
          name: "Math", teacher: teacher, color: Colors.blue, id: 1);

      midterm = ExamType(
        id: 1,
        name: "Midterm",
        evaluationData: EvaluationData(
          evaluationMethod: EvaluationMethod.percentage,
          percentage: 100,
        ),
      );

      gradingSystem = GradingSystem(
        range: ["1", "6"],
        modifiers: ["+", "-"],
        examTypes: [midterm],
      );
    });

    test('Successfully parses valid mark format string', () {
      final mark = Mark.parse(
        id: 1,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: gradingSystem,
        examType: midterm,
        value: "2+",
        description: "Good midterm",
        isConsidered: true,
      );

      expect(mark.numericValue, 2.0);
      expect(mark.modifier, "+");
      expect(mark.description, "Good midterm");
      expect(mark.isConsidered, true);
    });

    test('Throws FormatException on invalid formats', () {
      expect(
        () => Mark.parse(
          id: 1,
          createdAt: DateTime.now(),
          subject: subject,
          gradingSystem: gradingSystem,
          examType: midterm,
          value: "abc",
          description: "Bad format",
          isConsidered: true,
        ),
        throwsFormatException,
      );
    });

    test('Serializes toDisplayString and toRawString correctly', () {
      final mark = Mark(
        id: 1,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: gradingSystem,
        examType: midterm,
        numericValue: 2.0,
        modifier: "+",
        description: "Test",
        isConsidered: true,
      );

      expect(mark.toDisplayString(), "2 +");
      expect(mark.toRawString(), "2+");
    });

    test('Calculates color correctly for standard and reversed (points) grading systems', () {
      final standardMarkBest = Mark(
        id: 1,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: gradingSystem,
        examType: midterm,
        numericValue: 1.0,
        description: "Best Standard Mark",
        isConsidered: true,
      );
      final standardMarkWorst = Mark(
        id: 2,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: gradingSystem,
        examType: midterm,
        numericValue: 6.0,
        description: "Worst Standard Mark",
        isConsidered: true,
      );

      expect(standardMarkBest.color.value, Colors.green.value);
      expect(standardMarkWorst.color.value, Colors.red.value);

      final pointsGradingSystem = GradingSystem(
        range: ["15", "0"],
        modifiers: [],
        examTypes: [midterm],
      );

      final pointsMarkBest = Mark(
        id: 3,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: pointsGradingSystem,
        examType: midterm,
        numericValue: 15.0,
        description: "Best Points Mark",
        isConsidered: true,
      );
      final pointsMarkWorst = Mark(
        id: 4,
        createdAt: DateTime.now(),
        subject: subject,
        gradingSystem: pointsGradingSystem,
        examType: midterm,
        numericValue: 0.0,
        description: "Worst Points Mark",
        isConsidered: true,
      );

      expect(pointsMarkBest.color.value, Colors.green.value);
      expect(pointsMarkWorst.color.value, Colors.red.value);
    });
  });
}
