# Country Subsystem Technical Documentation

## 1. Subsystem Overview

### Purpose

The Country subsystem provides a data model representation of geographical and political entities,
encapsulating core information about countries including their name, country code, and flag
representation.

### Key Architectural Characteristics

- Immutable data model
- Supports JSON deserialization
- Implements object equality comparison
- Uses Uri for flag representation

## 2. Code Structure Analysis

### Class Definition

```dart
class Country {
  final String name;        // Country's common name
  final String code;        // ISO 2-letter country code
  final Uri flag;           // URI pointing to country's flag SVG
}
```

### Design Patterns

- Immutable Object Pattern
- Factory Constructor Pattern
- Value Object Pattern

## 3. API Documentation

### Constructor

```dart
Country(String name, String code, Uri flag)
```

- **Parameters**:
    - `name`: Full common name of the country
    - `code`: Two-letter country code (ISO 3166-1 alpha-2)
    - `flag`: URI referencing the country's flag SVG

### Factory Constructor

```dart
factory Country.fromJson(Map<String, dynamic> json)
```

- **Purpose**: Deserialize Country object from JSON data
- **Input**: JSON map from an external data source
- **Mapping**:
    - `name['common']` → Country name
    - `cca2` → Country code
    - `flags['svg']` → Flag URI

### Equality Operator

```dart
@override
bool operator ==(Object other)
```

- Compares Country instances based on `name`, `code`, and `flag`
- Supports deep equality comparison

## 4. Data Flow and Transformations

### JSON Deserialization Process

1. Receives raw JSON data
2. Extracts nested properties
3. Parses flag URL to Uri
4. Creates immutable Country instance

### Parsing Example

```dart
final jsonData = {
  'name': {'common': 'United States'},
  'cca2': 'US',
  'flags': {'svg': 'https://example.com/us-flag.svg'}
};

final country = Country.fromJson(jsonData);
```

## 5. Performance and Optimization

### Memory Efficiency

- Uses `final` keyword for immutability
- Minimal memory overhead
- Efficient object comparison

### Potential Improvements

- Consider adding cached hashCode for faster comparisons
- Implement null safety checks in factory constructor

## 6. Best Practices and Usage

### Recommended Usage

```dart
// Creating a country instance
final usa = Country('United States', 'US', Uri.parse('https://flag.url'));

// Using factory constructor
final country = Country.fromJson(apiResponse);

// Comparing countries
if (country1 == country2) {
  // Countries are considered equal
}
```

### Antipatterns to Avoid

- Mutating Country instances after creation
- Ignoring potential null/invalid JSON inputs

## 7. Error Handling Considerations

### Potential Failure Scenarios

- Malformed JSON
- Missing required fields
- Invalid flag URL

### Recommended Error Handling

- Implement null checks
- Use defensive programming techniques
- Consider adding custom exceptions

## 8. Testing Strategies

### Unit Test Scenarios

- JSON deserialization
- Equality comparison
- Flag URI parsing
- Edge case handling

### Sample Test Cases

```dart
test('Country.fromJson creates correct instance', () {
  final json = {...};  // Valid country JSON
  final country = Country.fromJson(json);
  
  expect(country.name, equals('Expected Name'));
  expect(country.code, equals('EX'));
});

test('Country instances with same data are equal', () {
  final country1 = Country('Name', 'CD', Uri.parse('flag.url'));
  final country2 = Country('Name', 'CD', Uri.parse('flag.url'));
  
  expect(country1, equals(country2));
});
```

## 9. Future Considerations

- Add more metadata (continent, population)
- Implement more robust validation
- Support additional country code formats