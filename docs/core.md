```markdown
# Core Subsystem Technical Documentation

## 1. Subsystem Overview

- **Purpose and Responsibilities:**
    - The `core` subsystem serves as the foundational layer for the SchoolMate application. It encompasses essential functionalities and configurations required by other subsystems. It's responsible for:
        - Initializing the Supabase client for database interaction.
        - Configuring and initializing the Android Alarm Manager for scheduling background tasks.
        - Providing global variables and utilities, such as the logger, shared preferences, and navigator observer.
        - Defining the main application entry point and the root `MyApp` widget, including theme settings.
        - Scheduling daily background tasks.

- **How it Fits into the Overall Architecture:**
    - The `core` subsystem is a dependency for almost all other subsystems within the application. It provides the Supabase client, logger, shared preferences and scheduled tasks that are used extensively.
    - It sets up the fundamental environment for the rest of the application to run, including dependency injection via global variables.
    - Other subsystems, such as `API`, `pages`, and `util`, rely on the components provided by the `core` subsystem.

- **Key Design Patterns and Architectural Decisions:**
    - **Singleton Pattern:** The `Supabase` client, `Logger`, `SharedPreferences`, and `NavigationTreeObserver` are implemented as singletons (or effectively singletons via global variables). This ensures that only one instance of these resources exists throughout the application, which simplifies state management and reduces resource consumption.  This decision could be revisited in the future in favor of a more formal dependency injection framework.
    - **Callback Pattern:** The `scheduleTaskCallback` function is registered with the `AndroidAlarmManager` and is executed in the background. This pattern allows the app to perform tasks such as scheduling notifications, even when the app is not actively running.
    - **Initialization Pattern:** The `main()` function uses `async` and `await` to ensure that essential services, such as Supabase and shared preferences, are fully initialized before the UI is rendered. This prevents race conditions and ensures that the app starts in a consistent state.
    - **Theme Configuration:** The `MyApp` widget configures the application's theme using `ThemeData`, including the color scheme, text styles, and other visual properties. This promotes a consistent look and feel across the application.

## 2. Code Structure Analysis

- **Directory/File Organization:**

    ```
    school_mate/
    ├── main.dart                     # Main entry point, app initialization, MyApp widget
    ├── API/
    │   ├── externalAPIClients/        # External API client implementations
    │   │   ├── geoAPIs.dart           # Fetches countries and states
    │   │   └── OpenHolidaysAPI.dart  # Fetches school holidays
    │   ├── supabase/                 # Supabase-related API implementations
    │   │   ├── auth/                # Authentication-related functions
    │   │   │   ├── userData.dart      # Gets user data
    │   │   │   └── userSettings.dart  # Manages user settings
    │   │   ├── grades/              # Grades related functions
    │   │   │   ├── gradingSystem.dart # Manages the grading system
    │   │   │   ├── marks.dart       # Handles marks/grades data
    │   │   ├── homeworks/           # Homework tasks-related functions
    │   │   │   └── tasks.dart         # Handles homework tasks
    │   │   ├── schedule/            # Schedule-related functions
    │   │   │   ├── insertMetadata.dart# Inserts schedule metadata
    │   │   │   ├── lessons.dart       # Manages lessons
    │   │   │   ├── schedule.dart      # Schedule fetching functions
    │   │   │   ├── subjects.dart      # Manages subjects
    │   │   │   └── teachers.dart      # Manages teachers
    │   │   └── settings/            # Settings related functions
    │   │   │   └── preLessonNotifications.dart # Manages notification settings
    ├── Classes/                  # Data model classes
    │   ├── geoPolitics/            # Geo Politics classes
    │   │   ├── Country.dart       # Class representing a country
    │   │   └── SubCountryState.dart # Class representing a subcountry
    │   ├── marks/                # Marks classes
    │   │   ├── ExamType.dart      # Class representing exam types
    │   │   ├── GradingSystem.dart # Class representing grading system
    │   │   └── Mark.dart          # Class representing a mark
    │   ├── homeworks/            # Homework classes
    │   │   └── Homework.dart      # Class representing homework
    │   ├── persons/              # Person related classes
    │   │   └── Gender.dart        # Class representing gender
    │   ├── schedule/             # Schedule classes
    │   │   ├── Lesson.dart        # Class representing a lesson
    │   │   ├── Schedule.dart      # Class representing the schedule
    │   │   ├── ScheduleMetadata.dart # Class representing metadata
    │   │   └── SchoolHoliday.dart # Class representing a school holiday
    ├── pages/                    # UI pages
    │   ├── home/                # Home Screen related files
    │   │   ├── home/            # Home screen itself
    │   │   │   ├── Widgets/       # Widgets used by the home screen
    │   │   │   └── start.dart     # The main home page compositing widgets
    │   │   ├── homework/        # Homework pages
    │   │   │   ├── add/         # Add homework related files
    │   │   │   ├── Widgets/     # Widgets used for homework display
    │   │   │   └── Homework.dart  # The main homework page
    │   │   ├── marks/           # Marks pages
    │   │   │   ├── add/         # Adding Mark related files
    │   │   │   ├── overview/    # Mark Overview page related files
    │   │   │   ├── setup/       # Mark setup files
    │   │   │   └── Grades.dart    # The main Grades page
    │   │   ├── schedule/        # Schedule pages
    │   │   │   ├── lessons/     # Lessons page related files
    │   │   │   ├── page/        # The Schedule viewing page
    │   │   │   ├── setup/       # Files for setting up a schedule
    │   │   │   ├── subjects/    # Subject related files
    │   │   │   └── teachers/    # Teacher related files
    │   ├── settings/            # Settings pages
    │   │   ├── Widgets/         # Settings widgets
    │   │   └── setup.dart       # The setup page
    │   ├── userAuth/            # User authentication pages
    │   │   ├── authenticationFlow.dart # authentication flow
    │   │   ├── emailVerification.dart# Email verification flow
    │   │   └── userAuthentication.dart# General Authentication page
    ├── util/                     # Utility functions and classes
    │   ├── dates.dart           # Date-related utility functions
    │   ├── alphabet.dart        # helper functions to work with alphabet
    │   ├── NavigatorTree.dart     # debug tool to track navigator
    │   ├── notifications/       # Notifications utility functions
    │   │   └── schedule.dart    # helper functions to work with notifications
    ├── Widgets/                  # Custom widgets
    │   ├── public/              # Public Widgets used in many places
    │   │   ├── GradientButton.dart # general elevated gradient button
    │   │   ├── ShimmerEffectForSkeletonLoader.dart # animated shimmer effect for loading
    │   │   ├── TimePicker.dart    # adaptive time picker
    │   │   ├── MultipleStepPageIndicator.dart # Visual indicator showing multiple steps
    │   │   ├── PreviousPage.dart  # Standard back button for app navigation
    ```

- **Dependencies and Relationships with Other Subsystems:**
    - **Supabase Client:** The `core` subsystem initializes and provides the `Supabase` client, which is then used by the `API` subsystem to interact with the Supabase database.
    - **Logger:** The `logger` instance is used by various subsystems for logging events, errors, and debugging information.
    - **Shared Preferences:** The `prefs` instance is used by several subsystems to store and retrieve user preferences and application settings.
    - **Android Alarm Manager:** The  `pages` subsystem utilizes the `AndroidAlarmManager` to facilitate notifications when homework is due.

- **Class/Module Hierarchies and Their Relationships:**
    - The `main.dart` file defines the `MyApp` class, which extends `StatelessWidget` and serves as the root widget for the application.
    - The `API` directory contains multiple modules (e.g., `auth`, `schedule`, `grades`) that provide data access and manipulation functionalities. These modules rely on the `Supabase` client provided by `core`.
    - The `pages` directory contains various UI pages, which use the functionalities exposed by the `API` and `util` subsystems.
    - The `util` directory contains utility functions and classes that are used by multiple subsystems.

## 3. API Documentation

- **Global Variables:**

    - `late final Supabase supabaseClient;`:
        - Type: `Supabase`
        - Description: The Supabase client instance used to interact with the Supabase database.  It is initialized during app startup within the `initializeSupabase()` function.
        - Usage: Used throughout the application to perform database queries, authentication, and other Supabase-related operations.
    - `final logger = Logger();`:
        - Type: `Logger`
        - Description:  A logger instance from the `logger` package for logging information, warnings, and errors.
        - Usage: Used across the application for logging events, debugging, and error reporting.
    - `late final SharedPreferences prefs;`:
        - Type: `SharedPreferences`
        - Description: An instance of `SharedPreferences` for storing and retrieving key-value pairs persistently.
        - Usage: Used for storing user preferences, application settings, and other persistent data.
    - `final NavigationTreeObserver navigatorTreeObserver = NavigationTreeObserver();`:
        - Type: `NavigationTreeObserver`
        - Description: An observer that can be attached to the navigator to track the history of pushed and popped routes
        - Usage: Can help trace the navigation history and locate possible memory leaks by not removing routes on pop

- **Functions:**

    - `Future<void> scheduleTaskCallback(int id, {bool reInitializeSupabase = false, bool isRerun = false})`:
        - Description: Callback function executed at midnight to schedule pre-lesson notifications for the current day.
        - Parameters:
            - `id` (int): The ID of the alarm.
            - `reInitializeSupabase` (bool, optional): Whether to re-initialize Supabase. Defaults to `false`.
            - `isRerun` (bool, optional): Whether this is a rerun after an error. Defaults to `false`.
        - Return Type: `Future<void>`
        - Error Handling: Uses a try-catch block to handle errors.  If an error occurs, it retries once with `reInitializeSupabase` set to `true`.
    - `Future<void> scheduleDailyTask()`:
        - Description: Schedules the `scheduleTaskCallback` function to run every day at midnight.
        - Parameters: None
        - Return Type: `Future<void>`
    - `void main() async`:
        - Description: The main entry point of the application. Initializes Supabase, shared preferences, and the Android Alarm Manager, then runs the `MyApp` widget.
        - Parameters: None
        - Return Type: `void`

- **Classes:**

    - `MyApp extends StatelessWidget`:
        - Description: The root widget of the application. Configures the application's theme and sets the home page to `AuthenticationPage`.
        - Methods:
            - `Widget build(BuildContext context)`: Builds the UI for the application, including the `MaterialApp` widget with the defined theme.

## 4. Function-Level Documentation

- **`scheduleTaskCallback`:**

    ```dart
    @pragma('vm:entry-point')
    Future<void> scheduleTaskCallback(int id,
        {bool reInitializeSupabase = false, bool isRerun = false}) async {
      if (reInitializeSupabase) {
        await initializeSupabase();
      }
      try {
        await schedulePreLessonNotificationsForCurrentDay(
          fetchSchedule: fetch_schedule.fetchSchedule,
          preLessonNotificationsFetcher: fetchPreLessonNotifications,
        );
      } catch (e) {
        // 1 retry
        if (!isRerun) {
          await scheduleTaskCallback(id, reInitializeSupabase: true, isRerun: true);
        } else {
          logger.e("Error executing scheduled task: $e");
        }
        return;
      }
      DateTime now = DateTime.now();
      DateTime nextMidnight = now.add(const Duration(days: 1)).subtract(Duration(
          hours: now.hour,
          minutes: now.minute,
          seconds: now.second,
          milliseconds: now.millisecond,
          microseconds: now.microsecond));
      await AndroidAlarmManager.oneShotAt(nextMidnight, 0, scheduleTaskCallback,
          exact: true,
          allowWhileIdle: true,
          rescheduleOnReboot: true,
          alarmClock: true);
    }
    ```

    - Description: This function is the callback that is executed by the `AndroidAlarmManager`. It is responsible for scheduling pre-lesson notifications for the current day. It's marked with `@pragma('vm:entry-point')` to ensure it can be called from Dart's isolate even in release mode.
    - Algorithm:
        1. **Conditional Supabase Re-initialization:** If `reInitializeSupabase` is `true`, it calls `initializeSupabase()` to re-establish the Supabase connection. This is used as a retry mechanism in case the initial connection was lost.
        2. **Notification Scheduling:** Calls `schedulePreLessonNotificationsForCurrentDay()` to fetch the user's schedule and pre-lesson notification preferences, then schedules notifications accordingly.
        3. **Error Handling with Retry:** Uses a `try-catch` block to handle potential exceptions during notification scheduling. If an error occurs, it retries the operation once by calling itself with `reInitializeSupabase` set to `true` and `isRerun` to `true`. If the retry fails, the error is logged, and the function returns.
        4. **Rescheduling for the Next Day:** Calculates the time until the next midnight and schedules itself to run again using `AndroidAlarmManager.oneShotAt()`. This ensures that notifications are scheduled daily.
    - Time/Space Complexity: The time complexity is primarily determined by `schedulePreLessonNotificationsForCurrentDay()`, fetching the schedule, notification settings, and scheduling the notifications.  The space complexity is determined by the size of the fetched schedule and notification settings.
    - Edge Cases and Handling:
        - **Supabase Connection Loss:** Handles potential Supabase connection loss by retrying the operation with `reInitializeSupabase` set to `true`.
        - **Scheduling Errors:** Logs errors encountered during notification scheduling and retries the operation once.
        - **Device Reboot:** Uses `rescheduleOnReboot: true` to ensure that the task is rescheduled when the device reboots.

## 5. Data Flow

- **How Data Moves Through This Subsystem:**
    - **Initialization Data:** The subsystem receives configuration data, such as Supabase credentials, from environment variables or hardcoded values.
    - **User Preferences:** The subsystem retrieves user preferences, such as notification settings and display name, from `SharedPreferences`.
    - **Schedule Data:** The `scheduleTaskCallback` function fetches the user's schedule from the Supabase database through the `API` subsystem.
    - **Notification Data:** The `scheduleTaskCallback` function fetches pre-lesson notification preferences from the Supabase database through the `API` subsystem.

- **State Management Approaches:**
    - The `core` subsystem primarily relies on global variables and persistent storage (`SharedPreferences`) for state management.
    - The `MyApp` widget uses `ThemeData` to manage the application's visual state.

- **Input Validation and Data Transformation Patterns:**
    - Input validation is primarily handled within the individual functions that use the data. For example, the `preLessonNotificationListIsValid` function validates the structure and values of the pre-lesson notification settings.
    - Data transformation is used to convert data from one format to another.  For example, dates and times are converted to strings for storage in the database, and strings are parsed into `DateTime` and `TimeOfDay` objects for use in the application.

## 6. Implementation Details

- **Language-Specific Implementation Details:**
    - Dart's `async` and `await` keywords are used extensively to handle asynchronous operations, such as database queries and file I/O.
    - The `@pragma('vm:entry-point')` annotation is used to ensure that the `scheduleTaskCallback` function can be called from Dart's isolate, even in release mode.

- **Performance Optimizations:**
    - The `core` subsystem uses singletons and global variables to reduce object creation overhead.
    - The `scheduleTaskCallback` function is designed to minimize the amount of work performed in the background. It primarily focuses on scheduling notifications and avoids performing complex data processing.

- **Security Considerations:**
    - Sensitive data, such as Supabase credentials, should be stored securely and not hardcoded directly into the application.  Environment variables are the preferred method.
    - User data retrieved from the database should be handled securely and not exposed to unauthorized parties.
    - When using `AndroidAlarmManager`, be aware of the potential for Doze mode and App Standby to delay or prevent the execution of scheduled tasks. Use the `allowWhileIdle` and `alarmClock` flags appropriately.

## 7. Common Usage Patterns

- **Code Examples Showing How to Use Key Components:**

    ```dart
    // Using the logger
    logger.i('Application started');
    logger.e('An error occurred: $e');

    // Accessing shared preferences
    String? username = prefs.getString('username');
    await prefs.setString('username', 'new_username');

    // Using the Supabase client
    final response = await supabase