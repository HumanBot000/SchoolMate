# Schedule Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The Schedule subsystem is responsible for managing and representing a user's academic schedule,
including lessons, subjects, and temporal metadata.

### Architectural Role

This subsystem provides core data structures and logic for:

- Representing schedule information
- Detecting lesson time conflicts
- Rendering and managing schedule views

### Key Design Patterns

- Composition (Schedule composed of Lessons and Subjects)
- Immutable data structures
- Temporal data management

## 2. Code Structure Analysis

### Key Classes

1. `Schedule` (Classes/schedule/Schedule.dart)
    - Core data model representing a complete schedule

2. `SchedulePage` (pages/home/schedule/page/Schedule.dart)
    - UI component for rendering and interacting with schedules

### Dependencies

- Flutter's `TimeOfDay` for time representation
- Supabase for data fetching
- Custom classes: `Lesson`, `Subject`, `ScheduleMetadata`

## 3. API Documentation

### Schedule Class

```dart
class Schedule {
  final ScheduleMetadata metadata;
  final List<Subject> subjects;
  final List<Lesson> lessons;

  Schedule(this.metadata, this.subjects, this.lessons);

  bool lessonOverlaps(
    TimeOfDay startTime, 
    TimeOfDay endTime, 
    int weekday,
    List<int> alternatingWeeks,
    {List<Lesson> ignoredLessons = const []}
  )
}
```

#### Method: `lessonOverlaps`

- **Purpose**: Detect time conflicts between lessons
- **Parameters**:
    - `startTime`: Proposed lesson start time
    - `endTime`: Proposed lesson end time
    - `weekday`: Day of the week (0-indexed)
    - `alternatingWeeks`: Weeks when the lesson occurs
    - `ignoredLessons`: Lessons to exclude from conflict check

- **Returns**: `bool` indicating whether a time conflict exists

## 4. Function-Level Documentation

### Lesson Overlap Detection Algorithm

The `lessonOverlaps` method implements a sophisticated conflict detection algorithm:

1. Filter lessons by:
    - Matching weekday
    - Matching alternating weeks
2. Perform time interval overlap check
3. Uses set intersection for alternating week comparison

**Time Complexity**: O(n), where n is the number of lessons
**Space Complexity**: O(1)

## 5. Data Flow

### Schedule Creation

1. Fetch schedule metadata
2. Retrieve subjects
3. Load individual lessons
4. Construct `Schedule` object

### Lesson Addition Workflow

1. Select subject
2. Configure lesson details
3. Check for time conflicts
4. Persist to backend
5. Refresh schedule view

## 6. Implementation Details

### Conflict Detection Strategy

- Handles complex scenarios like:
    - Alternating week schedules
    - Multi-week lesson patterns
- Granular time comparison using hours and minutes

### Performance Considerations

- Lightweight in-memory data structure
- Efficient conflict checking
- Minimal computational overhead

## 7. Common Usage Patterns

### Adding a Lesson

```dart
void addNewLesson(Schedule schedule, Subject subject) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LessonConfigurationPage(
        subject: subject,
        schedule: schedule,
        onUpdate: (lesson) {
          // Validate and persist lesson
        }
      )
    )
  );
}
```

### Checking Lesson Conflicts

```dart
bool canScheduleLesson(Schedule schedule, Lesson proposedLesson) {
  return !schedule.lessonOverlaps(
    proposedLesson.startTime, 
    proposedLesson.endTime, 
    proposedLesson.weekday,
    proposedLesson.alternatingWeeks
  );
}
```

## 8. Testing Approach

### Test Scenarios

- Lesson overlap detection
- Alternating week handling
- Edge case time comparisons

### Recommended Test Cases

1. No overlap scenarios
2. Complete time overlap
3. Partial time overlap
4. Alternating week conflicts
5. Lesson exclusion during updates

### Mocking Strategies

- Mock `TimeOfDay` for precise time testing
- Create test schedules with predefined lessons

---

This documentation provides a comprehensive technical overview of the Schedule subsystem, offering
insights for developers working with or extending the scheduling functionality.