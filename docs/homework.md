# Homework Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The Homework subsystem is responsible for managing and tracking student homework tasks within the
School Mate application. It provides functionality for:

- Creating, viewing, and managing homework assignments
- Tracking homework completion status
- Handling attachments and due dates
- Providing a user interface for homework management

### Architectural Positioning

The subsystem spans multiple layers of the application:

- Data Model Layer: `Classes/homeworks/Homework.dart`
- UI Layer: `pages/home/homework/Homework.dart`
- API Integration Layer: Connects with Supabase for data persistence

## 2. Code Structure Analysis

### Key Components

1. `Homework` class (Model)
    - Represents a single homework task
    - Stores metadata about the homework
    - Provides methods for data transformation and state management

2. `HomeworkPage` (UI Component)
    - Manages the homework listing screen
    - Handles tab-based views for open and completed homework
    - Provides interaction mechanisms like deletion and completion toggling

### Dependencies

- Supabase API for data fetching and persistence
- Subject and Schedule subsystems
- Flutter framework for UI rendering

## 3. API Documentation

### `Homework` Class API

```dart
class Homework {
  // Constructor
  Homework(
    Subject subject, 
    int taskID, 
    String title, {
    bool isCompleted = false,
    String note = "",
    List<Uri> attachments = const [],
    bool handIn = false,
    DateTime? dueDate,
    DateTime? createdAt
  });

  // Asynchronous factory method for JSON deserialization
  static Future<Homework> fromJson(Map<String, dynamic> json);

  // Toggle homework completion status
  Future<void> toggleCompletion();
}
```

#### Key Properties

- `taskID`: Unique identifier for the homework
- `title`: Homework title
- `subject`: Associated academic subject
- `isCompleted`: Completion status
- `dueDate`: Deadline for the homework
- `attachments`: List of file attachments

## 4. Data Flow and State Management

### Homework Creation Workflow

1. User initiates homework creation via UI
2. Fetch current schedule context
3. Navigate to `AddHomeworkPage`
4. Create new homework entry
5. Persist to Supabase database

### Completion Tracking

- `toggleCompletion()` method updates homework status
- Immediately reflects in UI and syncs with backend

## 5. Performance Considerations

### Optimization Strategies

- Lazy loading of homework lists
- Efficient list filtering for open/completed tabs
- Minimal API calls by caching and smart state management

## 6. Error Handling and Validation

### Key Error Scenarios

- Schedule not set
- Network connectivity issues
- Invalid homework data

### Mitigation Strategies

- Fallback UI for schedule setup
- Error snackbars
- Comprehensive null checks

## 7. Common Usage Patterns

### Creating a Homework

```dart
Homework newHomework = Homework(
  mySubject,     // Associated subject
  generateUniqueId(),  // Task ID
  "Math Assignment",  // Title
  dueDate: DateTime.now().add(Duration(days: 7)),
  note: "Complete chapters 3-5"
);
```

### Toggling Completion

```dart
await homework.toggleCompletion();
```

## 8. Testing Approach

### Test Coverage

- Unit tests for `Homework` model
- Integration tests for API interactions
- UI widget tests for `HomeworkPage`

### Mocking Strategies

- Mock Supabase API responses
- Simulate different homework states
- Test edge cases in homework creation and management

## 9. Security Considerations

- Validate and sanitize homework input data
- Secure file attachment handling
- Implement proper access controls for homework management

## 10. Future Improvements

- Enhanced attachment handling
- More granular homework filtering
- Improved notifications for approaching deadlines

---

This documentation provides a comprehensive technical overview of the Homework subsystem, offering
insights for developers working with or extending this functionality.