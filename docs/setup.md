# Setup Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The setup subsystem is responsible for initializing the application's core services and managing
user onboarding/profile configuration. It consists of two primary components:

1. **Supabase Initialization**: Configures the backend authentication and data services
2. **User Residence Setup**: Guides users through selecting their geographical location

### Architectural Role

- Handles initial application configuration
- Manages user profile completion
- Integrates authentication with user settings

## 2. Code Structure Analysis

### Files

- `API/supabase/setup.dart`: Supabase client initialization
- `pages/settings/setup.dart`: User residence setup page

### Dependencies

- `supabase_auth_ui`: Authentication UI components
- `main.dart`: Global application state
- Custom widgets for residence selection

## 3. Supabase Initialization API

### Function: `initializeSupabase()`

```dart
Future<void> initializeSupabase() async
```

#### Parameters

- None

#### Functionality

- Initializes Supabase client with:
    - Project URL
    - Anonymous (public) API key
- Assigns initialized client to global `supabaseClient`

#### Security Considerations

- Uses public anonymous key
- Recommended to use environment variables in production

## 4. Setup Page Implementation

### Class: `SetupPage`

A stateful widget managing user residence selection

#### Key Features

- Supports onboarding and profile update scenarios
- Cascading country and state/region selection
- Validates and saves user location information

### State Management

- `_selectedResidence`: Selected country
- `_exactSelectedResidence`: Selected state/region

### User Interaction Flow

1. Select Country
2. Select State/Region
3. Save configuration
4. Navigate to next screen

## 5. Data Flow and Validation

### Residence Selection

- Country selection enables state selector
- Selecting a state activates save button
- Prevents incomplete selections

### Save Process

```dart
await forceUpdateUserSettings(
  residenceCountry: _selectedResidence,
  residence: _exactSelectedResidence
);
```

- Updates user settings in backend
- Navigates to next route after successful save

## 6. Performance and Optimization

### Rendering Strategies

- Uses `SingleChildScrollView` for flexible layout
- Conditional rendering of state selector
- Efficient state management with `setState()`

## 7. Usage Patterns

### Initialization

```dart
// In main.dart or app entry point
await initializeSupabase();
```

### Launching Setup Page

```dart
Navigator.push(
  context, 
  MaterialPageRoute(
    builder: (context) => SetupPage(
      afterSelectionRoute: homePageRoute,
      isOnboarding: true
    )
  )
);
```

## 8. Testing Considerations

### Test Scenarios

- Supabase client initialization
- Country selection workflow
- State selection validation
- User settings update

### Recommended Test Coverage

- Unit tests for initialization logic
- Widget tests for selection interactions
- Integration tests for backend communication

## 9. Security and Error Handling

### Potential Improvements

- Add error handling for Supabase initialization
- Implement input validation for residence selection
- Use secure storage for sensitive configuration

## 10. Future Enhancements

- Support for more granular location selection
- Offline support for residence data
- Internationalization of location selection

---

**Note**: Sensitive information like Supabase URL and keys should be managed securely in production
environments, preferably through environment variables or secure configuration management.