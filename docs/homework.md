```markdown
# Homework Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose and Responsibilities

The Homework subsystem is responsible for managing homework assignments within the SchoolMate application. It provides functionality to:

-   Display homework assignments.
-   Mark homework assignments as complete or incomplete.
-   Add new homework assignments.
-   Edit existing homework assignments.
-   Delete homework assignments.
-   Associate homework with specific subjects.
-   Handle attachments for homework assignments.

### How it Fits into the Overall Architecture

The Homework subsystem interacts with the following parts of the application:

-   **API Layer (Supabase):**  It relies on the Supabase API to persist homework data, subject data, and completion statuses to a remote database.  Specifically, it uses the `homeworks/tasks.dart` and `schedule/subjects.dart` APIs.
-   **Schedule Subsystem:** The Homework subsystem depends on the Schedule subsystem to retrieve subject information and schedule details. This dependency is evident in `Homework.dart` when creating a `Homework` instance from JSON, requiring fetching the subject, and in `HomeworkPage.dart` when creating a new Homework, requiring the schedule to be set up first.
-   **UI Layer:** It provides UI components for displaying and interacting with homework data via the `HomeworkPage`.
-   **Add Homework Page:** It uses `AddHomeworkPage` to create new Homeworks.

### Key Design Patterns and Architectural Decisions

-   **Data Model (`Homework` class):** The `Homework` class represents the core entity in this subsystem.  It encapsulates all relevant information about a homework assignment.
-   **Asynchronous Data Fetching:**  Data is primarily fetched asynchronously from the Supabase backend, leveraging `Future`s and `async/await`.
-   **State Management (using `setState`):** The `HomeworkPage` uses `setState` for simple state management to trigger UI updates when data changes (e.g., toggling completion, deleting a task). This is a straightforward approach suitable for the relatively simple state management needs of this page.
-   **Tabbed Interface:** The `HomeworkPage` utilizes a tabbed interface to separate open and completed homework assignments.
-   **Navigation:** The subsystem uses Flutter's `Navigator` to navigate between different pages, like the `AddHomeworkPage` and the `ScheduleSetupPage`.
-   **Error Handling:** Basic error handling is implemented via `try...catch` blocks in Supabase API calls and by displaying error messages on the UI through `SnackBar` widgets.

## 2. Code Structure Analysis

### Directory/File Organization

```

Classes/
homeworks/
Homework.dart # Defines the Homework data model

pages/
home/
homework/
Homework.dart # Implements the HomeworkPage widget (UI)
Widgets/
HomeworkBox.dart # A widget to display a single homework item
add/
AddHomework.dart # Page to add new homework assignments

```

### Dependencies and Relationships with Other Subsystems

-   **`Homework.dart`:** Depends on `school_mate/API/supabase/homeworks/tasks.dart` (for API calls to manage homework tasks) and `school_mate/API/supabase/schedule/subjects.dart` (for fetching subject information).  Also, depends on `school_mate/Classes/schedule/Subject.dart` as the Subject entity is a core property.
-   **`HomeworkPage.dart`:** Depends on `school_mate/API/supabase/homeworks/tasks.dart` (for fetching homework tasks), `school_mate/Classes/homeworks/Homework.dart` (for the `Homework` data model), `school_mate/pages/home/Widgets/BottomNavBar.dart`, `school_mate/pages/home/homework/Widgets/HomeworkBox.dart`, `school_mate/pages/home/homework/add/AddHomework.dart` and `school_mate/pages/home/schedule/setup/scheduleSetup.dart`. It also depends on `school_mate/main.dart` for logging purposes (accessing the `logger` instance).

### Class/Module Hierarchies and Their Relationships

-   **`Homework` Class:** This is the core data class.  It does not inherit from any other classes.
-   **`HomeworkPage` Class:** This is a `StatefulWidget` that manages the UI for displaying and interacting with homework.  It has a corresponding `_HomeworkPageState` class that holds the state for the page.  It uses `HomeworkBox` widgets to display individual homework items.

## 3. API Documentation

### `Homework` Class

```dart
class Homework {
  final int taskID;
  final String title;
  final String note;
  final bool isCompleted;
  final DateTime? dueDate;
  final bool handIn;
  final List<Uri> attachments;
  final DateTime? createdAt;
  final Subject subject;

  Homework(this.subject, this.taskID, this.title,
      {this.isCompleted = false,
      this.note = "",
      this.attachments = const [],
      this.handIn = false,
      this.dueDate,
      this.createdAt});

  // Factory method to create a Homework instance from a JSON object
  static Future<Homework> fromJson(Map<String, dynamic> json) async;

  // Toggles the completion status of a homework task
  Future<void> toggleCompletion() async;
}
```

#### `Homework` Constructor

```dart
Homework(
  this.subject,      // Subject: The subject to which the homework belongs.
  this.taskID,       // int: The unique identifier for the homework task.
  this.title,        // String: The title of the homework assignment.
  {
    this.isCompleted = false,  // bool: Whether the homework is completed (default: false).
    this.note = "",             // String: Any additional notes about the homework (default: "").
    this.attachments = const [], // List<Uri>: A list of URIs to attached files (default: empty list).
    this.handIn = false,        // bool: Whether the homework needs to be handed in physically (default: false).
    this.dueDate,              // DateTime?: The due date for the homework (optional).
    this.createdAt             // DateTime?: The creation timestamp (optional).
  }
)
```

#### `fromJson(Map<String, dynamic> json)`

```dart
static Future<Homework> fromJson(Map<String, dynamic> json) async
```

- **Purpose:**  Creates a `Homework` object from a JSON representation. This is crucial for
  deserializing data received from the Supabase API.
- **Parameters:**
    - `json`: A `Map<String, dynamic>` representing the JSON data. Expected keys
      include: `homework_id`, `title`, `completed`, `note`, `attachments`, `submit`, `complete_due`, `created_at`,
      and `subject_id`.
- **Return Type:** `Future<Homework>`: A Future that resolves to a `Homework` object. The `Future`
  is necessary because fetching the `Subject` requires an asynchronous operation.
- **Error Handling:**  If the JSON data is malformed, exceptions might be thrown during parsing (
  e.g., `DateTime.parse`). The Supabase API layer is assumed to handle potential errors at the data
  retrieval level.
- **Implementation Details:**
    - Parses the `attachments` field, converting a list of string URLs to a list of `Uri` objects.
    - Uses `DateTime.parse` to convert date/time strings to `DateTime` objects. It converts the
      datetime to local time using `toLocal()`.
    - Fetches the `Subject` object using `fetchSubjectByID(json["subject_id"])`. This is an
      asynchronous operation.
- **Example:**

  ```dart
  final json = {
    "homework_id": 123,
    "title": "Math Assignment",
    "completed": false,
    "note": "Solve problems 1-10",
    "attachments": ["https://example.com/attachment1.pdf"],
    "submit": true,
    "complete_due": "2024-12-25T12:00:00Z",
    "created_at": "2024-12-20T08:00:00Z",
    "subject_id": 1
  };

  Homework.fromJson(json).then((homework) {
    print(homework.title); // Output: Math Assignment
  });
  ```

#### `toggleCompletion()`

```dart
Future<void> toggleCompletion() async
```

- **Purpose:** Toggles the completion status of the homework assignment. This method updates the
  status both locally (in the object) and remotely (in the database via the API).
- **Parameters:** None
- **Return Type:** `Future<void>`: A Future that completes when the completion status has been
  successfully updated in the database.
- **Error Handling:**  Relies on the `changeTaskCompletionStatus` function to handle any errors that
  might occur during the API call. Any errors should be handled and potentially displayed to the
  user by that function.
- **Implementation Details:**
    - Calls the `changeTaskCompletionStatus(this)` function to update the completion status in the
      Supabase database.

### `HomeworkPage` Class

This class is a UI `StatefulWidget`, so there is no explicit API to document outside of its
lifecycle methods (`initState`, `dispose`, `build`). The methods defined within
the `_HomeworkPageState` are mostly for internal use within the widget. However, some key methods
are:

#### `_onCompletionToggle(Homework homework)`

```dart
Future<void> _onCompletionToggle(Homework homework) async
```

- **Purpose:** Handles the toggling of a homework item's completion status.
- **Parameters:**
    - `homework`: The `Homework` object whose completion status is to be toggled.
- **Return Type:** `Future<void>`:  A Future that completes after the status is toggled.
- **Implementation Details:**
    - Calls `homework.toggleCompletion()` to update the completion status.
    - The UI is automatically updated via `setState` in the `HomeworkBox` to reflect the change.

#### `_deleteDialog(Offset offset, Homework homework)`

```dart
void _deleteDialog(Offset offset, Homework homework)
```

- **Purpose:**  Displays a dialog to confirm the deletion of a homework assignment.
- **Parameters:**
    - `offset`:  The screen coordinates where the dialog should be displayed.
    - `homework`: The `Homework` object to be deleted.
- **Return Type:** `void`
- **Implementation Details:**
    - Uses `showDialog` to display a confirmation dialog.
    - If the user confirms the deletion, it calls `deleteTask(homework)` to remove the task from the
      database.
    - Updates the local `tasks` list using `setState` to reflect the deletion.

## 4. Function-Level Documentation

This section focuses on providing detailed explanations of complex algorithms and functions,
time/space complexity analysis where relevant, and edge case handling.

### `Homework.fromJson(Map<String, dynamic> json)`

This function is critical for converting data from the Supabase API into `Homework` objects.

- **Algorithm:**
    1. Extract values from the JSON map for each field in the `Homework` class.
    2. Parse the `attachments` list by iterating through the string URLs and converting each to
       a `Uri` object. If `attachments` is `null`, initialize `parsedAttachments` as an empty list.
    3. Parse `complete_due` and `created_at` from strings to `DateTime` objects
       using `DateTime.parse()`. Handle the case where `complete_due` might be `null`. Convert the
       datetime to local time.
    4. Fetch the `Subject` object asynchronously using `fetchSubjectByID(json["subject_id"])`.
    5. Construct and return a new `Homework` object.
- **Time Complexity:** O(n), where n is the number of attachments. The `fetchSubjectByID` call
  likely has its own time complexity depending on the API implementation.
- **Space Complexity:** O(n), where n is the number of attachments (due to the creation of
  the `parsedAttachments` list).
- **Edge Cases and Handling:**
    - **`attachments` is null:** The code handles this case by initializing `parsedAttachments` to
      an empty list (`[]`).
    - **`complete_due` is null:** The code handles this case by assigning `null` to the `dueDate`
      property of the `Homework` object.
    - **Invalid URL in `attachments`:** The `Uri.parse` method might throw an exception if a URL is
      invalid. This is not explicitly handled in the current code. A `try...catch` block could be
      added to handle this.
    - **`fetchSubjectByID` fails:**  The code relies on the `fetchSubjectByID` function to handle
      errors.

## 5. Data Flow

1. **Fetching Homework Data:**
    - The `HomeworkPage` calls the `fetchHomeworks()` function (defined in the API layer,
      specifically `school_mate/API/supabase/homeworks/tasks.dart`).
    - `fetchHomeworks()` makes a request to the Supabase API to retrieve homework data.
    - The Supabase API returns a list of JSON objects representing homework assignments.
    - `fetchHomeworks()` iterates through the JSON list, calling `Homework.fromJson()` for each JSON
      object to create a `Homework` object.
    - The list of `Homework` objects is returned to the `HomeworkPage`.
2. **Displaying Homework Data:**
    - The `HomeworkPage` stores the list of `Homework` objects in its state.
    - The `build` method of `HomeworkPage` uses the `HomeworkBox` widget to display each `Homework`
      object in the list.
3. **Toggling Completion Status:**
    - The user interacts with the `HomeworkBox` to toggle the completion status of a homework
      assignment.
    - The `HomeworkBox` calls the `_onCompletionToggle` method in the `HomeworkPage`.
    - `_onCompletionToggle` calls the `homework.toggleCompletion()` method.
    - `homework.toggleCompletion()` calls the `changeTaskCompletionStatus(this)` function (defined
      in the API layer).
    - `changeTaskCompletionStatus` sends a request to the Supabase API to update the completion
      status of the homework assignment in the database.
4. **Adding a New Homework:**
    - The user navigates to the `AddHomeworkPage`.
    - The user enters the homework details and saves the assignment.
    - The `AddHomeworkPage` uses an API call to save the new homework in the Supabase database.
    - After successful creation, the user navigates back to the `HomeworkPage`. The `HomeworkPage`
      then re-fetches the homework list.
5. **Deleting a Homework:**
    - The user long-presses a `HomeworkBox` to trigger the `_deleteDialog` method in
      the `HomeworkPage`.
    - The `_deleteDialog` displays a confirmation dialog.
    - If the user confirms the deletion, the `deleteTask` function (defined in the API layer) is
      called.
    - `deleteTask` sends a request to the Supabase API to delete the homework assignment from the
      database.
    - The `HomeworkPage` updates its local `tasks` list by removing the deleted task and updates the
      UI.

### State Management Approaches

- **`HomeworkPage`:** Uses `setState` to manage the list of `Homework` objects and the loading
  state. This is a simple approach that works well for this page, as the state is relatively simple
  and localized.

### Input Validation and Data Transformation Patterns

- **`Homework.fromJson`:** This function performs data transformation by converting strings to `Uri`
  and `DateTime` objects. It also handles null values. However, it does *not* perform explicit input
  validation. Input validation should ideally occur in the API layer *before* data is sent to the
  database.

## 6. Implementation Details

### Language-Specific Implementation Details

- **Dart:** The code is written in Dart, leveraging features like `async/await` for asynchronous
  programming, `Future` for handling asynchronous operations, and type safety. The code uses Flutter
  widgets for building the UI.

### Performance Optimizations

- **Asynchronous Data Fetching:**  Fetching data asynchronously prevents the UI from blocking while
  waiting for data from the Supabase API.
- **`ListView.separated`:** Using `ListView.separated` allows for efficient rendering of a large
  list of homework assignments.
- **`FutureBuilder`:** Used to handle asynchronous operations when navigating to `AddHomeworkPage`.

### Security Considerations

- **Data Validation:** While `Homework.fromJson` transforms data, input validation is primarily the
  responsibility of the Supabase API layer. Proper validation on the server-side is critical to
  prevent malicious data from being stored in the database.
- **Authentication and Authorization:** The code assumes that the Supabase API is properly
  configured with authentication and authorization mechanisms to ensure that only authorized users
  can access and modify homework data.
- **Data Encryption:**  The connection to the Supabase API should use HTTPS to encrypt data in
  transit.
- **Attachment Security:**  If attachments contain sensitive information, appropriate security
  measures should be taken to protect the files stored in Supabase storage.

## 7. Common Usage Patterns

### Code Examples Showing How to Use Key Components

#### Creating a `Homework` object from JSON data:

```dart
final json = {
  "homework_id": 456,
  "title": "Science Project",
  "completed": false,
  "note": "Research and write a report",
  "attachments": [],
  "submit": false,
  "complete_due": "2024-12-28T16:00:00Z",
  "created_at": "2024-12-22T10:00:00Z",
  "subject_id": 2
};

Homework.fromJson