```markdown
# Schedule Subsystem Technical Documentation

## 1. Subsystem Overview

### 1.1. Purpose and Responsibilities

The Schedule subsystem is responsible for managing and displaying a user's schedule.  This includes:

*   Storing and retrieving schedule data (lessons and subjects).
*   Displaying the schedule in a grid format.
*   Providing functionality to add, edit, and delete lessons.
*   Checking for time conflicts between lessons.
*   Allowing the user to navigate the schedule.

### 1.2. Integration into Overall Architecture

The Schedule subsystem integrates with the following components:

*   **Data Layer (Supabase API):**  It relies on the Supabase API (specifically, `school_mate/API/supabase/schedule/lessons.dart` and `school_mate/API/supabase/schedule/schedule.dart`) to fetch and persist schedule data.
*   **Subjects Subsystem:** It interacts with the Subject subsystem to allow users to select existing subjects when creating lessons.
*   **UI Components:**  It provides UI components (specifically `ScheduleGridView.dart`) for displaying the schedule.
*   **Navigation:** The subsystem uses Flutter's `Navigator` for page transitions (e.g., from the main schedule page to the lesson configuration page).
*   **Error Handling/Logging:** Integrates with the global logger (`school_mate/main.dart`) for error reporting.

### 1.3. Key Design Patterns and Architectural Decisions

*   **Model-View-Controller (MVC) -ish:** While not a strict MVC implementation, the architecture loosely follows this pattern. `SchedulePage` acts as a controller and view (displaying schedule and handling user interaction), and `Schedule` class serves as the model.  The data fetching from Supabase could be considered a data access layer.
*   **Data Abstraction:** The `Schedule` class encapsulates the schedule data (metadata, subjects, lessons), providing a higher-level interface for other parts of the application to interact with.
*   **Widget-Based UI:** The UI is built using Flutter's widget system, with custom widgets like `ScheduleGridView` for specific schedule-related functionality.
*   **Asynchronous Operations:** Data fetching and persistence are handled asynchronously using `Future` and `async/await` to avoid blocking the UI thread.
*   **Dependency Injection (Implicit):** The `SchedulePage` receives the `Schedule` object as a constructor parameter, which can be considered a form of dependency injection (though not explicitly using an DI framework).  This allows for easier testing and swapping of schedule data sources.

## 2. Code Structure Analysis

### 2.1. Directory/File Organization

```

Classes/schedule/
├── Schedule.dart # Defines the Schedule class
├── Lesson.dart # Defines the Lesson class
├── Subject.dart # Defines the Subject class
└── ScheduleMetadata.dart # Defines metadata associated with schedule (e.g., name)

pages/home/schedule/
├── lessons/
│ └── ConfigureLesson.dart # Page for configuring (creating/editing) a lesson
├── page/
│ ├── Schedule.dart # The main Schedule page
│ └── Widgets/
│ └── ScheduleGridView.dart # Widget for displaying the schedule in a grid
├── setup/
│ └── scheduleSetup.dart # Widget for setting up the schedule if one doesn't exist
└── subjects/
└── SubjectsListPage.dart # Page for selecting a subject when creating a lesson

API/supabase/schedule/
├── lessons.dart # API calls related to schedule lessons
└── schedule.dart # API calls related to schedule (fetching)

```

### 2.2. Dependencies and Relationships with Other Subsystems

*   **`Classes/schedule/*`:** These classes define the core data models for the Schedule subsystem.  They have no dependencies on other subsystems *within the application*, but the data they represent is fetched/persisted via the Supabase API.
*   **`pages/home/schedule/page/Schedule.dart`:** Depends on:
    *   `Classes/schedule/Schedule.dart`:  For the `Schedule` data model.
    *   `pages/home/Widgets/BottomNavBar.dart`: For navigation.
    *   `pages/home/schedule/lessons/ConfigureLesson.dart`: For creating/editing lessons.
    *   `pages/home/schedule/subjects/SubjectsListPage.dart`: For subject selection.
    *   `API/supabase/schedule/*`: For data fetching and persistence.
*   **`pages/home/schedule/lessons/ConfigureLesson.dart`:** Depends on:
    *   `Classes/schedule/*`: For `Lesson` and `Subject` data models.
    *   `API/supabase/schedule/lessons.dart`: For adding/updating lessons.
*   **`pages/home/schedule/subjects/SubjectsListPage.dart`:** Depends on:
    *   `Classes/schedule/Subject.dart`: For the `Subject` data model.

### 2.3. Class/Module Hierarchies and Their Relationships

The core data model hierarchy is relatively simple:

*   **`Schedule`**:  Contains:
    *   `ScheduleMetadata`
    *   `List<Subject>`
    *   `List<Lesson>`
*   **`Lesson`**: Represents a single scheduled lesson.  It has properties for subject, time, day, and location.
*   **`Subject`**: Represents a subject or course.

The UI components form a widget tree, with `SchedulePage` at the root and `ScheduleGridView` as a key child for displaying the schedule.

## 3. API Documentation

### 3.1. Public Interfaces

#### `Schedule` class (`Classes/schedule/Schedule.dart`)

*   **Constructor:** `Schedule(this.metadata, this.subjects, this.lessons)`
    *   `metadata`: `ScheduleMetadata` object containing schedule metadata.
    *   `subjects`: `List<Subject>` containing all subjects.
    *   `lessons`: `List<Lesson>` containing all scheduled lessons.
*   **Method:** `bool lessonOverlaps(TimeOfDay startTime, TimeOfDay endTime, int weekday, List<int> alternatingWeeks, {List<Lesson> ignoredLessons = const []})`
    *   **Purpose:** Checks if a potential lesson time overlaps with any existing lessons in the schedule.
    *   **Parameters:**
        *   `startTime`: `TimeOfDay` representing the start time of the potential lesson.
        *   `endTime`: `TimeOfDay` representing the end time of the potential lesson.
        *   `weekday`: `int` representing the weekday (1-7).
        *   `alternatingWeeks`: `List<int>` representing the alternating weeks that the lesson is scheduled for.
        *   `ignoredLessons`: `List<Lesson>` (optional, default: `const []`) A list of lessons to ignore when checking for overlaps. This is useful when updating an existing lesson.
    *   **Return Type:** `bool`: `true` if there is an overlap, `false` otherwise.
    *   **Error Handling:**  None explicitly within the function. It relies on the caller to handle any exceptions.

#### `SchedulePage` class (`pages/home/schedule/page/Schedule.dart`)

*   **Constructor:** `SchedulePage({super.key, required this.schedule, this.showBreaks = false, this.onBreakSelection = _defaultBreakSelection, this.showLessonTapCallback = true, this.onLessonSelection = _defaultOnLessonSelection, this.crossOutPastLessons = false,})`
    *   **Parameters:**
        *   `schedule`:  `Schedule` object to display.
        *   `showBreaks`: `bool` (optional, default: `false`) Whether to show breaks in the schedule.
        *   `onBreakSelection`: `Function(TimeOfDay, TimeOfDay, int)` (optional, default: `_defaultBreakSelection`) Callback function called when a break is selected.
        *   `showLessonTapCallback`: `bool` (optional, default: `true`) Whether to enable lesson tap callback.
        *   `onLessonSelection`: `Function(Lesson, DateTime)` (optional, default: `_defaultOnLessonSelection`) Callback function called when a lesson is selected.
        *   `crossOutPastLessons`: `bool` (optional, default: `false`) Whether to visually cross out lessons that have already passed.
    *   **Return Type:**  A Flutter `Widget`.

### 3.2. Function/Method Signatures

See the "Public Interfaces" section for the key method signatures.  The API functions in `API/supabase/schedule/*` are assumed to have standard asynchronous signatures using `Future<>` and `async/await`. Their details are not included here, since the focus is on the *internal* API of the Schedule subsystem.

### 3.3. Return Types and Error Handling Patterns

*   **Data Models:**  Return instances of the `Schedule`, `Lesson`, and `Subject` classes.
*   **API Calls (Supabase):** Return `Future<>` objects.  Errors are typically handled using `try...catch` blocks and logged using the global logger (e.g., in `SchedulePage` when fetching the schedule).
*   **`lessonOverlaps`:**  Returns a boolean indicating whether an overlap exists. No exceptions are thrown.

## 4. Function-Level Documentation

### 4.1. `Schedule.lessonOverlaps`

*   **Algorithm:**
    1.  Iterates through each `lesson` in the `lessons` list.
    2.  If the `lesson` is in the `ignoredLessons` list, it skips to the next lesson.
    3.  If the `lesson`'s weekday does not match the input `weekday`, it skips to the next lesson.  Note: the `lesson.temporalData.weekday` is assumed to be 1-indexed (1=Monday), while the `weekday` parameter is 0-indexed (0=Monday).
    4.  If the `lesson` is not scheduled for any of the same alternating weeks as the input, it skips to the next lesson.
    5.  It checks if the time intervals of the existing `lesson` and the input `startTime` and `endTime` overlap.
    6.  If an overlap is found, it returns `true`.
    7.  If the loop completes without finding an overlap, it returns `false`.

*   **Time Complexity:** O(n), where n is the number of lessons in the `lessons` list.  This is because it iterates through the entire list in the worst case.
*   **Space Complexity:** O(1). The function uses a fixed amount of extra space, regardless of the input size.
*   **Edge Cases:**
    *   Empty `lessons` list: Returns `false` immediately, as there are no lessons to overlap with.
    *   `startTime` and `endTime` are the same: Considered not an overlap, returns `false`.
    *   Lessons at the exact same time are flagged as overlapping.
*   **Assumptions:**
    *   `weekday` is 0-indexed (0 = Monday, 6 = Sunday).
    *   `lesson.temporalData.weekday` is 1-indexed (1 = Monday, 7 = Sunday).
    *   `startTime` is before `endTime`.  No explicit validation exists for this case.  Reversing the order will result in the function always returning false.

## 5. Data Flow

1.  **Initialization:**  The `SchedulePage` is initialized with a `Schedule` object. This object is usually fetched from the Supabase API using the functions in `API/supabase/schedule/schedule.dart`. The fetch operation is asynchronous.
2.  **Rendering:**  The `SchedulePage` uses the `ScheduleGridView` widget to display the schedule.  The `ScheduleGridView` iterates through the `lessons` list in the `Schedule` object and renders each lesson in the appropriate grid cell.
3.  **Adding a Lesson:**
    *   The user taps the "Add Lesson" button.
    *   The `SubjectsListPage` is displayed, allowing the user to select a subject.
    *   After selecting a subject, the `LessonConfigurationPage` is displayed.
    *   The user enters the lesson details (time, day, location, alternating weeks).
    *   The `addLesson` function in `API/supabase/schedule/lessons.dart` is called to persist the new lesson to the Supabase database.  This is an asynchronous operation.
    *   After the lesson is successfully added, the `SchedulePage` is reloaded with the updated schedule (fetched again from Supabase).
4.  **Overlap Checking:** The `lessonOverlaps` method in the `Schedule` class is called before adding a new lesson (likely within the `LessonConfigurationPage`, although not explicitly shown in the provided code) to prevent time conflicts.
5.  **Data Transformation:** Data fetched from Supabase may need to be transformed into the appropriate data types (e.g., converting strings to `TimeOfDay` objects).  The code for this transformation is not shown in the provided extracts but is likely handled within the API functions.

### 5.1. State Management

*   **`Schedule` object:** The `Schedule` object itself represents the state of the schedule. It's typically fetched once when the `SchedulePage` is loaded and passed down to child widgets.
*   **Stateless Widgets:**  The `SchedulePage` is implemented as a `StatelessWidget`, relying on the `Schedule` object to hold the state. Updates to the schedule trigger a rebuild of the widget tree, reflecting the changes.
*   **Temporary State:** Widgets like `ConfigureLesson` and `SubjectsListPage` likely manage temporary state (e.g., the currently selected subject, the entered lesson details) using `StatefulWidget` and local state variables.

## 6. Implementation Details

### 6.1. Language-Specific Implementation Details (Dart/Flutter)

*   **Asynchronous Programming:**  Dart's `async/await` feature is used extensively for handling asynchronous operations (e.g., fetching data from Supabase).
*   **Flutter Widgets:** The UI is built using Flutter's widget system.  The `ScheduleGridView` widget is likely implemented using a `GridView` or similar layout widget.
*   **`TimeOfDay`:** The `TimeOfDay` class is used to represent time values.  Note that it only contains hour and minute; it does not store a date.
*   **`MaterialPageRoute`:**  Used for navigating between pages in the application.
*   **`WidgetStateProperty`:** Used to specify different styling options for widgets, depending on their current state.

### 6.2. Performance Optimizations

*   **Asynchronous Data Fetching:** Fetching data asynchronously prevents blocking the UI thread and improves responsiveness.
*   **Widget Rebuilding:** Flutter's widget rebuilding mechanism is generally efficient, but complex widgets with frequent updates could potentially impact performance.  Consider using `const` widgets where possible to prevent unnecessary rebuilds.
*   **Caching:** The schedule data could be cached locally to reduce the number of API calls. This is not shown in the provided code but could be a future optimization.

### 6.3. Security Considerations

*   **Data Validation:** Input validation (e.g., checking that the end time is after the start time) should be performed to prevent invalid data from being persisted to the database.  While the provided code shows rudimentary overlap checking, more robust validation is needed.
*   **Authentication and Authorization:** Access to the schedule data should be protected by authentication and authorization mechanisms to ensure that only authorized users can access and modify the data. This is handled at the Supabase level.
*   **SQL Injection:** Ensure that the Supabase API calls are properly parameterized to prevent SQL injection vulnerabilities. This is assumed to be handled by the Supabase client library.

## 7. Common Usage Patterns

### 7.1. Code Examples

*   **Displaying the Schedule:**

```dart
SchedulePage(schedule: mySchedule); // mySchedule is an instance of the Schedule class
```

* **Checking for Lesson Overlaps:**

```dart
bool overlaps = mySchedule.lessonOverlaps(
  TimeOfDay(hour: 10, minute: 0),
  TimeOfDay(hour: 11, minute: 0),
  1, // Tuesday
  [1, 3, 5], // Alternating weeks 1, 3, and 5
);

if (overlaps) {
  print("The lesson overlaps with an existing lesson.");
} else {
  print("The lesson does not overlap.");
}
```

### 7.2. Best Practices

* **Keep the `Schedule` object up-to-date:**  Whenever the schedule data is modified (e.g., adding a
  lesson), ensure that the `Schedule` object is refreshed by fetching the latest data from the
  Supabase API.
* **Validate user input:** Validate all user input to prevent invalid data from being persisted.
* **Handle errors gracefully:** Use `try...catch` blocks to handle potential errors and provide
  informative error messages to the user.

### 7.3. Antipatterns to Avoid

* **Performing synchronous API calls on the main thread:** This will block the UI and make the
  application unresponsive. Always use asynchronous operations for data fetching and persistence.
* **Ignoring potential errors:** Always handle errors gracefully and provide informative error
  messages to the user.
* **Not validating user input:** This can lead to invalid data being persisted and potentially cause
  unexpected behavior.
* **Overly complex widget trees:**  This can impact performance. Break down complex widgets into
  smaller, more manageable components.
* **Directly manipulating the Supabase database without using the API:** This can bypass
  authentication and authorization checks and lead to security vulnerabilities.

## 8. Testing Approach

### 8.1. Testing Strategy

The testing strategy should include:

* **Unit Tests:**  Focus on testing individual classes and functions in isolation. For example:
    * Test the `lessonOverlaps` method in the `Schedule` class with various scenarios (overlapping
      lessons, non-overlapping lessons, empty schedule, etc.). Mock the `Lesson` objects for these
      tests.
    * Test the data validation logic in the `ConfigureLesson` page.
* **Widget Tests:** Test the UI components (e.g., `ScheduleGridView`) to ensure that they render
  correctly and respond to user input as expected. Use Flutter's widget testing framework for this.
* **Integration Tests:** Test the integration between different components. For example:
    * Test the flow