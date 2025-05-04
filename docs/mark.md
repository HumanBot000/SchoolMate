```markdown
# Mark Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose and Responsibilities
The `Mark` subsystem is responsible for representing and manipulating student marks within the SchoolMate application. It encapsulates all the data associated with a single mark, including the numeric value, modifiers (e.g., '+', '-'), associated subject, exam type, and grading system.  It also provides methods for parsing mark strings, converting marks to displayable strings, performing calculations (e.g., averaging), and determining a color representation based on the mark's value.

### How it Fits into the Overall Architecture
The `Mark` subsystem is a core data model within the SchoolMate application.  It is primarily used by the UI layer for displaying marks, the data persistence layer for storing and retrieving marks, and the calculation engine for computing averages and other performance metrics. It depends on other subsystems like `Subject`, `GradingSystem`, and `ExamType` to define the context of the mark.

### Key Design Patterns and Architectural Decisions
*   **Data Model:** The `Mark` class serves as a central data model.
*   **Value Object:** `Mark` is designed to be immutable after creation. The `copyWith` method allows for creating modified copies.
*   **Parsing and Formatting:**  The `parse` and `toDisplayString` methods encapsulate the logic for converting between string representations and the internal `Mark` representation.
*   **Color Coding:** The `color` property provides a visual representation of the mark's value, which is crucial for quickly assessing student performance.
*   **Operator Overloading:** The `+` operator is overloaded to facilitate the summation of marks, primarily used for calculating averages.
*   **Immutability**: Although `examType` can be changed, the class is largely immutable. This promotes predictability.

## 2. Code Structure Analysis

### Directory/File Organization
*   `Classes/marks/Mark.dart`: Contains the `Mark` class definition.

### Dependencies and Relationships with Other Subsystems
*   **`package:collection/collection.dart`**: Used for `ListEquality` in `GradingSystem` which is related to the string conversion.
*   **`package:flutter/material.dart`**:  Used for the `Color` class in the `color` property and general UI dependencies.
*   **`Subject` (Classes/schedule/Subject.dart)**: Represents the subject the mark is associated with. Each `Mark` instance *has-a* `Subject`.
*   **`GradingSystem` (Classes/marks/GradingSystem.dart)**: Defines the grading scale used to evaluate the mark.  Each `Mark` instance *has-a* `GradingSystem`. This is crucial for interpreting the `numericValue` and `modifier`.
*   **`ExamType` (Classes/marks/ExamType.dart)**: Represents the type of exam the mark is for (e.g., 'Midterm', 'Final').  Each `Mark` instance *has-a* `ExamType`.

### Class/Module Hierarchies and Their Relationships
The `Mark` class is a standalone class with direct relationships to `Subject`, `GradingSystem`, and `ExamType`. There isn't a complex class hierarchy within this subsystem itself.

## 3. API Documentation

### Public Interfaces

```dart
class Mark {
  // Constructor
  Mark({
    required this.id,
    required this.createdAt,
    required this.subject,
    required this.gradingSystem,
    required this.examType,
    required this.numericValue,
    this.modifier = '',
    required this.description,
    required this.isConsidered
  });

  // Static method to parse a string into a Mark instance
  static Mark parse({
    required int id,
    required DateTime createdAt,
    required Subject subject,
    required GradingSystem gradingSystem,
    required ExamType examType,
    required String value,
    required String description,
    required bool isConsidered
  });

  // Method to convert the Mark to a displayable string
  String toDisplayString();

  // Getter for the value to use for calculations
  double get valueForCalculation;

  // Method for serialization to a raw string format
  String toRawString();

  // Getter for the color representation of the mark
  Color get color;

  // Operator overloading for adding two marks
  Mark operator +(Mark other);

  // Method to create a copy of the Mark with optional modifications
  Mark copyWith({
    int? id,
    DateTime? createdAt,
    Subject? subject,
    GradingSystem? gradingSystem,
    ExamType? examType,
    double? numericValue,
    String? modifier,
    String? description,
    bool? isConsidered
  });

  // Override toString method for debugging
  @override
  String toString();
}
```

### Function/Method Signatures with Parameter Explanations

*
    *
*`Mark({required int id, required DateTime createdAt, required Subject subject, required GradingSystem gradingSystem, required ExamType examType, required double numericValue, this.modifier = '', required String description, required bool isConsidered})`
**:
    * `id`:  A unique integer identifier for the mark.
    * `createdAt`: A DateTime object representing when the mark was created.
    * `subject`: The `Subject` the mark belongs to.
    * `gradingSystem`: The `GradingSystem` used to evaluate the mark.
    * `examType`: The `ExamType` the mark is associated with.
    * `numericValue`: The numerical value of the mark.
    * `modifier`: A string representing a modifier (e.g., '+', '-'). Defaults to ''.
    * `description`: A string describing the mark.
    * `isConsidered`: A boolean indicating if the mark should be considered in calculations.

*
    *
*`static Mark parse({required int id, required DateTime createdAt, required Subject subject, required GradingSystem gradingSystem, required ExamType examType, required String value, required String description, required bool isConsidered})`
**:
    * `id`:  A unique integer identifier for the mark.
    * `createdAt`: A DateTime object representing when the mark was created.
    * `subject`: The `Subject` the mark belongs to.
    * `gradingSystem`: The `GradingSystem` used to evaluate the mark.
    * `examType`: The `ExamType` the mark is associated with.
    * `value`: The string representation of the mark (e.g., "2+", "3.5").
    * `description`: A string describing the mark.
    * `isConsidered`: A boolean indicating if the mark should be considered in calculations.

* **`String toDisplayString()`**:
    * No parameters. Converts the internal representation of the mark into a user-friendly string
      for display, taking into account the `GradingSystem` and potential modifiers.

* **`double get valueForCalculation`**:
    * No parameters. Returns the numerical value of the mark, used for calculations.

* **`String toRawString()`**:
    * No parameters. Serializes the mark to a string format suitable for storage, typically without
      extra formatting.

* **`Color get color`**:
    * No parameters. Calculates a color representation of the mark based on its value and
      the `GradingSystem`.

* **`Mark operator +(Mark other)`**:
    * `other`: The `Mark` to add to the current `Mark`. Throws an `ArgumentError` if
      the `GradingSystem`, `ExamType`, or `Subject` of the two marks are different.

*
    *
*`Mark copyWith({int? id, DateTime? createdAt, Subject? subject, GradingSystem? gradingSystem, ExamType? examType, double? numericValue, String? modifier, String? description, bool? isConsidered})`
**:
    * All parameters are optional and nullable. Creates a new `Mark` instance with the same values
      as the original, except for any values explicitly overridden by the parameters.

### Return Types and Error Handling Patterns

* `parse()`: Returns a `Mark` object. Throws a `FormatException` if the input string `value` is not
  a valid mark representation.
* `toDisplayString()`: Returns a `String`.
* `valueForCalculation`: Returns a `double`.
* `toRawString()`: Returns a `String`.
* `color`: Returns a `Color` object from the Flutter `material` library.
* `operator +`: Returns a new `Mark` object representing the sum. Throws an `ArgumentError` if the
  marks are incompatible (different grading systems, exam types or subjects).
* `copyWith()`: Returns a new `Mark` object.

## 4. Function-Level Documentation

### `parse()`

* **Algorithm:**
    1. Uses a regular expression (`r'([0-9]+(?:[.,][0-9]+)?)([+\-]?)'`) to extract the numeric value
       and modifier from the input string.
    2. Parses the numeric value using `double.parse()`, replacing commas with periods to handle
       different locale conventions.
    3. Creates and returns a new `Mark` instance with the parsed values.
* **Time Complexity:**  O(1) - The regular expression matching and parsing operations are generally
  constant time.
* **Space Complexity:** O(1) - The method uses a fixed amount of memory regardless of the input
  string length.
* **Edge Cases:**
    * Throws a `FormatException` if the input string does not match the expected format.
    * Handles both comma and period as decimal separators.
    * Handles missing modifiers.
* **Error Handling**: Uses `try-catch` internally via `double.parse()`.

### `toDisplayString()`

* **Algorithm:**
    1. Checks if the grading system range indicates a letter-based grade. If it does, it uses a
       reverse map to return the appropriate letter.
    2. If the grading system supports decimals, it formats the `numericValue` to one decimal place
       and appends the modifier.
    3. If the grading system does not support decimals, it converts the `numericValue` to an integer
       and appends the modifier.
* **Time Complexity:** O(1) - The operations are constant time. The `if` condition checks a fixed
  number of properties.
* **Space Complexity:** O(1) - The method uses a fixed amount of memory.
* **Edge Cases:**
    * Handles grading systems with and without decimal support.
    * Handles empty modifiers.
    * Uses default values if `numericValue` doesn't match a known key.

### `color`

* **Algorithm:**
    1. Defines a color gradient from green to yellow to red.
    2. Maps the mark's `valueForCalculation` to a position on this gradient based on
       the `GradingSystem`'s range.
    3. Uses `Color.lerp` to interpolate between the colors in the gradient.
* **Time Complexity:** O(1) - The calculations and `Color.lerp` operation are constant time.
* **Space Complexity:** O(1) - The method uses a fixed amount of memory.
* **Edge Cases:**
    * Handles reversed grading systems (where the best value is higher than the worst).
    * Clamps the value to the grading system range to prevent out-of-bounds colors.
    * `double.tryParse` is used to avoid errors in the case of non-numerical grading ranges.

## 5. Data Flow

### Data Movement

1. **Creation/Parsing:** `Mark` objects are either created directly with the constructor or parsed
   from a string using the `parse()` method. The `parse` method receives a string and converts it
   into the internal `Mark` representation.
2. **UI Display:** The `toDisplayString()` method is used to format the `Mark` object for display in
   the UI. The `color` property is used to provide visual feedback based on the mark's value.
3. **Calculations:** The `valueForCalculation` getter provides the numeric value of the mark for
   calculations (e.g., averaging). The `+` operator facilitates mark summation.
4. **Persistence:** The `toRawString()` method is used to serialize the `Mark` object to a string
   format for storage in a database or other persistent storage. The data retrieved would need to be
   converted back using `parse()`.
5. **Modification:**  The `copyWith()` method creates new `Mark` instances with modified properties
   without altering the original object.

### State Management

The `Mark` class is designed to be mostly immutable. Once a `Mark` object is created, its
properties (except `examType`) cannot be changed directly. The `copyWith()` method provides a
mechanism for creating modified copies of the `Mark` object.

### Input Validation and Data Transformation Patterns

* **`parse()`**: Validates the input string format using a regular expression.
* **`color`**: Clamps the mark's value to the grading system range.
* **`operator +`**: Validates that the two `Mark` objects being added have
  compatible `GradingSystem`, `ExamType`, and `Subject`.
* Uses `double.tryParse` to attempt parsing numerical values without throwing exceptions, providing
  safer fallback behavior.

## 6. Implementation Details

### Language-Specific Implementation Details

* **Dart:** The code leverages Dart's strong typing, named parameters, and operator overloading
  features.
* **Flutter:** The code uses the `Color` class from the Flutter `material` library for representing
  colors.

### Performance Optimizations

* The `parse()` method uses a regular expression for efficient string parsing.
* The `color` property uses `Color.lerp` for efficient color interpolation.

### Security Considerations

* When persisting marks (using `toRawString`), ensure that the data is properly sanitized to prevent
  injection attacks.
* When displaying marks in the UI (using `toDisplayString`), ensure that the data is properly
  escaped to prevent cross-site scripting (XSS) attacks.

## 7. Common Usage Patterns

### Code Examples

```dart
// Creating a Mark instance
import 'package:school_mate/Classes/marks/Mark.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';

void main() {
  final subject = Subject(id: 1, name: 'Mathematics', teacher: 'Dr. Smith');
  final gradingSystem = GradingSystem(id: 1, name: 'Standard', range: ["1", "6"], modifiers: []);
  final examType = ExamType(id: 1, name: 'Midterm');

  final mark = Mark(
    id: 1,
    createdAt: DateTime.now(),
    subject: subject,
    gradingSystem: gradingSystem,
    examType: examType,
    numericValue: 4,
    modifier: '+',
    description: 'Good performance',
    isConsidered: true,
  );

  // Converting the Mark to a displayable string
  print(mark.toDisplayString()); // Output: 4 +

  // Getting the color representation of the mark
  print(mark.color); // Output: Color(0xffffff00) (Yellow)

    // Parsing a mark string
  final parsedMark = Mark.parse(
      id: 2,
      createdAt: DateTime.now(),
      subject: subject,
      gradingSystem: gradingSystem,
      examType: examType,
      value: '3.5',
      description: 'Average',
      isConsidered: true);
  print(parsedMark.toDisplayString()); // Output: 3.5

}
```

### Best Practices

* Use the `parse()` method to create `Mark` instances from string representations.
* Use the `toDisplayString()` method to format `Mark` instances for display in the UI.
* Use the `color` property to provide visual feedback based on the mark's value.
* Use the `copyWith()` method to create modified copies of `Mark` instances.
* When summing marks, ensure they have compatible grading systems, exam types and subjects.

### Antipatterns

* Directly modifying the properties of a `Mark` instance (except `examType`). Use the `copyWith()`
  method instead.
* Creating `Mark` instances without proper validation of the input values.
* Ignoring the `GradingSystem` when displaying or calculating with `Mark` instances.
* Not handling potential `FormatException` errors when using `parse()`.
* Performing mathematical operations on marks without checking for
  compatible `GradingSystem`, `ExamType`, and `Subject`.

## 8. Testing Approach

### Testing Strategy

The `Mark` subsystem should be tested using unit tests to ensure the correctness of
the `parse()`, `toDisplayString()`, `color`, `+` operator, and `copyWith()` methods. Mock objects
should be used to isolate the `Mark` class from its
dependencies (`Subject`, `GradingSystem`, `ExamType`).

### Test Coverage Analysis

Test cases should cover the following scenarios:

* Valid and invalid mark string formats for `parse()`.
* Different `GradingSystem` configurations for `toDisplayString()` and `color`.
* Adding `Mark` instances with compatible and incompatible grading systems, exam types and subjects.
* Modifying different properties of a `Mark` instance using `copyWith()`.
* Edge cases for `valueForCalculation`, such as handling null or invalid values.

### Mocking Strategies for Dependencies

* Create mock implementations of `Subject`, `GradingSystem`, and `ExamType` to isolate the `Mark`
  class during testing.
* Use mocking frameworks to define the behavior of the mock objects and verify that the `Mark` class
  interacts with them correctly.

```