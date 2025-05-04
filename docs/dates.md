# Dates Subsystem: Technical Documentation

## 1. Subsystem Overview

### Purpose and Responsibilities

The `dates` subsystem provides a collection of utility functions and extensions related to date and
time manipulation in a Flutter application. Its primary responsibilities include:

- Calculating the ISO week number of a given date.
- Determining the start of the week for a given date.
- Generating human-readable time differences (e.g., "2 days", "5 hours").
- Checking for overlaps in a list of time ranges represented by `TimeOfDay` objects.
- Providing extension methods to `DateTime` and `TimeOfDay` classes for common date and time
  operations.

### Fit into the Overall Architecture

This subsystem is designed as a set of independent, reusable utility functions and extensions. It
doesn't directly interact with any specific UI components or data models. Instead, it provides tools
that can be used throughout the application wherever date and time calculations or manipulations are
required. It resides in the `util` directory, signifying its role as a general-purpose utility
module. Other parts of the application can import and use these functions and extensions without
needing to know about their specific implementation details.

### Key Design Patterns and Architectural Decisions

- **Utility Functions:** The core functionality is implemented as a set of pure functions, promoting
  testability and reusability. These functions are stateless and don't rely on any external
  dependencies (other than the `intl` package for date formatting in one extension).
- **Extension Methods:** Extension methods are used to enhance the functionality of the
  built-in `DateTime` and `TimeOfDay` classes. This allows developers to use a more natural and
  fluent syntax when working with dates and times.
- **Immutability:** Date and time calculations are designed to be immutable, meaning that they don't
  modify the original `DateTime` or `TimeOfDay` objects. Instead, they return new objects with the
  calculated values.
- **Error Handling:** The `timeOfDaysOverlap` function includes basic error handling (throwing
  an `ArgumentError`) to ensure that the input data is in the expected format. Other functions
  implicitly handle potential errors by returning appropriate values.

## 2. Code Structure Analysis

### Directory/File Organization

The subsystem consists of two files located in the `util` directory:

- `util/dates.dart`: Contains utility functions related to date and time calculations and
  manipulations.
- `util/extensions/dates.dart`: Contains extension methods for `DateTime` and `TimeOfDay` classes.

This separation of concerns allows for better organization and maintainability. The core utility
functions are kept separate from the extension methods, making it easier to understand the overall
structure of the subsystem.

### Dependencies and Relationships with Other Subsystems

The `dates` subsystem has the following dependencies:

- `flutter/material.dart`: Provides the `TimeOfDay` class.
- `intl/intl.dart`: Used for date formatting (specifically, calculating the day of the year).
- `school_mate/util/extensions/dates.dart`: dates.dart depends on the extension methods defined
  in `util/extensions/dates.dart`.

It doesn't have any direct dependencies on other subsystems within the application. Its design
promotes loose coupling, allowing it to be used independently.

### Class/Module Hierarchies and Their Relationships

There are no explicit class hierarchies in this subsystem. The primary components are:

- **Utility Functions:** Standalone functions that perform specific date and time calculations.
- **`DateTimeExtension`:** An extension on the `DateTime` class providing `dayOfYear`.
- **`DateExtension`:** An extension on the `DateTime` class providing `toTimeOfDay`
  and `startOfWeek` extensions.
- **`TimeOfDayExtension`:** An extension on the `TimeOfDay` class
  providing `toDateTime`, `isBetween`, `add`, `subtract` and `difference` extensions.

The extension methods extend the functionality of existing classes without creating new classes or
inheritance relationships.

## 3. API Documentation

### `util/dates.dart`

#### `weekdaysAbbreviations`

```dart
const List<String> weekdaysAbbreviations = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
];
```

- **Type:** `List<String>`
- **Description:** A constant list containing the abbreviated names of the weekdays.
- **Usage:** Provides a simple way to access the weekday abbreviations, for example in UI elements.

#### `getIsoWeekNumber`

```dart
int getIsoWeekNumber(DateTime date)
```

- **Description:** Calculates the ISO week number for a given date.
- **Parameters:**
    - `date`: A `DateTime` object representing the date for which to calculate the week number.
- **Return Type:** `int` - The ISO week number (1-53).
- **Error Handling:** None. The function will return a valid week number for any valid `DateTime`
  input.
- **Algorithm:**  The calculation `((date.dayOfYear - date.weekday + 10) / 7).floor()` implements
  the ISO 8601 week number calculation. It adjusts for the fact that the ISO week starts on Monday
  and that the first week of the year must contain at least 4 days of the new year.
- **Edge Cases:** The function correctly handles dates at the beginning and end of the year,
  including leap years.

#### `getStartOfWeek`

```dart
DateTime getStartOfWeek(DateTime currentDay)
```

- **Description:** Returns the `DateTime` object representing the start of the week (Monday) for a
  given date.
- **Parameters:**
    - `currentDay`: A `DateTime` object representing the date for which to find the start of the
      week.
- **Return Type:** `DateTime` - A `DateTime` object representing the start of the week (Monday).
- **Error Handling:** None.
- **Algorithm:** Subtracts the number of days since the beginning of the week (Monday) from the
  given date.

#### `getVisualTimeTillDate`

```dart
List<dynamic> getVisualTimeTillDate(DateTime start, DateTime end)
```

- **Description:** Calculates the time difference between two dates and returns a human-readable
  representation (e.g., "2 days", "5 hours").
- **Parameters:**
    - `start`: A `DateTime` object representing the start date.
    - `end`: A `DateTime` object representing the end date.
- **Return Type:** `List<dynamic>` - A list containing the numerical value and the unit of time as
  strings (e.g., `[2, "days"]`).
- **Error Handling:** None. The function will return a valid representation for any valid `DateTime`
  inputs.
- **Algorithm:** Calculates the difference between the two dates in days, hours and minutes. Then,
  it returns the largest unit of time that is greater than or equal to one.
- **Edge Cases:** Will return minutes if the time difference is less than an hour, hours if the time
  difference is less than a day, days if the time difference is less than a year, and years
  otherwise.

#### `timeOfDaysOverlap`

```dart
bool timeOfDaysOverlap(List<List<TimeOfDay>> times)
```

- **Description:** Checks if there is any overlap between a list of time ranges represented
  by `TimeOfDay` objects.
- **Parameters:**
    - `times`: A `List<List<TimeOfDay>>` where each inner list represents a time range and contains
      two `TimeOfDay` objects: the start and end time.
- **Return Type:** `bool` - `true` if any time ranges overlap, `false` otherwise.
- **Error Handling:** Throws an `ArgumentError` if any of the inner lists does not contain exactly
  two `TimeOfDay` objects.
- **Algorithm:**
    1. Iterates through each time range in the input list.
    2. For each time range, it checks for the following:
        - If the time range has exactly two times
        - If the start time is before the end time within each range
        - If all the start times are sorted globally in the list of times, and if not, automatically
          flags an overlap.
        - Compares with all other time ranges to check for overlaps using the
          formula:  `start1 < end2 AND start2 < end1`.

### `util/extensions/dates.dart`

#### `DateTimeExtension.dayOfYear`

```dart
extension DateTimeExtension on DateTime {
  int get dayOfYear {
    return int.parse(DateFormat("D").format(this));
  }
}
```

- **Description:** Extension to DateTime class to get the day of the year
- **Return Type:** `int`

#### `DateExtension.toTimeOfDay`

```dart
extension DateExtension on DateTime {
  TimeOfDay toTimeOfDay() {
    return TimeOfDay(hour: hour, minute: minute);
  }
}
```

- **Description:** Converts a `DateTime` object to a `TimeOfDay` object.
- **Return Type:** `TimeOfDay` - A `TimeOfDay` object representing the time of day from the
  original `DateTime` object.

#### `DateExtension.startOfWeek`

```dart
extension DateExtension on DateTime {
  DateTime startOfWeek() {
    return subtract(Duration(days: weekday - 1));
  }
}
```

- **Description:** Returns the `DateTime` object representing the start of the week (Monday) for a
  given date.
- **Return Type:** `DateTime` - A `DateTime` object representing the start of the week (Monday).

#### `TimeOfDayExtension.toDateTime`

```dart
extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }
}
```

- **Description:** Converts a `TimeOfDay` object to a `DateTime` object, using the current date.
- **Return Type:** `DateTime` - A `DateTime` object representing the date and time from the
  original `TimeOfDay` object.

#### `TimeOfDayExtension.isBetween`

```dart
extension TimeOfDayExtension on TimeOfDay {
  bool isBetween(TimeOfDay start, TimeOfDay end) {
    final int currentMinutes = hour * 60 + minute;
    final int startMinutes = start.hour * 60 + start.minute;
    final int endMinutes = end.hour * 60 + end.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }
}
```

- **Description:** Checks if a `TimeOfDay` object falls between two other `TimeOfDay` objects.
- **Return Type:** `bool` - `true` if the `TimeOfDay` object is between the start and end
  times, `false` otherwise.

#### `TimeOfDayExtension.add`

```dart
extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add(Duration duration) {
    return toDateTime().add(duration).toTimeOfDay();
  }
}
```

- **Description:** Adds a `Duration` to a `TimeOfDay` object.
- **Return Type:** `TimeOfDay` - A new `TimeOfDay` object representing the time after adding the
  duration.

#### `TimeOfDayExtension.subtract`

```dart
extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay subtract(Duration duration) {
    return toDateTime().subtract(duration).toTimeOfDay();
  }
}
```

- **Description:** Subtracts a `Duration` from a `TimeOfDay` object.
- **Return Type:** `TimeOfDay` - A new `TimeOfDay` object representing the time after subtracting
  the duration.

#### `TimeOfDayExtension.difference`

```dart
extension TimeOfDayExtension on TimeOfDay {
  Duration difference(TimeOfDay startTime) {
    return Duration(
        hours: hour - startTime.hour, minutes: minute - startTime.minute);
  }
}
```

- **Description:** Calculates the difference between two `TimeOfDay` objects.
- **Return Type:** `Duration` - A `Duration` object representing the time difference.

## 4. Function-Level Documentation

### `timeOfDaysOverlap`

```dart
bool timeOfDaysOverlap(List<List<TimeOfDay>> times) {
  // ...implementation details...
}
```

- **Algorithm:**

    1. **Input Validation:** Checks if each inner list contains exactly two `TimeOfDay` objects (
       start and end times). If not, it throws an `ArgumentError`.
    2. **Overlap Check:** Iterates through each time range and compares it with every other time
       range in the list.
    3. **Comparison:** For each pair of time ranges, it checks if they overlap using the following
       condition: `start1 < end2 && start2 < end1`.
    4. **Return Value:** If any overlap is found, the function immediately returns `true`. If no
       overlaps are found after comparing all time ranges, it returns `false`.

- **Time Complexity:** O(n^2), where n is the number of time ranges in the input list. This is
  because the function iterates through each pair of time ranges to check for overlaps.

- **Space Complexity:** O(1). The function uses a constant amount of extra space regardless of the
  input size.

- **Edge Cases:**
    - **Empty Input:** If the input list is empty, the function returns `false` (no overlaps).
    - **Single Time Range:** If the input list contains only one time range, the function
      returns `false` (no overlaps).
    - **Invalid Time Ranges:** If any of the time ranges have an end time that is before the start
      time, the function still correctly detects overlaps.
    - **Identical Time Ranges:** If the input list contains identical time ranges, the function will
      detect an overlap.
- **Handling of Assumed Sorted Lists**:
    - The code now contains a check for ordering. If all of the start times are not globally sorted,
      it immediately flags an overlap. This is a specific feature intended to reduce the number of
      computations necessary.

## 5. Data Flow

The `dates` subsystem primarily deals with `DateTime` and `TimeOfDay` objects as input and output.

- **Input Validation:** The `timeOfDaysOverlap` function validates the input data to ensure that it
  is in the expected format.
- **Data Transformation:** The extension methods often transform `DateTime` objects to `TimeOfDay`
  objects and vice versa.

## 6. Implementation Details

- **Language-Specific Implementation Details:**
    - The `intl` package is used for date formatting in the `dayOfYear` extension.
- **Performance Optimizations:**
    - For `timeOfDaysOverlap`, immediately exiting when an overlap is found is a performance
      optimization.

## 7. Common Usage Patterns

### Calculating the ISO Week Number

```dart
DateTime now = DateTime.now();
int weekNumber = getIsoWeekNumber(now);
print("The current week number is: $weekNumber");
```

### Getting the Start of the Week

```dart
DateTime today = DateTime.now();
DateTime startOfWeek = getStartOfWeek(today);
print("The start of the week is: $startOfWeek");
```

### Checking for Time Overlaps

```dart
import 'package:flutter/material.dart';
import 'package:school_mate/util/dates.dart';

void main() {
  List<List<TimeOfDay>> times = [
    [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)],
    [TimeOfDay(hour: 10, minute: 30), TimeOfDay(hour: 11, minute: 30)],
    [TimeOfDay(hour: 11, minute: 0), TimeOfDay(hour: 12, minute: 0)],
  ];

  bool overlaps = timeOfDaysOverlap(times);
  print("Do the times overlap? $overlaps"); // Output: true
}
```

### Antipatterns to Avoid

- **Modifying `DateTime` or `TimeOfDay` Objects Directly:** Always use the `add` and `subtract`
  methods to create new objects instead of modifying the original objects directly.
- **Ignoring Time Zones:** Be aware of time zones when performing date and time calculations.
  The `dates` subsystem does not explicitly handle time zones, so it's important to ensure that
  all `DateTime` objects are in the same time zone before performing calculations.
- **Complex Date Formatting:** Avoid using complex date formatting patterns directly in the code.
  Instead, use the `intl` package to format dates and times according to the user's locale.

## 8. Testing Approach

### Testing Strategy

The dates subsystem should be tested using unit tests to ensure that each function and extension
method behaves as expected.

### Test Coverage Analysis

The unit tests should cover the following scenarios:

- Calculating the ISO week number for various dates, including dates at the beginning and end of the
  year.
- Getting the start of the week for various dates.
- Calculating the time difference between two dates for various units of time (years, days, hours,
  minutes).
- Checking for overlaps in a list of time ranges, including cases with no overlaps, partial
  overlaps, and complete overlaps.
- Converting `DateTime` objects to `TimeOfDay` objects and vice versa.
- Adding and subtracting `Duration` objects from `TimeOfDay` objects.
- Calculating the difference between two `TimeOfDay` objects.
- Edge cases and invalid inputs.

### Mocking Strategies for Dependencies

- `DateTime.now()`: When testing functions that rely on the current date and time, use the `clock`
  package or a similar mocking framework to mock the `DateTime.now()` method. This allows you to
  control the date and time that is used in the tests.
