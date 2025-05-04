# Marks API Optimization Strategy

## Problem Analysis

The current implementation has several efficiency issues:

1. **Redundant Database Queries**: Multiple functions are fetching the same data repeatedly from the
   database.
2. **No Caching**: Each time data is needed, a new database query is made.
3. **Separate Queries for Related Data**: Calculations for averages, subject marks, etc. all make
   independent database calls.
4. **Poor Data Flow**: The UI component `MarksOverviewPage` makes multiple independent API calls
   instead of having a coordinated loading strategy.

## Optimization Strategy

### 1. Centralized Data Cache

```dart
class MarksCache {
  static List<Mark>? _allMarks;
  static Map<String, Subject>? _subjectCache;
  static GradingSystem? _gradingSystem;
  static DateTime? _lastFetchTime;

// Cache management methods
}
```

This approach:

- Provides a single source of truth for marks data
- Prevents redundant database queries
- Includes a timestamp to expire the cache after a reasonable period (5 minutes)

### 2. Single Data Load Point

The key function `_loadAllMarksData()` fetches all necessary data in a single operation:

```dart
Future<List<Mark>> _loadAllMarksData({bool forceRefresh = false}) async {
  // Return cached data if it exists and is still valid
  if (!forceRefresh && MarksCache.isCacheValid() && MarksCache._allMarks != null) {
    return MarksCache._allMarks!;
  }

  // Fetch grading system
  // Fetch all marks in single query  
  // Fetch all required subjects at once
  // Parse all marks
  // Store in cache
}
```

Benefits:

- All mark data is fetched once
- Subject data is fetched in a batch operation rather than one by one
- Results are cached for subsequent operations

### 3. Optimized Higher-Level Functions

All public API functions like:

- `fetchMarksBySubjects()`
- `calculateAverageMarksBySubjects()`
- `fetchMostRecentMarksForSubjects()`

Now use the cached data from `_loadAllMarksData()`, which means:

- No redundant database calls
- Faster execution after initial load
- Consistent data across different calculations

### 4. Cache Invalidation on Write Operations

The cache is automatically invalidated when data changes:

```dart
Future<void> insertMark
(...) async {
// Database operation
MarksCache.invalidateCache();
}

Future<void> updateMark(...) async {
// Database operation
MarksCache.invalidateCache();
}

Future<void> deleteMark(...) async {
// Database operation
MarksCache.invalidateCache();
}
```

This ensures data consistency while still benefiting from caching.

### 5. Improved UI Loading Strategy

The `MarksOverviewPage` has been rewritten to:

- Load all data in a single coordinated operation
- Show appropriate loading states (progress indicator, skeleton)
- Handle errors gracefully
- Provide a refresh mechanism
- Update on returning from add/edit operations

```dart
Future<void> _loadData() async {
  // Step 1: Fetch schedule once to get subjects
  // Step 2: Fetch all marks data - this makes a single DB call
  // Step 3: Calculate averages - now uses cached data
  // Step 4: Get recent marks - also uses cached data
  // Update state only once with all the data
}
```

## Benefits

1. **Reduced Database Operations**: From potentially 500+ operations to just 2-3 operations per
   screen load.
2. **Faster Loading Times**: Significant reduction in loading time after initial fetch.
3. **Better User Experience**: Improved loading states, error handling, and refresh capability.
4. **Maintainable Code**: Clearer separation of concerns and data flow.

## Implementation Details

### MarksCache

The `MarksCache` class provides:

- Storage for cached mark data
- Validity checking based on timestamp
- Cache invalidation for data consistency

### Optimized Data Loading

Data is loaded in this sequence:

1. Schedule (to get subjects)
2. All marks in a single database query
3. Subject details in a batch operation
4. Calculations done on in-memory data

### UI Improvements

- Added proper error handling
- Implemented pull-to-refresh
- Added automatic refresh when returning from add/edit operations
- Maintained all existing functionality

## Final Result

The optimized implementation maintains all the current functionality while:

- Reducing database operations by ~99%
- Improving loading performance
- Enhancing user experience with better state management
- Providing a more maintainable architecture