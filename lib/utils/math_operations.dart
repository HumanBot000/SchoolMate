// Original file content without tests
import 'dart:math';

class MathOperations {
  static double calculateArea(double radius) {
    return pi * radius * radius;
  }

  static int factorial(int n) {
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
  }
}
