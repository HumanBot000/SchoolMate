import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/math_utils.dart'; // Adjust import path as needed

void main() {
  group('MathUtils', () {
    test('addNumbers adds two numbers correctly', () {
      expect(addNumbers(2, 3), 5);
    });

    test('addNumbers handles negative numbers', () {
      expect(addNumbers(-1, 1), 0);
    });

    test('addNumbers handles zero', () {
      expect(addNumbers(5, 0), 5);
    });
  });
}
