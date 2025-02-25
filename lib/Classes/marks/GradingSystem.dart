import 'package:collection/collection.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';

class GradingSystem {
  final List<String> range;
  final List<String> modifiers;
  final List<ExamType> examTypes;

  GradingSystem(
      {required this.range, required this.modifiers, required this.examTypes});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradingSystem &&
        other.range.length == range.length &&
        other.modifiers.length == modifiers.length &&
        const ListEquality().equals(other.range, range) &&
        const ListEquality().equals(other.modifiers, modifiers);
  }

  @override
  int get hashCode => Object.hash(
        range.length,
        modifiers.length,
        range.join(','),
        modifiers.join(','),
      );
}
