# Mark Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The Mark subsystem is responsible for representing and managing academic grading information within
the School Mate application. It provides a flexible and comprehensive model for storing, parsing,
and displaying academic marks across different grading systems.

### Key Architectural Characteristics

- Supports multiple grading systems
- Handles complex mark representations (numeric values, modifiers)
- Provides utilities for mark parsing, display, and calculation
- Integrates with other domain models like Subject and ExamType

## 2. Code Structure Analysis

### Dependencies

- `package:flutter/material.dart`: For color utilities
- `package:collection/collection.dart`: For collection comparisons
- Local dependencies:
    - `ExamType.dart`
    - `GradingSystem.dart`
    - `Subject.dart`

### Class Responsibilities

The `Mark` class is a comprehensive model with the following key responsibilities:

- Store mark metadata (id, creation date)
- Represent mark value with numeric and modifier components
- Parse mark strings
- Generate display representations
- Calculate mark colors
- Support mark combination operations

## 3. API Documentation

### Constructor

```dart
Mark({
  required int id,
  required DateTime createdAt,
  required Subject subject,
  required GradingSystem gradingSystem,
  required ExamType examType,
  required double numericValue,
  String modifier = '',
  required String description,
  required bool isConsidered
})
```

### Static Methods

#### `parse()`

- Parses a mark string into a `Mark` instance
- Supports various input formats (e.g., '2+', '3.5', '4-')
- Throws `FormatException` for invalid inputs

### Public Methods

- `toDisplayString()`: Converts mark to human-readable format
- `toRawString()`: Serialization method for database storage
- `copyWith()`: Creates a new Mark with optional field overrides

## 4. Advanced Features

### Mark Color Generation

The `color` getter implements a sophisticated color mapping:

- Maps mark values to a gradient from green (best) to red (worst)
- Handles reversed and standard grading scales
- Uses linear interpolation for smooth color transitions

### Operator Overloading

The `+` operator allows mark combination with validation:

- Ensures marks are from the same grading system, exam type, and subject
- Combines numeric values while resetting metadata

## 5. Data Flow and Validation

### Input Parsing

- Regex-based parsing of mark strings
- Supports decimal and integer values
- Handles optional modifiers (+/-)

### Grading System Flexibility

- Supports multiple grading ranges (numeric and letter grades)
- Dynamically adjusts display and calculation based on grading system

## 6. Performance Considerations

- Immutable design
- Minimal computational overhead in methods
- Efficient color generation using linear interpolation

## 7. Usage Examples

### Parsing a Mark

```dart
Mark mark = Mark.parse(
  id: 1,
  createdAt: DateTime.now(),
  subject: someSubject,
  gradingSystem: numericGradingSystem,
  examType: midtermExam,
  value: '4+',
  description: 'Math midterm',
  isConsidered: true
);
```

### Color Generation

```dart
Color markColor = mark.color; // Dynamically generated based on mark value
```

## 8. Testing Considerations

- Test parsing with various input formats
- Validate color generation for different mark values
- Check modifier and grading system handling
- Test mark combination and validation

## 9. Potential Improvements

- Add more robust input validation
- Implement more complex grading system conversions
- Add internationalization support for mark representations

## Security Notes

- Use of `clamp()` prevents potential overflow in color generation
- Input parsing includes error handling to prevent invalid mark creation