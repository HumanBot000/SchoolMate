```markdown
# AddMarkSubjectSelector Subsystem Technical Documentation

This document provides a detailed technical overview of the `AddMarkSubjectSelector` subsystem within the `school_mate` application. This subsystem is responsible for displaying a list of subjects fetched from the schedule and allowing the user to select one for adding a mark.

## 1. Subsystem Overview

### Purpose and Responsibilities

The primary responsibility of the `AddMarkSubjectSelector` subsystem is to:

*   Fetch the user's schedule data, specifically the list of subjects.
*   Display the subjects in a selectable list.
*   Allow the user to select a subject, which is then passed to a callback function.
*   Handle potential errors and empty states during data fetching.

### How it Fits into the Overall Architecture

This subsystem is part of the "add mark" flow within the application. It sits between the UI elements that initiate the "add mark" action and the subsequent components that handle the mark input and storage. The subsystem relies on the `Schedule` API (through `fetchSchedule()`) to retrieve subject data and uses the `SubjectListWidget` for rendering the list of subjects.

### Key Design Patterns and Architectural Decisions

*   **FutureBuilder Pattern:** The `FutureBuilder` widget is used to asynchronously fetch schedule data and handle different states (loading, error, success).
*   **Callback Function:** The `onSelection` callback allows the parent widget to receive the selected subject and proceed with the mark addition process.
*   **Widget Composition:** The `AddMarkSubjectSelector` reuses the `SubjectListWidget` to display the list of subjects, promoting code reusability and maintainability.
*   **Error Handling:** Displays an informative error message if the schedule data cannot be fetched.  Provides an informative message if no subjects are found.

## 2. Code Structure Analysis

### Directory/File Organization

The subsystem resides within the following file:

*   `pages\home\marks\add\subpages\subject.dart`

This location suggests that this component is a sub-page within the "add mark" flow, which itself is under the "marks" section of the home page.

### Dependencies and Relationships with Other Subsystems

*   **`flutter/material.dart`:**  Provides the core Flutter UI widgets.
*   **`school_mate/API/supabase/schedule/schedule.dart`:** Provides the `fetchSchedule()` function for retrieving schedule data from the Supabase database (or a mock).
*   **`school_mate/Classes/schedule/Subject.dart`:** Defines the `Subject` class, representing a subject in the schedule.
*   **`school_mate/pages/home/schedule/subjects/SubjectListWidget.dart`:** Provides the `SubjectListWidget` for displaying a list of subjects in a user-friendly manner.

### Class/Module Hierarchies and Their Relationships

The primary class within this subsystem is `AddMarkSubjectSelector`, a `StatelessWidget`.

```

StatelessWidget
└── AddMarkSubjectSelector

```

*   `AddMarkSubjectSelector` depends on `SubjectListWidget` for rendering and interacts with the `fetchSchedule` API function.
*   `SubjectListWidget` receives a list of `Subject` objects as input.

## 3. API Documentation

### Public Interfaces

The `AddMarkSubjectSelector` widget has a single public interface element:

*   **Constructor:** `AddMarkSubjectSelector({super.key, required this.onSelection})`

### Function/Method Signatures with Parameter Explanations

*   **`AddMarkSubjectSelector({Key? key, required this.onSelection})`**
    *   **`key` (Key?):**  Optional Flutter key for the widget.
    *   **`onSelection` (Function(Subject)):**  A callback function that is called when a subject is selected.  The selected `Subject` object is passed as an argument to this function.

### Return Types and Error Handling Patterns

*   The `build` method returns a `Widget`.
*   Error handling is managed within the `FutureBuilder`. If an error occurs during the `fetchSchedule` operation, an error message is displayed.  If the schedule data exists but contains no subjects, a "No subjects found" message is displayed.

## 4. Function-Level Documentation

This section will focus on key functions within the `AddMarkSubjectSelector`.  The `build` method is the most complex function, so it will be described in detail.

### `build(BuildContext context)`

This method is overridden from the `StatelessWidget` class and is responsible for building the UI of the widget.

```dart
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchSchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data is String && snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No subjects found. Please set them up in the schedule tab first.',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Expanded(
              child: SubjectListWidget(
                subjects: snapshot.data!.subjects,
                popAfterSelection: false,
                onSubjectSelected: (selectedSubject) =>
                    onSelection(selectedSubject),
              ),
            );
          }
          return Container();
        });
  }
```

* **Algorithm:**
    1. Uses a `FutureBuilder` to asynchronously fetch the schedule data using `fetchSchedule()`.
    2. Handles different states of the `Future`:
        * **`ConnectionState.waiting`:** Displays a `CircularProgressIndicator`.
        * **`snapshot.hasError`:** Displays an error message.
        * **`snapshot.hasData`:**  If the data is an empty string, displays a "No subjects found"
          message. Otherwise, renders the `SubjectListWidget` with the fetched subjects.
        * **Default:** Returns an empty `Container`.
    3. The `SubjectListWidget`'s `onSubjectSelected` callback is set to call the `onSelection`
       callback passed to `AddMarkSubjectSelector`, passing the selected subject.

* **Time/Space Complexity:**  The time complexity is dominated by the `fetchSchedule()` call, which
  depends on the implementation of that function. The rendering of the `SubjectListWidget` also has
  a time complexity dependent on the number of subjects. The space complexity depends on the size of
  the schedule data fetched.

* **Edge Cases and Handling:**
    * **Network errors:** Handled by `snapshot.hasError`.
    * **Empty schedule data (no subjects):** Handled by
      checking `snapshot.data is String && snapshot.data!.isEmpty`.
    * **Loading state:** Handled by `ConnectionState.waiting`.
    * **`fetchSchedule` returns null data:** Although not explicitly handled, the `snapshot.hasData`
      check combined with the empty string check will prevent errors if `fetchSchedule` returns
      null. However, it's best practice for `fetchSchedule` to throw an error in case of failure, so
      the error case can be correctly displayed in the UI.

## 5. Data Flow

1. The `AddMarkSubjectSelector` widget is initialized with an `onSelection` callback.
2. The `build` method calls `fetchSchedule()` to retrieve schedule data.
3. The `FutureBuilder` manages the asynchronous data fetching.
4. Once the data is fetched successfully:
    * The `subjects` list from the fetched schedule data is passed to the `SubjectListWidget`.
5. The user interacts with the `SubjectListWidget` and selects a subject.
6. The `SubjectListWidget` calls its internal `onSubjectSelected` callback.
7. The `onSubjectSelected` callback in `SubjectListWidget` then calls the `onSelection` callback
   passed to `AddMarkSubjectSelector`, passing the selected `Subject` object.
8. The parent widget receives the selected `Subject` object via the `onSelection` callback and can
   proceed with adding the mark for the selected subject.

The `AddMarkSubjectSelector` doesn't directly manage any persistent state. The data is fetched and
passed down to the `SubjectListWidget`. The parent widget manages the state related to the overall "
add mark" process.

Input validation is handled (or should be handled) by the `fetchSchedule` function. The assumption
is that the returned `Subject` objects are valid. The `SubjectListWidget` might also perform some
internal validation if required.

## 6. Implementation Details

* **Language:** Dart
* **Framework:** Flutter
* **Asynchronous Operations:** Uses `FutureBuilder` and `async/await` (implicitly
  within `fetchSchedule`) for handling asynchronous data fetching.
* **Immutability:** `AddMarkSubjectSelector` is a `StatelessWidget`, promoting immutability and
  predictable behavior.

### Performance Optimizations

* The `FutureBuilder` efficiently handles the asynchronous data fetching without blocking the UI
  thread.
* The `SubjectListWidget` can be further optimized (e.g., using `ListView.builder` with
  appropriate `itemExtent`) if the number of subjects is very large.
* Consider using a `StreamBuilder` if the schedule is subject to live updates.

### Security Considerations

* Ensure that the `fetchSchedule()` function properly authenticates and authorizes the user before
  retrieving schedule data.
* Sanitize and validate any user input related to subject selection (although in this case, the
  selection is limited to the provided list).

## 7. Common Usage Patterns

### Code Example:

```dart
import 'package:flutter/material.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/pages/home/marks/add/subpages/subject.dart';

class AddMarkPage extends StatefulWidget {
  const AddMarkPage({super.key});

  @override
  State<AddMarkPage> createState() => _AddMarkPageState();
}

class _AddMarkPageState extends State<AddMarkPage> {
  Subject? _selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Mark')),
      body: Column(
        children: [
          const Text('Select a Subject:'),
          Expanded(
            child: AddMarkSubjectSelector(
              onSelection: (subject) {
                setState(() {
                  _selectedSubject = subject;
                });
                print('Selected subject: ${subject.name}');
              },
            ),
          ),
          if (_selectedSubject != null)
            Text('You selected: ${_selectedSubject!.name}'),
          // Add mark input fields and save button here...
        ],
      ),
    );
  }
}
```

### Best Practices for Interacting with this Subsystem

* Always handle the `onSelection` callback to receive the selected subject.
* Consider displaying a loading indicator while the schedule data is being fetched.
* Handle potential errors and empty states gracefully.

### Antipatterns to Avoid

* Modifying the `Subject` objects directly within the `AddMarkSubjectSelector`. The `Subject`
  objects should be treated as immutable within this widget.
* Performing long-running operations directly within the `build` method. Use `FutureBuilder` or
  other asynchronous mechanisms for data fetching.

## 8. Testing Approach

### How this Subsystem is Tested

The `AddMarkSubjectSelector` can be tested using Flutter's widget testing framework. Tests should
cover the following scenarios:

* **Loading state:** Verify that the `CircularProgressIndicator` is displayed while data is loading.
* **Error state:** Verify that the error message is displayed when `fetchSchedule()` fails.
* **Empty state:** Verify that the "No subjects found" message is displayed when there are no
  subjects in the schedule.
* **Successful data fetching:** Verify that the `SubjectListWidget` is displayed with the correct
  subjects.
* **Selection callback:** Verify that the `onSelection` callback is called with the
  correct `Subject` object when a subject is selected.

### Test Coverage Analysis

Ideally, the tests should achieve close to 100% branch coverage for the `build` method, ensuring
that all states and error conditions are properly handled.

### Mocking Strategies for Dependencies

* **`fetchSchedule()`:**  Create a mock implementation of `fetchSchedule()` that returns different
  states (loading, error, success, empty) to simulate various scenarios. You can use libraries
  like `mockito` for this purpose.
* **`SubjectListWidget`:**  While you could mock the `SubjectListWidget`, it's generally better to
  test the integration of `AddMarkSubjectSelector` with the real `SubjectListWidget`. If
  the `SubjectListWidget` has complex dependencies, you might consider mocking them.

```