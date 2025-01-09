import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_mate/util/dates.dart';

void main() {
  // AI generated
  group('timeOfDaysOverlap Tests', () {
    test('No overlap between time ranges', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 30)],
        [TimeOfDay(hour: 9, minute: 30), TimeOfDay(hour: 10, minute: 0)]
      ];
      expect(timeOfDaysOverlap(times), isFalse);
    });

    test('Overlap between time ranges', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 30)],
        [TimeOfDay(hour: 9, minute: 20), TimeOfDay(hour: 10, minute: 0)]
      ];
      expect(timeOfDaysOverlap(times), isTrue);
    });

    test('Invalid single range (start after end)', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 9, minute: 50), TimeOfDay(hour: 9, minute: 40)]
      ];
      expect(timeOfDaysOverlap(times), isTrue);
    });

    test('Overlap between multiple ranges', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 30)],
        [TimeOfDay(hour: 9, minute: 10), TimeOfDay(hour: 9, minute: 50)],
        [TimeOfDay(hour: 9, minute: 45), TimeOfDay(hour: 10, minute: 15)]
      ];
      expect(timeOfDaysOverlap(times), isTrue);
    });

    test('No overlap with gaps between ranges', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 0)],
        [TimeOfDay(hour: 9, minute: 15), TimeOfDay(hour: 10, minute: 0)],
        [TimeOfDay(hour: 10, minute: 15), TimeOfDay(hour: 11, minute: 0)]
      ];
      expect(timeOfDaysOverlap(times), isFalse);
    });

    test('Empty list of time ranges', () {
      List<List<TimeOfDay>> times = [];
      expect(timeOfDaysOverlap(times), isFalse);
    });

    test('Single range with valid start and end', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 0)]
      ];
      expect(timeOfDaysOverlap(times), isFalse);
    });

    test('Invalid input format (less than 2 times)', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0)]
      ];
      expect(() => timeOfDaysOverlap(times), throwsArgumentError);
    });

    test('Invalid input format (more than 2 times)', () {
      List<List<TimeOfDay>> times = [
        [
          TimeOfDay(hour: 8, minute: 0),
          TimeOfDay(hour: 9, minute: 0),
          TimeOfDay(hour: 10, minute: 0)
        ]
      ];
      expect(() => timeOfDaysOverlap(times), throwsArgumentError);
    });

    test('Edge case: Overlap at the exact end and start time', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 9, minute: 0)],
        [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)]
      ];
      expect(timeOfDaysOverlap(times), isFalse);
    });

    test('Unsorted input time ranges', () {
      List<List<TimeOfDay>> times = [
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 8, minute: 45)],
        [TimeOfDay(hour: 0, minute: 3), TimeOfDay(hour: 0, minute: 48)]
      ];
      expect(timeOfDaysOverlap(times), isTrue);
    });
  });
}
