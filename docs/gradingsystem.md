```markdown
# GradingSystem Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose and Responsibilities
The `GradingSystem` subsystem is responsible for defining and validating the rules and structure used to assess student performance.  It encapsulates information about the valid range of marks, modifiers (e.g., '+', '-'), and a collection of `ExamType` objects, which define the individual components contributing to the final grade. Crucially, it handles the complexities of different evaluation methods (percentage-based and multiplication-based) and ensures the validity of the grading scheme.

### How it Fits into the Overall Architecture
This subsystem likely resides within the data model layer of the application. It provides the blueprint for grading. It is crucial for features such as:

*   Calculating final grades.
*   Displaying grade breakdowns.
*   Validating user input related to grading configurations.
*   Data persistence (saving and loading grading system configurations).

Other subsystems that would interact with `GradingSystem` include:

*   **Data Access Layer:**  For persisting and retrieving `GradingSystem` configurations.
*   **User Interface:**  For displaying and editing grading systems.
*   **Calculation Engine:**  For actually calculating grades based on a `GradingSystem`.
*   **Validation Layer:** To ensure grading input adheres to the rules defined within the `GradingSystem`.

### Key Design Patterns and Architectural Decisions

*   **Value Object:** The `GradingSystem` class behaves somewhat like a value object.  Equality is determined by the *content* of the `range`, `modifiers`, and `examTypes` lists (using `ListEquality` from the `collection` package), rather than object identity.  This is appropriate because two `GradingSystem` objects with the same configuration are considered equivalent. The only property that is not part of the equality check is the `id`.
*   **Composition:**  `GradingSystem` *has-a* list of `ExamType` objects.  This is a composition relationship, as the `GradingSystem` conceptually owns and manages its `ExamType` components.
*   **Data Validation:** The `isValid` method enforces a series of rules to ensure the grading system is correctly configured.  This promotes data integrity and prevents errors during grade calculation.
*   **Topological Sort:** The `sortExamTypesForDatabaseInsertion` method implements a topological sort to ensure `ExamType` objects are inserted into the database in the correct order when using the multiplication evaluation method. This is essential for resolving dependencies where one exam type depends on another (multiplication child type).  This avoids database integrity issues.
*   **Factory Pattern:** The `GradingSystem.fromJson` constructor acts as a factory, taking JSON data and constructing a `GradingSystem` object.  This decouples the construction logic from the class itself.

## 2. Code Structure Analysis

### Directory/File Organization

```

Classes/
└── marks/
├── GradingSystem.dart
└── ExamType.dart

```

*   `GradingSystem.dart`: Contains the `GradingSystem` class definition, which is the focus of this documentation.
*   `ExamType.dart`: Contains the `ExamType` class definition, which represents a single exam type and its evaluation method.  `GradingSystem` depends on `ExamType`.

### Dependencies and Relationships with Other Subsystems

*   **`ExamType`:**  `GradingSystem` depends directly on the `ExamType` class.  Changes to `ExamType` will likely require changes to `GradingSystem`.
*   **`collection` package:** Used for `ListEquality` to perform deep equality checks on lists.
*   **Implicit Dependency on Data Persistence Layer:** The `GradingSystem.fromJson` factory method suggests a dependency on a data persistence mechanism (likely JSON-based).

### Class/Module Hierarchies and Their Relationships

The class diagram is relatively simple:

```

GradingSystem *----1 ExamType

```

*   A `GradingSystem` *aggregates* (owns) multiple `ExamType` objects. This is a composition relationship.

## 3. API Documentation

### Public Interfaces

```dart
class GradingSystem {
  final List<String> range;
  final List<String> modifiers;
  final List<ExamType> examTypes;
  final int? id;

  GradingSystem(
      {required this.range,
      required this.modifiers,
      required this.examTypes,
      this.id});

  bool multiplicationExamTypesCircularPatternCheck();
  List<ExamType> sortExamTypesForDatabaseInsertion();
  void isValid();
  factory GradingSystem.fromJson(Map<String, dynamic> gradingSystemJson,
      List<Map<String, dynamic>> examTypeJson);

  @override
  bool operator ==(Object other);
  @override
  int get hashCode;
}
```

### Function/Method Signatures with Parameter Explanations

*
    *
*`GradingSystem({required this.range, required this.modifiers, required this.examTypes, this.id})`
**: Constructor.
    * `range`: `List<String>` - The valid range of marks (e.g., `["0", "100"]`). The ordering of
      elements in the list matters, with the first element indicating the starting point and the
      second indicating the end point of the range.
    * `modifiers`: `List<String>` - A list of possible grade modifiers (e.g., `["+", "-"]`).
    * `examTypes`: `List<ExamType>` - A list of `ExamType` objects that define the components of the
      grading system.
    * `id`: `int?` - An optional identifier for the grading system.

* **`bool multiplicationExamTypesCircularPatternCheck()`**: Checks for circular dependencies in
  the `ExamType` configuration when using the multiplication evaluation method.
    * Parameters: None.
    * Return Type: `bool` - `true` if a circular pattern is detected, `false` otherwise.

* **`List<ExamType> sortExamTypesForDatabaseInsertion()`**: Sorts the `ExamType` objects to ensure
  they can be inserted into a database without violating foreign key constraints (specifically when
  using the multiplication evaluation method).
    * Parameters: None.
    * Return Type: `List<ExamType>` - A sorted list of `ExamType` objects.
    * Throws: `Exception` - If a cyclic dependency is detected and sorting is impossible.

* **`void isValid()`**: Validates the `GradingSystem` to ensure it is correctly configured.
    * Parameters: None.
    * Return Type: `void`
    * Throws: `ArgumentError` - If the `GradingSystem` is invalid, with a descriptive message
      indicating the specific error.

*
    *
*`factory GradingSystem.fromJson(Map<String, dynamic> gradingSystemJson, List<Map<String, dynamic>> examTypeJson)`
**:  A factory constructor that creates a `GradingSystem` from JSON data.
    * `gradingSystemJson`: `Map<String, dynamic>` - A map containing the GradingSystem's data from
      JSON format. This expects keys like "best\_mark", "worst\_mark", "modifiers", and "
      evaluation\_method".
    * `examTypeJson`: `List<Map<String, dynamic>>` - A list of maps, each containing data for an
      ExamType in JSON format. This expects keys like "id", "name", "multiplication\_factor", "
      percentage", and "multiplication\_base".
    * Return Type: `GradingSystem` - A new `GradingSystem` object.

* **`bool operator ==(Object other)`**: Overrides the equality operator to compare `GradingSystem`
  objects based on their content (range, modifiers).
    * `other`: `Object` - The object to compare to.
    * Return Type: `bool` - `true` if the objects are equal, `false` otherwise.

* **`int get hashCode`**: Overrides the `hashCode` getter to provide a hash code based on the
  content of the `GradingSystem`.

### Return Types and Error Handling Patterns

* **Error Handling:** The `isValid` method throws `ArgumentError` exceptions to indicate validation
  failures. This is a standard way to signal invalid object state.
  The `sortExamTypesForDatabaseInsertion` method throws a generic `Exception` if a cycle is
  detected, suggesting a need for a more specific exception type.
* **Return Types:**  Methods generally return either boolean values to indicate success/failure or
  the modified object (e.g., the sorted list of `ExamType` objects).

## 4. Function-Level Documentation

### `multiplicationExamTypesCircularPatternCheck()`

```dart
  bool multiplicationExamTypesCircularPatternCheck() {
    if (examTypes.isEmpty ||
        examTypes[0].evaluationData.evaluationMethod !=
            EvaluationMethod.multiplication) {
      return false;
    }
    List<ExamType> valid = [];
    for (var element in examTypes) {
      if (element.evaluationData.multiplicationChildType == null) {
        // is base type
        valid.add(element);
        continue;
      }

      List<ExamType> visited = [];
      ExamType destination = element.evaluationData.multiplicationChildType!;
      while (destination.evaluationData.multiplicationChildType != null) {
        if (valid.contains(destination)) {
          // if we already know this path is valid we don't need to check further
          for (var element in visited) {
            valid.add(element);
          }
          break;
        }
        if (visited.contains(destination)) {
          // we already visited this exam type -> circular pattern
          return true;
        }
        visited.add(destination);
        destination = destination.evaluationData.multiplicationChildType!;
      }

      for (var element in visited) {
        valid.add(element);
      }
    }

    return false;
  }
```

* **Purpose:** Detects cycles in the `ExamType` graph when using the multiplication evaluation
  method. A cycle occurs when ExamType A depends on ExamType B, which depends on ExamType C, which
  depends on ExamType A.
* **Algorithm:** This function uses a depth-first search approach to traverse the graph
  of `ExamType` dependencies. It maintains a `visited` list to track the nodes visited along the
  current path. If a node is encountered that is already in the `visited` list, a cycle is detected.
  It also utilizes a `valid` List to store Exam Types that are known to have a valid path.
* **Time Complexity:** O(N\*M) where N is the number of Exam Types, and M is the maximum depth of
  the Exam Type dependency chain.
* **Space Complexity:** O(N), where N is the maximum number of Exam Types in the `visited` list at
  any point.
* **Edge Cases:**
    * Empty `examTypes` list: Returns `false` immediately.
    * Non-multiplication evaluation method: Returns `false` immediately.
    * A single `ExamType` referencing itself as its `multiplicationChildType`:  This would be
      detected as a cycle.

### `sortExamTypesForDatabaseInsertion()`

```dart
  List<ExamType> sortExamTypesForDatabaseInsertion() {
    if (examTypes.isEmpty ||
        examTypes[0].evaluationData.evaluationMethod !=
            EvaluationMethod.multiplication) {
      return examTypes;
    }

    List<ExamType> sortedList = [];
    Set<ExamType> seen = {};

    while (sortedList.length != examTypes.length) {
      bool progressMade = false;

      for (var element in examTypes) {
        if ((element.evaluationData.multiplicationChildType == null ||
                sortedList.contains(
                    element.evaluationData.multiplicationChildType)) &&
            !seen.contains(element)) {
          sortedList.add(element);
          seen.add(element);
          progressMade = true;
        }
      }

      if (!progressMade) {
        // check this before! This is only a fallback so the function doesn't run with O(∞) runtime
        throw Exception("Cyclic dependency detected in exam types!");
      }
    }

    return sortedList;
  }
```

* **Purpose:**  Sorts the `ExamType` objects in a way that ensures they can be inserted into a
  database without foreign key violations. When using the multiplication evaluation method,
  an `ExamType` must be inserted *after* its `multiplicationChildType`.
* **Algorithm:** Iterative topological sort. It repeatedly iterates through the `examTypes` list,
  adding `ExamType` objects to the `sortedList` if their `multiplicationChildType` is either null (a
  root node) or already present in the `sortedList`. A `seen` Set is used to keep track of already
  processed `ExamType` to avoid indefinite loops.
* **Time Complexity:** O(N^2) in the worst case, where N is the number of `ExamType` objects. This
  is because the algorithm iterates through the `examTypes` list in a while loop until every element
  is processed. The inner for loop also iterates through the `examTypes` List.
* **Space Complexity:** O(N), where N is the number of `ExamType` objects. This is due to
  the `sortedList` and `seen` set.
* **Edge Cases:**
    * Empty `examTypes` list: Returns the original list immediately.
    * Non-multiplication evaluation method: Returns the original list immediately.
    * Cyclic dependencies: Throws an `Exception` to prevent an infinite loop.
      The `multiplicationExamTypesCircularPatternCheck` function *should* be called before to
      prevent this exception.

### `isValid()`

```dart
  void isValid() {
    if (range.length != 2) {
      throw ArgumentError("Range must have exactly two values. (start, end)");
    }
    if (examTypes.isEmpty) {
      throw ArgumentError("Grading system must have at least one exam type");
    }
    // don't check if range is ordered because of non-numeric values

    bool hasSeenDefaultExamType = false;
    var lastExamEvaluationMethod = examTypes[0].evaluationData.evaluationMethod;
    double sum = 0;
    for (int i = 0; i < examTypes.length; i++) {
      if (lastExamEvaluationMethod !=
          examTypes[i].evaluationData.evaluationMethod) {
        throw ArgumentError(
            "All exam types must have the same evaluation method");
      }

      if (examTypes[i].name.isEmpty) {
        throw ArgumentError("All exam types must have a name");
      }
      if (lastExamEvaluationMethod == EvaluationMethod.percentage &&
          examTypes[i].evaluationData.percentage == null) {
        throw ArgumentError("All percentage exam types must have a percentage");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationFactor == null) {
        throw ArgumentError(
            "All multiplication exam types must have a multiplication factor");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          examTypes[i].evaluationData.multiplicationChildType == null) {
        if (hasSeenDefaultExamType) {
          throw ArgumentError(
              "There must be only one default multiplication exam type");
        } else {
          hasSeenDefaultExamType = true;
        }
      }
      if (examTypes.where((e) => e.name == examTypes[i].name).length > 1) {
        throw ArgumentError("Exam type names must be unique");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.multiplication &&
          (examTypes[i].evaluationData.multiplicationFactor ?? 0) <= 0) {
        throw ArgumentError("Multiplication factor must be greater than zero");
      }

      if (lastExamEvaluationMethod == EvaluationMethod.percentage) {
        sum += examTypes[i].evaluationData.percentage!;
      }
    }

    if (lastExamEvaluationMethod == EvaluationMethod.percentage && sum != 100) {
      throw ArgumentError("The sum of all percentages must be 100");
    }
    if (multiplicationExamTypesCircularPatternCheck()) {
      throw ArgumentError("Multiplication exam types must not form a circle");
    }
  }
```

* **Purpose:**  Validates the `GradingSystem` to ensure it is correctly configured according to
  several criteria.
* **Algorithm:** Performs a series of checks on the `range` and `examTypes` properties.
* **Time Complexity:** O(N), where N is the number of `ExamType` objects. This is due to the loop
  that iterates through the `examTypes` list.
* **Space Complexity:** O(1), as it uses a fixed number of variables regardless of the input size.
  Except for the call to `multiplicationExamTypesCircularPatternCheck()`.
* **Checks Performed:**
    * `range.length == 2`:  The range must have exactly two elements (start and end).
    * `examTypes.isNotEmpty`: The grading system must have at least one exam type.
    * `All exam types must have the same evaluation method`
    * `examTypes[i].name.isNotEmpty`: All exam types must have a name.
    * `percentage != null` if EvaluationMethod is percentage.
    * `multiplicationFactor != null` if EvaluationMethod is multiplication
    * `There must only be one default Multiplication exam type`
    * `Exam type names must be unique`
    * `Multiplication factor must be greater than zero`
    * `The sum of all percentages must be 100`
    * `Multiplication exam types must not form a circle` (
      calls `multiplicationExamTypesCircularPatternCheck()`).

## 5. Data Flow

* **Creation:** `GradingSystem` objects are typically created either programmatically (using the
  constructor) or from JSON data (using the `fromJson` factory method).
* **Validation:** The `isValid` method is called to ensure