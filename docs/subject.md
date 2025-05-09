# Subject Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The `AddMarkSubjectSelector` is a Flutter widget responsible for allowing users to select a subject
when adding marks. It integrates with the scheduling and subject management system of the
application.

### Architectural Role

- Provides a dynamic subject selection interface
- Fetches and displays available subjects from the schedule
- Facilitates subject selection through a reusable list widget

## 2. Code Structure Analysis

### Dependencies

- `flutter/material.dart`: Core Flutter UI framework
- `supabase/schedule/schedule.dart`: Schedule API for fetching subjects
- `Classes/schedule/Subject.dart`: Subject data model
- `home/schedule/subjects/SubjectListWidget.dart`: Reusable subject list widget

### Key Components

- `AddMarkSubjectSelector`: Stateless widget managing subject selection
- `SubjectListWidget`: Renders the list of selectable subjects

## 3. API Documentation

### Constructor

```dart
const AddMarkSubjectSelector({
  Key? key, 
  required Function(Subject) onSelection
})
```

- `onSelection`: Callback function triggered when a subject is selected
    - Receives the selected `Subject` as a parameter

### Build Method

Returns a `FutureBuilder` that:

- Fetches schedule data
- Handles different connection states
- Displays subjects or error messages

## 4. Function-Level Documentation

### Data Fetching and Rendering

```dart
FutureBuilder(
  future: fetchSchedule(),
  builder: (context, snapshot) { ... }
)
```

- Asynchronously fetches schedule using `fetchSchedule()`
- Handles multiple states:
    1. Loading: Shows `CircularProgressIndicator`
    2. Error: Displays error message
    3. No Subjects: Shows setup guidance
    4. Subjects Available: Renders `SubjectListWidget`

## 5. Data Flow

### Subject Selection Process

1. Fetch schedule data
2. Extract subjects from schedule
3. Render subjects in `SubjectListWidget`
4. User selects a subject
5. Trigger `onSelection` callback with selected subject

### State Management

- Stateless widget design
- Relies on external state management via `onSelection` callback

## 6. Implementation Details

### Error Handling

- Graceful handling of:
    - Network errors
    - Empty subject list
    - Loading states

### Performance Considerations

- Uses `FutureBuilder` for non-blocking UI rendering
- Minimal widget rebuilds

## 7. Common Usage Patterns

### Example Usage

```dart
AddMarkSubjectSelector(
  onSelection: (selectedSubject) {
    // Handle subject selection, e.g., navigate or update state
    print('Selected subject: ${selectedSubject.name}');
  }
)
```

### Best Practices

- Always provide fallback UI for different states
- Handle potential null or empty data scenarios
- Use meaningful error messages

## 8. Testing Approach

### Recommended Test Scenarios

- Verify correct rendering during loading state
- Test error message display
- Validate subject selection callback
- Check empty state handling

### Potential Test Cases

1. Schedule fetch success
2. Schedule fetch failure
3. Empty subject list
4. Subject selection interaction

## 9. Potential Improvements

- Add more robust error logging
- Implement caching for schedule data
- Support manual subject addition
- Enhance accessibility features

---

**Technical Complexity**: Moderate
**Dependency Level**: High (relies on external API and widget)
**Recommended Refactoring**: Consider extracting error handling and loading states into reusable
components