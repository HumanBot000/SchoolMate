import 'package:flutter_test/flutter_test.dart';
import 'package:your_project_name/lib/utils/math_operations.dart';

void main() {
  group('MathOperations', () {
    test('calculateArea returns correct value for radius 5', () {
      expect(MathOperations.calculateArea(5), closeTo(pi * 25, 0.001));
    });

    test('calculateArea returns 0 for radius 0', () {
      expect(MathOperations.calculateArea(0), 0);
    });

    test('factorial returns 1 for 0', () {
      expect(MathOperations.factorial(0), 1);
    });

    test('factorial returns 120 for 5', () {
      expect(MathOperations.factorial(5), 120);
    });

    test('factorial returns 1 for 1', () {
      expect(MathOperations.factorial(1), 1);
    });
  });
}
