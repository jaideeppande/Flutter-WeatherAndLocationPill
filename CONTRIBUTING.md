# Contributing to Flutter Weather and Location Pill

Thank you for your interest in contributing to **Flutter Weather and Location Pill**! This document provides guidelines and instructions for contributing to the project.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)
- [Areas for Contribution](#areas-for-contribution)

---

## Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inspiring community for all. We expect all contributors to treat each other with respect and maintain a harassment-free environment.

### Expected Behavior
- Be respectful and constructive in discussions
- Accept criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members
- Respect differing opinions and ideas

### Unacceptable Behavior
- Harassment, discrimination, or intimidation
- Disrespectful or inflammatory comments
- Personal attacks
- Publishing private information without consent
- Trolling or spam

---

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart 3.11.1 or higher
- Git
- Code editor (VS Code, Android Studio, or IntelliJ)
- Familiarity with Dart and Flutter basics

### Fork and Clone

1. **Fork the repository** on GitHub
   - Click the "Fork" button on the main repository page
   
2. **Clone your fork** locally
   ```bash
   git clone https://github.com/YOUR_USERNAME/Flutter-WeatherAndLocationPill.git
   cd Flutter-WeatherAndLocationPill
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/jaideeppande/Flutter-WeatherAndLocationPill.git
   ```

---

## Development Setup

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Verify Setup
```bash
flutter doctor
flutter analyze
flutter test
```

### Step 3: Create Feature Branch
```bash
git checkout -b feature/your-feature-name
```

**Branch Naming Convention:**
- Feature: `feature/feature-name`
- Bug fix: `bugfix/bug-description`
- Documentation: `docs/doc-title`
- Performance: `perf/optimization-description`

### Step 4: Start Developing
Make your changes and ensure code quality:
```bash
# Format code
dart format lib/ test/

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## How to Contribute

### 1. **Report a Bug**

#### Before Submitting
- Check existing issues to avoid duplicates
- Verify the bug on the latest version
- Gather relevant information:
  - Flutter version (`flutter --version`)
  - Dart version
  - Device/Platform details
  - Error messages and logs
  - Steps to reproduce

#### Creating a Bug Report
Use the GitHub Issues page and include:
```markdown
### Environment
- Flutter version: X.X.X
- Dart version: X.X.X
- Platform: Android/iOS/Web/Windows
- Device: [Device model if applicable]

### Describe the Bug
[Clear description of the issue]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [...]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Screenshots/Logs
[If applicable]

### Additional Context
[Any other relevant information]
```

### 2. **Suggest an Enhancement**

#### Before Submitting
- Check existing issues for similar suggestions
- Verify the enhancement aligns with project goals
- Consider implementation feasibility

#### Creating an Enhancement Request
```markdown
### Description
[Clear description of the enhancement]

### Motivation
[Why is this enhancement needed?]

### Proposed Solution
[How would you implement this?]

### Alternative Solutions
[Any alternative approaches?]

### Additional Context
[Any other relevant information]
```

### 3. **Submit a Pull Request**

#### Preparation Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Tests written and passing
- [ ] No new warnings from `flutter analyze`
- [ ] Documentation updated
- [ ] Commit messages are clear

#### PR Description Template
```markdown
## Description
[Brief description of changes]

## Related Issues
Closes #[issue-number]

## Type of Change
- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 📝 Documentation update
- [ ] 🎨 UI/UX improvement
- [ ] ⚡ Performance improvement
- [ ] ♻️ Code refactor

## How Has This Been Tested?
[Describe testing done]

## Screenshots (if applicable)
[Add screenshots of UI changes]

## Breaking Changes
- [ ] No breaking changes
- [ ] Yes, and documented below

[If yes, describe breaking changes]

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No new console errors/warnings
```

---

## Coding Standards

### Dart Style Guide
Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

### General Guidelines

#### 1. **Naming Conventions**
```dart
// Classes: PascalCase
class WeatherService { }

// Variables & functions: camelCase
String weatherCode;
void fetchWeather() { }

// Constants: camelCase (not SCREAMING_SNAKE_CASE)
const int maxRetries = 3;

// Private members: prefix with underscore
String _privateVariable;
void _privateMethod() { }

// Booleans: prefix with 'is', 'has', or 'should'
bool isDay;
bool hasPermission;
bool shouldRetry;
```

#### 2. **File Structure**
```dart
// 1. Imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 2. Exports (if any)
export 'utils/helper.dart';

// 3. Constants
const String apiUrl = 'https://api.example.com';

// 4. Main class/function
class MyClass {
  // Implementation
}

// 5. Helper functions/classes (if not in separate file)
void _helperFunction() { }
```

#### 3. **Comments**
```dart
// Use /// for documentation comments
/// Fetches weather data for the given coordinates.
/// 
/// Returns a [WeatherSnapshot] containing current weather information.
/// Throws [WeatherServiceException] if the API call fails.
Future<WeatherSnapshot> fetchWeather({
  required double latitude,
  required double longitude,
}) async {
  // Use // for implementation comments
  // Validate coordinates
  if (latitude < -90 || latitude > 90) {
    throw ArgumentError('Invalid latitude');
  }
  
  // Make API call
  final response = await _client.get(Uri.https(...));
  
  // TODO: Add error handling for timeout
  // FIXME: Memory leak in this implementation
}
```

#### 4. **Code Organization**
```dart
class WeatherService implements WeatherGateway {
  // 1. Static constants
  static const String _apiHost = 'api.open-meteo.com';
  
  // 2. Instance variables
  final http.Client _client;
  
  // 3. Constructor
  WeatherService({http.Client? client})
    : _client = client ?? http.Client();
  
  // 4. Overridden methods
  @override
  Future<WeatherSnapshot> fetchWeather(...) async { }
  
  // 5. Public methods
  Future<String> reverseGeocode(...) async { }
  
  // 6. Private methods
  Future<Map<String, dynamic>> _parseResponse(...) async { }
  
  // 7. Helper methods
  Uri _buildUri(...) { }
}
```

#### 5. **Error Handling**
```dart
// Use specific exceptions
try {
  final weather = await weatherService.fetchWeather(...);
} on WeatherServiceException catch (e) {
  // Handle weather-specific error
  print('Weather error: ${e.toString()}');
} on SocketException catch (e) {
  // Handle network error
  print('Network error: ${e.message}');
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
}

// Create custom exceptions with meaningful messages
class WeatherServiceException implements Exception {
  const WeatherServiceException(this.message);
  final String message;
  
  @override
  String toString() => message;
}
```

#### 6. **Null Safety**
```dart
// Always declare nullability explicitly
String? nullableString;
String nonNullString = 'value';

// Use null assertions carefully
String value = nullableString!; // Only when you're sure it's not null

// Use null coalescing operator
String displayValue = nullableString ?? 'Unknown';

// Use null-safe navigation
String? cityName = location?.city?.name;
```

#### 7. **Widget Guidelines**
```dart
// Keep widgets focused
// Bad:
class ComplexWidget extends StatefulWidget {
  // 500 lines of code
}

// Good: Extract into smaller widgets
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildFooter(),
      ],
    );
  }
  
  Widget _buildHeader() => // ...
  Widget _buildContent() => // ...
  Widget _buildFooter() => // ...
}
```

---

## Commit Guidelines

### Commit Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Test additions or modifications
- `chore`: Build, dependency updates

### Scope (Optional)
- `weather-service`
- `geolocation`
- `ui`
- `models`
- etc.

### Examples
```bash
# Feature
git commit -m "feat(weather-service): add temperature unit conversion"

# Bug fix
git commit -m "fix(ui): correct weather icon display for night conditions"

# Documentation
git commit -m "docs: update installation instructions for Windows"

# Refactor
git commit -m "refactor(models): extract common properties to base class"
```

### Full Example
```bash
git commit -m "feat(weather-service): add humidity and pressure metrics

- Integrate humidity and pressure data from Open-Meteo API
- Update WeatherSnapshot model to include new fields
- Display metrics in UI with formatted values
- Add tests for new fields

Closes #42"
```

---

## Pull Request Process

### Before Creating PR
1. Ensure all tests pass: `flutter test`
2. No linting errors: `flutter analyze`
3. Format code: `dart format lib/ test/`
4. Update documentation if needed
5. Rebase with main branch:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

### Creating PR
1. Push your branch to your fork
   ```bash
   git push origin feature/your-feature
   ```

2. Create Pull Request on GitHub
   - Use clear title and description
   - Link related issues
   - Describe changes clearly

### PR Review Process
1. **Automated Checks**
   - Tests must pass
   - No linting errors
   - Code analysis successful

2. **Code Review**
   - Project maintainer reviews code
   - May request changes or clarification
   - Respond to comments professionally

3. **Approval & Merge**
   - Once approved, your PR will be merged
   - Your contribution appears in next release

---

## Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage

# Watch mode (re-run on changes)
flutter test --watch
```

### Writing Tests

#### Unit Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/services/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('parseWeatherCode returns correct description', () {
      // Arrange
      const int weatherCode = 0;
      
      // Act
      final description = parseWeatherCode(weatherCode);
      
      // Assert
      expect(description, equals('Clear sky'));
    });
    
    test('fetchWeather throws on invalid coordinates', () async {
      // Arrange
      final service = WeatherService();
      
      // Assert
      expect(
        () => service.fetchWeather(
          latitude: 200, // Invalid
          longitude: 0,
          locationLabel: 'Test',
        ),
        throwsException,
      );
    });
  });
}
```

#### Widget Tests
```dart
void main() {
  group('WeatherLocationPage', () {
    testWidgets('displays weather when loaded', (WidgetTester tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: WeatherLocationPage(
            weatherGateway: MockWeatherService(),
            geolocationGateway: MockGeolocationService(),
          ),
        ),
      );
      
      // Verify initial state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Trigger rebuild
      await tester.pumpAndSettle();
      
      // Verify final state
      expect(find.text('22°C'), findsOneWidget);
    });
  });
}
```

### Test Coverage Goals
- Aim for >80% code coverage
- Test critical paths (happy path and error cases)
- Test business logic thoroughly
- Widget tests for UI changes

---

## Documentation

### README Updates
- Update README.md for significant changes
- Add new features to feature list
- Update installation instructions if needed
- Add screenshots for UI changes

### Code Documentation
- Add doc comments for public APIs
- Update inline comments for complex logic
- Document exceptions and error cases
- Add examples in comments where helpful

### Changelog
- Maintain CHANGELOG.md (if applicable)
- Document breaking changes
- Credit contributors

---

## Areas for Contribution

### 🐛 Bug Fixes
- Report issues you find
- Help fix known bugs
- Improve error handling

### ✨ New Features
- **Weather Data**: Additional metrics (pressure, UV index, visibility)
- **UI Improvements**: Better visualizations, animations
- **Localization**: Multi-language support (i18n)
- **Offline Support**: Cache weather data
- **Notifications**: Weather alerts
- **Favorites**: Save favorite locations
- **Search**: Location search functionality

### 📱 Platform Support
- Complete iOS implementation
- macOS desktop support
- Linux desktop support (if needed)

### 📚 Documentation
- Improve README and comments
- Create tutorials
- Add API documentation
- Create architecture guides

### 🧪 Testing
- Expand test coverage
- Add integration tests
- Create performance benchmarks
- Add E2E tests

### 🎨 UI/UX
- Dark mode theme
- Material You customization
- Animations and transitions
- Accessibility improvements

### ⚡ Performance
- Optimize API calls
- Improve UI rendering performance
- Reduce memory usage
- Optimize bundle size

---

## Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)
- [Dart Analysis](https://dart.dev/guides/language/analysis-options)
- [GitHub Help](https://docs.github.com)

---

## Getting Help

### Questions?
- Open an issue with your question
- Check existing issues for answers
- Comment on relevant discussions

### Contact
- Reach out to maintainer on GitHub
- Check GitHub Discussions

---

## Recognition

All contributors are awesome! 🎉

Your contributions will be:
- ✅ Credited in the release notes
- ✅ Mentioned in README contributors section
- ✅ Acknowledged in the project

---

## License

By contributing, you agree that your contributions will be licensed under the same MIT License as this project.

---

**Thank you for contributing to Flutter Weather and Location Pill!** 🙏

Together, we build better software!
