# Dates Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The dates subsystem provides utility functions and extensions for handling date and time operations
in a Flutter application. It offers enhanced functionality for working with `DateTime`
and `TimeOfDay` objects, making complex date and time manipulations more straightforward.

### Key Responsibilities

- Calculate week numbers
- Determine start of week
- Calculate time differences
- Check time overlaps
- Provide extension methods for date and time transformations

### Architectural Significance

This subsystem serves as a crucial utility layer, providing reusable date and time manipulation
methods across the application. It abstracts complex date calculations and extends native
Dart/Flutter date handling capabilities.

## 2. Code Structure Analysis

### Files

- `util/dates.dart`: Core date utility functions
- `util/extensions/dates.dart`: Extension methods for `DateTime` and `TimeOfDay`

### Dependencies

- `flutter/material.dart`: For `TimeOfDay` class
- `intl/intl.dart`: For date formatting
- Local extensions module

## 3. Core Functions and Extensions

### Global Functions

#### `getIsoWeekNumber(DateTime date)`

```dart
int getIsoWeekNumber(DateTime date)
```

- Calculates ISO week number for a given date
- Returns week number as an integer
- Uses day of year and weekday calculations

#### `getStartOfWeek(DateTime currentDay)`

```dart
DateTime getStartOfWeek(DateTime currentDay)
```

- Determines the start of the week for a given date
- Subtracts days to reach the first day of the week (Monday)

#### `getVisualTimeTillDate(DateTime start, DateTime end)`

```dart
List<dynamic> getVisualTimeTillDate(DateTime start, DateTime end)
```

- Calculates human-readable time difference
- Returns array with numeric value and time unit (years/days/hours/minutes)
- Handles pluralization of time units

#### `timeOfDaysOverlap(List<List<TimeOfDay>> times)`

```dart
bool timeOfDaysOverlap(List<List<TimeOfDay>> times)
```

- Checks for overlapping time ranges
- Validates time range order
- Supports multiple time range comparisons

### Extension Methods

#### DateTime Extensions

- `dayOfYear`: Calculates day number in the year
- `toTimeOfDay()`: Converts DateTime to TimeOfDay
- `startOfWeek()`: Finds the start of the week

#### TimeOfDay Extensions

- `toDateTime()`: Converts TimeOfDay to DateTime
- `isBetween(TimeOfDay start, TimeOfDay end)`: Checks if time is within a range
- `add(Duration)`: Adds duration to TimeOfDay
- `subtract(Duration)`: Subtracts duration from TimeOfDay
- `difference(TimeOfDay)`: Calculates time difference

## 4. Performance Considerations

- Uses efficient integer-based calculations
- Minimizes object creation
- Leverages built-in Dart/Flutter date manipulation methods

## 5. Usage Examples

### Week Number Calculation

```dart
DateTime now = DateTime.now();
int weekNumber = getIsoWeekNumber(now); // Get current week number
```

### Time Difference Visualization

```dart
DateTime start = DateTime(2023, 1, 1);
DateTime end = DateTime(2024, 1, 1);
var timeDiff = getVisualTimeTillDate(start, end); 
// Returns [1, "year"]
```

### Time Overlap Detection

```dart
var times = [
  [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 10, minute: 0)],
  [TimeOfDay(hour: 10, minute: 30), TimeOfDay(hour: 11, minute: 30)]
];
bool hasOverlap = timeOfDaysOverlap(times); // Checks for time range conflicts
```

## 6. Error Handling

- Throws `ArgumentError` for invalid time range inputs
- Handles edge cases in time calculations
- Provides safe type conversions

## 7. Testing Strategies

- Unit test each utility function
- Validate edge cases (year boundaries, time overlaps)
- Test extension method behaviors
- Mock DateTime for consistent testing

## 8. Potential Improvements

- Add more comprehensive error checking
- Implement timezone support
- Create more flexible time range comparison methods