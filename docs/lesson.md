```markdown
# Lesson Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose and Responsibilities
The `Lesson` subsystem is responsible for representing and managing individual lesson instances within a schedule. It encapsulates the subject matter, timing, and location of a specific lesson.  Its primary responsibilities include:

*   Storing lesson-specific information such as lesson ID, subject, temporal data (weekday, time, alternating weeks), and location.
*   Providing convenient access to lesson details.
*   Handling the temporal aspects of a lesson, calculating duration and start DateTime.
*   Serializing/deserializing lesson data from/to JSON format.

### How it Fits into the Overall Architecture
The `Lesson` subsystem is a core component of the schedule management system. It relies on:

*   `Subject` subsystem:  A `Lesson` *has-a* `Subject`, inheriting subject details (name, teacher, color, ID). The subject provides the core information about *what* is being taught.
*   `util/dates.dart` and `util/extensions/dates.dart`: For date and time calculations, particularly the calculation of `startDateTime`.
*   `util/alphabet.dart`:  For converting alternating week letters to numerical indexes, for easier computation.
*   Flutter's `TimeOfDay` class for time representation.
*   `intl` package for parsing time strings from JSON.

It interacts with other subsystems when displaying the schedule, managing lesson conflicts, and potentially when integrating with external calendar services.

### Key Design Patterns and Architectural Decisions
*   **Data Class:** `Lesson` and `LessonTemporalData` are primarily data classes, focusing on holding information.
*   **Composition:** `Lesson` *composes* a `Subject` and `LessonTemporalData`, promoting code reuse and separation of concerns.  Temporal data is encapsulated in its own class, simplifying the main `Lesson` class and making temporal information easier to manage.
*   **Factory Pattern:** The `Lesson.fromJson` factory constructor handles the deserialization of lesson data from JSON, encapsulating the parsing logic and dependency on the `Subject` list.
*   **Immutability (Partial):** While the `Lesson` class itself isn't explicitly immutable, the fields `lessonID`, `subject`, `temporalData`, and `location` are `final`, preventing modification after the `Lesson` instance is created.  This contributes to data integrity. The `LessonTemporalData` class is also immutable.

## 2. Code Structure Analysis

### Directory/File Organization
```

Classes/
└── schedule/
├── Lesson.dart // Contains the Lesson and LessonTemporalData classes

```

### Dependencies and Relationships with other Subsystems

*   **Internal Dependencies:**
    *   `Subject` (from `Classes/schedule/Subject.dart`):  `Lesson` directly depends on the `Subject` class.
    *   `alphabet.dart` (from `util/alphabet.dart`): Used by `LessonTemporalData` to convert week letters to numeric indices.
    *   `dates.dart` (from `util/dates.dart`): Used by `LessonTemporalData` to calculate dates, specifically `getStartOfWeek`.
    *   `dates.dart` extensions (from `util/extensions/dates.dart`): Used by `LessonTemporalData` to calculate dates.
*   **External Dependencies:**
    *   `flutter/material.dart`: For `TimeOfDay` class.
    *   `intl/intl.dart`: For parsing time strings.

### Class/Module Hierarchies and their Relationships

```

Class Hierarchy:

Subject  <-- Lesson

LessonTemporalData (Data Class)

```

*   `Subject` is the base class for `Lesson`.  `Lesson` inherits properties like `name`, `teacher`, `color`, and `id` from `Subject`.
*   `LessonTemporalData` is a helper class that encapsulates all the temporal information about a lesson (weekday, time, alternating weeks). It is *composed* within the `Lesson` class.

## 3. API Documentation

### Public Interfaces
#### `Lesson` Class

*   **Constructor:** `Lesson(this.lessonID, this.subject, this.temporalData, this.location)`
    *   `lessonID`: `int` - Unique identifier for the lesson.
    *   `subject`: `Subject` - The subject being taught in this lesson.
    *   `temporalData`: `LessonTemporalData` -  Temporal information about the lesson (weekday, time, alternating weeks).
    *   `location`: `String?` - The location where the lesson takes place (nullable).

*   **Factory Constructor:** `Lesson.fromJson(Map<String, dynamic> json, List<Subject> subjects)`
    *   `json`: `Map<String, dynamic>` - JSON representation of the lesson.  Expected keys: `lesson_id`, `subject_id`, `weekday`, `alternating_weeks`, `start_time`, `end_time`, `room`.
    *   `subjects`: `List<Subject>` - A list of available subjects.  Used to resolve the `subject_id` to a `Subject` object.
    *   **Returns:** `Lesson` - A new `Lesson` instance created from the JSON data.
    *   **Throws:**  Might throw an exception if the `subject_id` in the JSON does not match any `Subject` in the provided list.

*   **Properties:** (All final, meaning they are set during construction and cannot be changed afterward).
    *   `lessonID`: `int`
    *   `subject`: `Subject`
    *   `temporalData`: `LessonTemporalData`
    *   `location`: `String?`
    *   `name`: `String` (inherited from `Subject`)
    *   `teacher`: `String` (inherited from `Subject`)
    *   `color`: `Color` (inherited from `Subject`)
    *   `id`: `int` (inherited from `Subject`)

#### `LessonTemporalData` Class

*   **Constructor:** `LessonTemporalData(this.weekday, this.alternatingWeeks, this.startTime, this.endTime, this.numericalAlternatingWeeks)`
    *   `weekday`: `int` - The weekday of the lesson (1 for Monday, 7 for Sunday).
    *   `alternatingWeeks`: `List<String>` - List of alternating week identifiers (e.g., ["A", "C"]).
    *   `numericalAlternatingWeeks`: `List<int>` - List of numerical alternating week indexes (e.g., [0, 2]).
    *   `startTime`: `TimeOfDay` - The start time of the lesson.
    *   `endTime`: `TimeOfDay` - The end time of the lesson.

*   **Properties:** (All final).
    *   `weekday`: `int`
    *   `alternatingWeeks`: `List<String>`
    *   `numericalAlternatingWeeks`: `List<int>`
    *   `startTime`: `TimeOfDay`
    *   `endTime`: `TimeOfDay`

*   **Methods:**
    *   `duration`: `Duration` - A getter that calculates the duration of the lesson based on `startTime` and `endTime`.
    *   `startDateTime`: `DateTime` - A getter that calculates the `DateTime` of the start of the lesson for the current week.

### Return Types and Error Handling Patterns

*   The `Lesson.fromJson` factory constructor returns a `Lesson` object. It relies on the `subjects.firstWhere` method which can throw an `Error` if no matching Subject is found for a provided `subject_id`.  This should be handled by a try-catch block in the calling code.
*   The `duration` getter in `LessonTemporalData` returns a `Duration` object, which can be negative if the end time is before the start time (though this should ideally be prevented by validation).
*   The `startDateTime` getter in `LessonTemporalData` returns a `DateTime` object.

## 4. Function-Level Documentation

### `LessonTemporalData.startDateTime`

```dart
DateTime get startDateTime => getStartOfWeek(DateTime.now())
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0)
      .add(Duration(days: weekday - 1))
      .add(Duration(hours: startTime.hour, minutes: startTime.minute));
```

* **Purpose:** Calculates the `DateTime` representing the start of the lesson for the current week.
* **Algorithm:**
    1. Gets the start of the current week using `getStartOfWeek(DateTime.now())`
       from `util/dates.dart`.
    2. Sets the time components (hour, minute, second, millisecond, microsecond) of the start of the
       week to zero to get the very beginning of the week.
    3. Adds a duration equal to `weekday - 1` days to get the correct day of the week (Monday is 1,
       Tuesday is 2, etc.).
    4. Adds a duration representing the lesson's start time.
* **Time Complexity:** O(1) - The operations involved are constant time.
* **Space Complexity:** O(1) - Only constant space is used.
* **Edge Cases:**
    * If `weekday` is invalid (outside the range 1-7), the resulting `DateTime` will be incorrect,
      although no error will be thrown. Input validation for `weekday` should occur before
      constructing `LessonTemporalData`.
    * The start time is calculated for the *current* week. This might not be the desired behavior if
      the user wants to see lesson times for future weeks. The `DateTime.now()` call should likely
      be a parameter.
* **Returns:** `DateTime` - The `DateTime` representing the start of the lesson for the current
  week.

### `Lesson.fromJson`

```dart
factory Lesson.fromJson(Map<String, dynamic> json, List<Subject> subjects) =>
      Lesson(
        json["lesson_id"],
        subjects.firstWhere((subject) => subject.id == json["subject_id"]),
        LessonTemporalData(
          json["weekday"],
          (json["alternating_weeks"] as List<dynamic>).cast<String>(),
          TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json["start_time"])),
          TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json["end_time"])),
          getIndexesInAlphabet(
              (json["alternating_weeks"] as List<dynamic>).cast<String>()),
        ),
        json["room"],
      );
```

* **Purpose:** Creates a `Lesson` object from a JSON representation.
* **Algorithm:**
    1. Extracts the values
       for `lesson_id`, `subject_id`, `weekday`, `alternating_weeks`, `start_time`, `end_time`,
       and `room` from the `json` map.
    2. Uses `subjects.firstWhere` to find the `Subject` object corresponding to the `subject_id`.
       This involves iterating through the subjects list.
    3. Creates a `LessonTemporalData` object using the
       extracted `weekday`, `alternating_weeks`, `start_time`, and `end_time` data. It parses
       the `start_time` and `end_time` strings into `TimeOfDay` objects
       using `DateFormat('HH:mm').parse`. The `getIndexesInAlphabet` function is called
       on `alternating_weeks` to generate a list of numerical indexes.
    4. Creates a new `Lesson` object using the extracted data and the created `Subject`
       and `LessonTemporalData` objects.
* **Time Complexity:** O(n) - where n is the number of subjects in the `subjects` list because
  of `subjects.firstWhere`. The time complexity of `getIndexesInAlphabet` depends on the
  implementation of `alphabet.dart`, but is likely O(m*k) where m is the number of alternating weeks
  and k is the size of the alphabet. The rest of the operations are O(1).
* **Space Complexity:** O(1) - Only constant extra space is used.
* **Error Handling:**
    * `subjects.firstWhere` can throw an error if a `Subject` with the given ID isn't found. This
      needs to be handled by the caller.
    * The `DateFormat('HH:mm').parse` method can throw a `FormatException` if the `start_time`
      or `end_time` strings are not in the correct format. This should also be handled by the
      caller, potentially by wrapping the entire `fromJson` factory in a try-catch block.
* **Returns:** `Lesson` - A new `Lesson` object created from the JSON data.

## 5. Data Flow

### How Data Moves Through This Subsystem

1. **Creation:**  `Lesson` objects are typically created either directly via the constructor or,
   more commonly, from JSON data using the `Lesson.fromJson` factory.
2. **Data Storage:** The `Lesson` object holds the lesson's
   data: `lessonID`, `subject`, `temporalData`, and `location`. The `LessonTemporalData` object
   holds `weekday`, `alternatingWeeks`, `numericalAlternatingWeeks`, `startTime`, and `endTime`.
3. **Data Access:** The data within a `Lesson` object is accessed through its properties (
   e.g., `lesson.subject.name`, `lesson.temporalData.startTime`).
4. **Data Transformation:** The `LessonTemporalData` class performs some data transformations,
   particularly:
    * Converting `alternatingWeeks` (List of Strings) into `numericalAlternatingWeeks` (List of
      ints).
    * Calculating `duration` from `startTime` and `endTime`.
    * Calculating `startDateTime` based on the weekday and time.

### State Management Approaches

The `Lesson` subsystem itself doesn't directly manage any persistent state. The state (the lesson
data) is held within the `Lesson` objects. The lifetime and persistence of these objects are managed
by the calling code (e.g., a schedule management component). Flutter state management solutions (
Provider, BLoC, Riverpod, etc.) would be used to manage collections of `Lesson` objects in a larger
application.

### Input Validation and Data Transformation Patterns

* **JSON Deserialization:** The `Lesson.fromJson` factory is responsible for parsing and validating
  data from JSON. It uses `DateFormat` to parse time strings. Error handling is limited to
  exceptions that the parsing methods themselves throw, rather than explicit checks.
* **`LessonTemporalData` Constructor:** There is no explicit input validation in
  the `LessonTemporalData` constructor. Validation of the `weekday`, `startTime`, and `endTime`
  should ideally be performed before creating a `LessonTemporalData` instance. For example:

```dart
  LessonTemporalData(int weekday, List<String> alternatingWeeks, TimeOfDay startTime,
      TimeOfDay endTime, List<int> numericalAlternatingWeeks) {
    if (weekday < 1 || weekday > 7) {
      throw ArgumentError("Weekday must be between 1 and 7");
    }
    if (endTime.hour < startTime.hour || (endTime.hour == startTime.hour && endTime.minute <= startTime.minute)){
      throw ArgumentError("End time must be after the start time");
    }

    this.weekday = weekday;
    this.alternatingWeeks = alternatingWeeks;
    this.startTime = startTime;
    this.endTime = endTime;
    this.numericalAlternatingWeeks = numericalAlternatingWeeks;
  }
```

## 6. Implementation Details

### Language-Specific Implementation Details

* **Dart Features:**
    * Use of `final` keyword to enforce immutability of fields.
    * Use of `factory` constructor for `Lesson.fromJson`.
    * Use of getters for derived properties (`duration`, `startDateTime`).
    * Type safety with explicit type annotations.
* **Flutter Features:**
    * Uses Flutter's `TimeOfDay` class.
* **`intl` Package:** The `intl` package is used for parsing time strings into `TimeOfDay` objects.
  The `DateFormat('HH:mm')` pattern is used to parse time strings in the 24-hour format.

### Performance Optimizations

* **Immutability:** The `final` keyword helps with performance as the values of the fields are known
  at compile time.
* **Caching:**  The `duration` and `startDateTime` are calculated as needed and not cached. If these
  are frequently accessed, consider caching their values. However, be mindful of when and how to
  invalidate the cache if the underlying data changes.

### Security Considerations

* **Input Validation:** The current implementation lacks thorough input validation, especially in
  the `LessonTemporalData` constructor. Lack of validation could lead to unexpected behavior or
  vulnerabilities if the data source is untrusted.
* **Data Sanitization:** If the `location` string comes from an external source, it should be
  sanitized to prevent potential XSS (Cross-Site Scripting) vulnerabilities if the location is
  displayed in a UI.

## 7. Common Usage Patterns

### Code Examples

```dart
// Creating a Lesson from JSON
import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';

void main() {
  final subjects = [
    Subject(name: "Math", teacher: "Mr. Smith", color: Colors.blue, id: 1),
    Subject(name: "Science", teacher: "Ms. Jones", color: Colors.green, id: 2),
  ];

  final json = {
    "lesson_id": 123,
    "subject_id": 1,
    "weekday": 2,
    "alternating_weeks": ["A", "C"],
    "start_time": "09:00",
    "end_time": "09:50",
    "room": "101"
  };

  try {
    final lesson = Lesson.fromJson(json, subjects);
    print("Lesson name: ${lesson.subject.name}");
    print("Lesson start time: ${lesson.temporalData.startTime}");
  } catch (e) {
    print("Error creating lesson: $e