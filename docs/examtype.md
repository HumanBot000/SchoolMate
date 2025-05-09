# ExamType Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The ExamType subsystem provides a flexible framework for managing different types of examinations
and their evaluation methodologies. It supports two primary evaluation strategies: percentage-based
and multiplication-based calculations.

### Key Architectural Concepts

- Flexible evaluation strategies
- Unique identification of exam types
- Support for complex weighted grading systems

## 2. Code Structure Analysis

### Core Components

- `EvaluationMethod` (Enum)
- `EvaluationData` (Configuration Class)
- `ExamType` (Primary Domain Class)

### Dependency Relationships

- Utilizes Dart's `dart:math` for unique identifier generation
- Tightly coupled between `EvaluationData` and `ExamType`

## 3. Detailed Component Documentation

### 3.1 EvaluationMethod Enum

```dart
enum EvaluationMethod { 
  percentage,  // Average-based calculation
  multiplication  // Weighted/factor-based calculation
}
```

### 3.2 EvaluationData Class

#### Responsibilities

- Configures exam evaluation strategy
- Supports two evaluation methods
- Manages complex grading calculations

#### Constructor Signatures

```dart
EvaluationData({
  required EvaluationMethod evaluationMethod,
  ExamType? multiplicationChildType,
  int? multiplicationFactor,
  double? percentage
})
```

#### Factory Constructors

- `basic()`: Creates default percentage-based evaluation
- `xTimesAs()`: Creates multiplication-based evaluation
- `totalShare()`: Creates 100% percentage evaluation

### 3.3 ExamType Class

#### Key Attributes

- `name`: Human-readable exam type identifier
- `id`: Persistent identifier
- `_uniqueId`: Runtime unique identifier
- `evaluationData`: Evaluation configuration

#### Constructor

```dart
ExamType({
  required String name,
  required int id,
  EvaluationData? evaluationData
})
```

## 4. Evaluation Strategies

### Percentage Method

- Calculates average across exam groups
- Supports weighted calculations
- Example: Group A (30%), Group B (70%)
- Calculation: `(⌀A * 30% + ⌀B * 70%) / 100`

### Multiplication Method

- Allows scaling exam weights
- Supports recursive evaluation across exam types
- Can define how many times a child exam type contributes

## 5. Performance Considerations

### Unique Identification

- Uses `Random().nextInt(1 << 32)` for `_uniqueId`
- Ensures runtime instance differentiation
- O(1) hash generation complexity

### Equality and Hashing

- Custom `==` and `hashCode` implementations
- Supports consistent object comparisons
- Uses `Object.hash()` for efficient hash generation

## 6. Usage Examples

### Percentage-Based Evaluation

```dart
var standardExam = ExamType(
  name: "Midterm",
  id: 1,
  evaluationData: EvaluationData.basic()
);
```

### Multiplication-Based Evaluation

```dart
var complexExam = ExamType(
  name: "Advanced Tests",
  id: 2,
  evaluationData: EvaluationData.xTimesAs(2)
);
```

## 7. Error Handling & Constraints

- No explicit error handling for invalid configurations
- Relies on compile-time type checking
- Recommended to validate `EvaluationData` before usage

## 8. Testing Recommendations

- Test edge cases in evaluation methods
- Verify unique identifier generation
- Check equality and hash code behaviors
- Validate complex nested evaluation scenarios

## 9. Potential Improvements

- Add explicit validation for evaluation configurations
- Implement more robust error handling
- Consider making `EvaluationData` immutable
- Add comprehensive logging for evaluation processes

## 10. Security Considerations

- Random ID generation prevents predictable object identification
- No sensitive data storage in the current implementation

---

**Recommendation**: This subsystem provides a flexible, extensible approach to exam type management
but would benefit from additional runtime validation and more comprehensive documentation of complex
evaluation scenarios.