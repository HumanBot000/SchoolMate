# Lesson Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The Lesson subsystem is responsible for representing and managing individual lesson instances within
a school schedule. It extends the Subject class and provides detailed temporal and location-specific
information about academic lessons.

### Key Architectural Components

- `Lesson`: Primary class representing a lesson
- `LessonTemporalData`: Value object encapsulating temporal characteristics of a lesson

### Design Patterns

- Factory Constructor Pattern: Used in `Lesson.fromJson()` for object creation
- Composition: `Lesson` composes a `Subject` and `LessonTemporalData`

## 2. Code Structure

### Key Classes

1. `Lesson`
    - Extends `Subject`
    - Represents a specific lesson instance

2. `LessonTemporalData`
    - Encapsulates temporal scheduling details
    - Manages lesson timing and alternating week logic

### Dependencies

- `flutter/material.dart`: For `TimeOfDay`
- `intl/intl.dart`: For date parsing
- Custom utilities: `dates.dart`, `alphabet.dart`

## 3. API Documentation

### `Lesson` Class

```dart
class Lesson extends Subject {
  final int lessonID;
  final Subject subject;
  final LessonTemporalData temporalData;
  final String? location;

  Lesson(
    int lessonID, 
    Subject subject, 
    LessonTemporalData temporalData, 
    String? location
  )
}
```

#### Constructor Parameters

- `lessonID`: Unique identifier for the lesson
- `subject`: Parent subject information
- `temporalData`: Scheduling and timing details
- `location`: Optional lesson location/room

### Factory Constructor

```dart
factory Lesson.fromJson(
  Map<String, dynamic> json, 
  List<Subject> subjects
)
```

#### Responsibilities

- Parses JSON lesson data
- Matches subject from provided subject list
- Constructs `LessonTemporalData` with parsed information

## 4. `LessonTemporalData` Details

### Key Properties

```dart
class LessonTemporalData {
  final int weekday;
  final List<String> alternatingWeeks;
  final List<int> numericalAlternatingWeeks;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
}
```

#### Computed Properties

- `duration`: Calculates lesson duration
- `startDateTime`: Generates absolute start time reference

### Alternating Week Logic

- Supports complex scheduling with alternating week patterns
- Uses alphabetic week identifiers (e.g., ["A", "C"])
- Provides numerical week indexes for programmatic access

## 5. Data Flow & Parsing

### JSON Parsing Process

1. Receive JSON lesson data
2. Locate corresponding `Subject`
3. Parse time information using `DateFormat`
4. Convert alternating weeks to numerical indexes
5. Create `Lesson` instance

### Time Parsing Example

```dart
TimeOfDay.fromDateTime(DateFormat('HH:mm').parse(json["start_time"]))
```

## 6. Performance Considerations

- Lightweight immutable data structure
- Efficient time and week indexing
- Minimal computational overhead in parsing

## 7. Usage Example

```dart
// Creating a Lesson from JSON
Lesson lesson = Lesson.fromJson(jsonData, availableSubjects);

// Accessing lesson properties
print(lesson.subject.name);
print(lesson.temporalData.startTime);
print(lesson.location);
```

## 8. Testing Considerations

- Validate JSON parsing
- Test alternating week logic
- Verify time conversion accuracy
- Check subject matching mechanism

### Potential Test Scenarios

- Parsing complete/partial JSON data
- Handling missing optional fields
- Verifying time calculations
- Testing alternating week edge cases

## 9. Potential Improvements

- Add more robust error handling in `fromJson`
- Implement week conflict detection
- Create more comprehensive validation methods

## Conclusion

The Lesson subsystem provides a flexible, type-safe representation of academic lessons with
sophisticated temporal scheduling capabilities.