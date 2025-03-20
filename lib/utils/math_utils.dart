import 'dart:math';

/// Utility class for mathematical operations.
class MathUtils {
  /// Calculates the factorial of a given number.
  static int factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Number must be non-negative.');
    }
    return n == 0 ? 1 : n * factorial(n - 1);
  }

  /// Rounds a double to a specified number of decimal places.
  static double roundToDecimalPlaces(double value, int places) {
    var mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  /// Checks if a number is even.
  static bool isEven(int number) {
    return number % 2 == 0;
  }

  /// Checks if a number is odd.
  static bool isOdd(int number) {
    return number % 2 != 0;
  }

  /// Calculates the greatest common divisor (GCD) of two numbers.
  static int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Calculates the least common multiple (LCM) of two numbers.
  static int lcm(int a, int b) {
    return (a * b) ~/ gcd(a, b);
  }
}
