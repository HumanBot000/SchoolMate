# GradingSystem Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The `GradingSystem` subsystem is responsible for managing the complex logic of grading and exam type
evaluation in an educational management system. It provides a flexible and robust mechanism for
defining grading ranges, modifiers, and exam type evaluation methods.

### Key Architectural Characteristics

- Supports multiple evaluation methods (percentage, multiplication)
- Handles complex exam type relationships
- Provides comprehensive validation and integrity checks
- Supports JSON serialization/deserialization

## 2. Code Structure Analysis

### Class Structure

```dart
class GradingSystem {
  final List<String> range;           // Grading range (best and worst marks)
  final List<String> modifiers;       // Grade modifiers (e.g., '+', '-')
  final List<ExamType> examTypes;     // Collection of exam types
  final int? id;                      // Optional identifier
}
```

### Dependencies

- `collection` package for list equality comparisons
- `ExamType` class from marks module
- Depends on `EvaluationMethod` enum

## 3. API Documentation

### Constructor

```dart
GradingSystem({
  required List<String> range,
  required List<String> modifiers,
  required List<ExamType> examTypes,
  int? id
})
```

- `range`: Two-element list representing best and worst marks
- `modifiers`: List of grade modifier symbols
- `examTypes`: Collection of exam types for this grading system
- `id`: Optional unique identifier

### Key Methods

#### `isValid()`

- Validates the entire grading system configuration
- Checks:
    - Range has exactly two values
    - At least one exam type exists
    - Consistent evaluation methods
    - Unique exam type names
    - Percentage totals (if applicable)
    - Prevents circular multiplication dependencies

#### `multiplicationExamTypesCircularPatternCheck()`

- Implements cycle detection algorithm for exam type relationships
- Prevents circular references in multiplication-based exam types

#### `sortExamTypesForDatabaseInsertion()`

- Performs topological sorting of exam types
- Ensures correct insertion order for exam types with dependencies

## 4. Advanced Implementation Details

### Cycle Detection Algorithm

The `multiplicationExamTypesCircularPatternCheck()` method uses a graph traversal technique to
detect circular dependencies:

- Iterates through exam types
- Tracks visited exam types
- Detects cycles by identifying repeated exam types in traversal path

### Exam Type Validation Rules

- All exam types must have the same evaluation method
- Percentage exam types must total 100%
- Multiplication exam types must have valid factors
- Only one default multiplication exam type allowed

## 5. Performance Considerations

### Complexity Analysis

- `isValid()`: O(n²) worst case due to nested iterations
- `multiplicationExamTypesCircularPatternCheck()`: O(n²)
- `sortExamTypesForDatabaseInsertion()`: O(n²)

### Optimization Notes

- Methods are designed for small collections (< 10 exam types)
- Uses early-exit strategies for performance

## 6. Security and Validation

### Input Validation Strategies

- Comprehensive input validation in `isValid()`
- Prevents invalid configuration states
- Throws descriptive `ArgumentError` for configuration issues

## 7. Usage Examples

### Creating a Grading System

```dart
var gradingSystem = GradingSystem(
  range: ['0', '100'],
  modifiers: ['+', '-'],
  examTypes: [
    ExamType(...),  // Configure exam types
  ]
);

// Validate configuration
gradingSystem.isValid();
```

## 8. Testing Considerations

### Test Scenarios

- Valid grading system configurations
- Invalid range specifications
- Circular exam type dependencies
- Percentage and multiplication evaluation methods
- Edge cases in exam type relationships

### Recommended Test Coverage

- Unit tests for validation methods
- Integration tests for JSON serialization
- Boundary condition tests for exam type configurations

## 9. Error Handling

Throws `ArgumentError` with descriptive messages for:

- Invalid range configurations
- Inconsistent exam type definitions
- Circular exam type dependencies
- Percentage total discrepancies

## Conclusion

The `GradingSystem` subsystem provides a robust, flexible framework for managing complex grading
configurations with comprehensive validation and integrity checks.