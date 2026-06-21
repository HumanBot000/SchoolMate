extension StringExtensions on String {
  String capitalize() {
    return trim().replaceFirst(
        trim().substring(0, 1), trim().substring(0, 1).toUpperCase());
  }
}
