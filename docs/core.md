# Subsystem Technical Documentation: Core

## 1. Subsystem Overview

### Purpose

The core subsystem of the SchoolMate application is responsible for initializing the application,
managing core configurations, and setting up essential services and dependencies.

### Architectural Responsibilities

- Application initialization
- Dependency configuration
- Global state management
- Core service setup
- Logging and error handling

## 2. Key Components and Dependencies

### Key Files

- `main.dart`: Primary entry point for the application
- `main.dart`: Initialization of core services
    - Supabase client
    - Shared preferences
    - Logging
    - Navigation tree observer
    - Alarm management

### Dependencies

- `android_alarm_manager_plus`: For scheduling background tasks
- `shared_preferences`: Local storage for app settings
- `logger`: Logging utility
- `supabase_flutter`: Backend and authentication service
- `permission_handler`: Managing device permissions

## 3. Application Initialization Flow

```dart
void main() async {
  // 1. Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Supabase client
  await initializeSupabase();

  // 3. Initialize SharedPreferences
  prefs = await SharedPreferences.getInstance();

  // 4. Initialize Android Alarm Manager
  var success = await AndroidAlarmManager.initialize();

  // 5. Schedule daily background tasks
  await scheduleDailyTask();

  // 6. Run the application
  runApp(const MyApp());
}
```

## 4. Background Task Management

### Daily Scheduled Task

The `scheduleTaskCallback` function handles daily background tasks:

- Initializes Supabase if needed
- Schedules pre-lesson notifications
- Updates homework notifications
- Reschedules itself for the next midnight

```dart
@pragma('vm:entry-point')
Future<void> scheduleTaskCallback(int id, {
  bool reInitializeSupabase = false, 
  bool isRerun = false
}) async {
  // Task execution logic with retry mechanism
}
```

## 5. Application Theming

### Dark Theme Configuration

The application uses a dark theme with a consistent color scheme:

- Seed color: `Color(0xFF3A7BD5)`
- Surface color: `Color(0xFF2B2B2B)`
- Accent colors: `Colors.greenAccent`

```dart
darkTheme: ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF3A7BD5),
    brightness: Brightness.dark,
  ),
  // Additional theme configurations
)
```

## 6. Navigation and Routing

### Navigation Tree Observer

A custom `NavigationTreeObserver` tracks navigation history for debugging and analytics:

- Records route push, pop, and replace events
- Provides method to print navigation history

```dart
final NavigationTreeObserver navigatorTreeObserver = NavigationTreeObserver();
```

## 7. Error Handling and Logging

### Logging Strategy

- Uses `logger` package for structured logging
- Different log levels: debug, info, warning, error
- Centralized logging through `logger` global variable

```dart
final logger = Logger();

// Example usage
logger.d("Debug message");
logger.i("Informational message");
logger.w("Warning message");
logger.e("Error message");
```

## 8. Permissions and System Integration

### Required Permissions

- Notification permissions
- Exact alarm scheduling permissions

```dart
Future<void> scheduleDailyTask() async {
  await Permission.notification.request();
  await Permission.scheduleExactAlarm.request();
  // Additional scheduling logic
}
```

## 9. Performance Considerations

### Startup Optimization

- Minimal blocking operations during startup
- Use of `async`/`await` for non-blocking initialization
- Lazy loading of resources where possible

## 10. Security Considerations

### Authentication Flow

- Uses Supabase for secure authentication
- Email verification process
- Secure storage of user preferences

## 11. Extensibility

### Design Patterns

- Dependency injection through global variables
- Separation of concerns
- Modular architecture allowing easy feature addition

## 12. Potential Improvements

- Implement more robust error handling
- Add more comprehensive logging
- Enhance background task management
- Implement secure credential storage
- Add more granular permission management

## Conclusion

The core subsystem serves as the foundation for the SchoolMate application, providing essential
initialization, configuration, and system integration services. Its design emphasizes modularity,
performance, and extensibility.