import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

class Mark {
  final int id;
  final DateTime createdAt;
  final Subject subject;
  final GradingSystem gradingSystem;
  ExamType examType;
  final double numericValue; // The core value for calculations
  final String modifier; // '+', '-', or ''
  final String description;

  Mark({
    required this.id,
    required this.createdAt,
    required this.subject,
    required this.gradingSystem,
    required this.examType,
    required this.numericValue,
    this.modifier = '',
    required this.description,
  });

  /// Parses a mark string (e.g., '2+', '3.5', '4-') into a Mark instance.
  /// [value] is the string representation, [gradingSystem] is needed to interpret modifiers and decimals.
  static Mark parse({
    required int id,
    required DateTime createdAt,
    required Subject subject,
    required GradingSystem gradingSystem,
    required ExamType examType,
    required String value,
    required String description,
  }) {
    final regex = RegExp(r'([0-9]+(?:[.,][0-9]+)?)([+\-]?)');
    final match = regex.firstMatch(value.trim());
    if (match == null) {
      throw FormatException('Invalid mark format: $value');
    }
    double numVal = double.parse(match.group(1)!.replaceAll(',', '.'));
    String mod = match.group(2) ?? '';
    return Mark(
      id: id,
      createdAt: createdAt,
      subject: subject,
      gradingSystem: gradingSystem,
      examType: examType,
      numericValue: numVal,
      modifier: mod,
      description: description,
    );
  }

  /// Converts the Mark to a string representation for display (e.g., '2+', '3.5', etc.)
  String toDisplayString() {
    if (gradingSystem.range.equals(["A", "F"])) {
      var reverseGradeMap = {
        1.0: "A",
        2.0: "B",
        3.0: "C",
        4.0: "D",
        5.0: "E",
        6.0: "F"
      };
      return "${reverseGradeMap[numericValue] ?? numericValue.toStringAsFixed(gradingSystem.modifiers.contains(".") ? 1 : 0)}$modifier";
    }
    // If grading system allows decimals, show them
    if (gradingSystem.modifiers.contains('.')) {
      return numericValue.toStringAsFixed(1).replaceAll('.0', '') + modifier;
    } else {
      return "${numericValue.toInt()} $modifier";
    }
  }

  /// Returns the value to use for calculations (averages, etc.)
  double get valueForCalculation {
    return numericValue;
  }

  /// For serialization (e.g., saving to DB)
  String toRawString() {
    if (gradingSystem.modifiers.contains('.')) {
      return numericValue.toStringAsFixed(1) + modifier;
    } else {
      return numericValue.toInt().toString() + modifier;
    }
  }

  /// Returns a color for the mark based on its value and the grading system.
  Color get color {
    final best = double.tryParse(gradingSystem.range[0]) ?? 1.0;
    final worst = double.tryParse(gradingSystem.range[1]) ?? 6.0;
    final value = valueForCalculation;
    final isReversed = best > worst;
    final min = isReversed ? worst : best;
    final max = isReversed ? best : worst;
    // Clamp value
    final clamped = value.clamp(min, max);
    final t = (clamped - min) / (max - min);
    Color lerp(Color a, Color b, double t) => Color.lerp(a, b, t)!;
    if (t < 0.5) {
      // Green to Yellow
      return lerp(Colors.green, Colors.yellow, t * 2);
    } else {
      return lerp(Colors.yellow, Colors.red, (t - 0.5) * 2);
    }
  }

  // Operator + to combine two marks (for averaging, etc.)
  Mark operator +(Mark other) {
    if (gradingSystem != other.gradingSystem ||
        examType != other.examType ||
        subject != other.subject) {
      throw ArgumentError(
          'Cannot add marks from different grading systems, exam types, or subjects.');
    }
    // Combine numeric values, ignore modifiers and description
    return Mark(
      id: -1,
      createdAt: DateTime.now(),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: examType,
      numericValue: numericValue + other.numericValue,
      modifier: '',
      description: '',
    );
  }

  Mark copyWith({
    int? id,
    DateTime? createdAt,
    Subject? subject,
    GradingSystem? gradingSystem,
    ExamType? examType,
    double? numericValue,
    String? modifier,
    String? description,
  }) =>
      Mark(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        subject: subject ?? this.subject,
        gradingSystem: gradingSystem ?? this.gradingSystem,
        examType: examType ?? this.examType,
        numericValue: numericValue ?? this.numericValue,
        modifier: modifier ?? this.modifier,
        description: description ?? this.description,
      );

  @override
  String toString() =>
      'Mark(id: $id, createdAt: $createdAt, subject: $subject, gradingSystem: $gradingSystem, examType: $examType, numericValue: $numericValue, modifier: $modifier, description: $description)';
}
