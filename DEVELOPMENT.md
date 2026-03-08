# Development Guide

This guide covers everything you need to know for developing and maintaining the Flutter Weather and Location Pill project.

## Table of Contents
- [Environment Setup](#environment-setup)
- [Project Structure](#project-structure)
- [Running the Application](#running-the-application)
- [Debugging](#debugging)
- [Common Development Tasks](#common-development-tasks)
- [Performance Profiling](#performance-profiling)
- [Troubleshooting](#troubleshooting)

---

## Environment Setup

### System Requirements

#### Windows
- **OS**: Windows 10 or later
- **RAM**: 8 GB minimum (16 GB recommended)
- **Storage**: 10 GB free space
- **Android Studio**: Latest version with Android SDK
- **VS Code/IDE**: Any compatible IDE

#### macOS
- **OS**: macOS 10.13 or later
- **RAM**: 8 GB minimum
- **Xcode**: Latest version
- **Apple Silicon**: Supported (Intel and Apple Silicon chips)

#### Linux
- **OS**: Ubuntu 18.04 or later (Debian-based)
- **RAM**: 8 GB minimum
- **GTK**: 3.0 or later

### Step 1: Install Flutter

#### Using Flutter Installation
```bash
# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Or using Version Managers
**Using FVM (Flutter Version Manager - Recommended)**
```bash
# Install FVM
dart pub global activate fvm

# Install Flutter version
fvm install 3.16.0 (or latest)

# Use specific version
fvm use 3.16.0

# Use in project (creates .fvmrc)
fvm flutter run
```

### Step 2: Configure IDE

#### VS Code
1. Install extensions:
   - Flutter
   - Dart
   - DevTools for Android Studio (optional)

2. Set Flutter SDK path:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Search for "Flutter: Change Device Timeout"
   - Set custom Flutter SDK location if needed

#### Android Studio/IntelliJ
1. Install plugins:
   - Preferences → Plugins → Search "Flutter"
   - Preferences → Plugins → Search "Dart"

2. Configure SDK:
   - Preferences → Languages & Frameworks → Flutter
   - Set Flutter SDK path

### Step 3: Verify Setup

```bash
# Comprehensive system check
flutter doctor

# Output should show:
# ✓ Flutter (Channel stable)
# ✓ Android toolchain
# ✓ Chrome (for web)
# ✓ Visual Studio Code

# Update Flutter
flutter upgrade
```

### Step 4: Install Project Dependencies

```bash
# Navigate to project
cd Flutter-WeatherAndLocationPill

# Get dependencies
flutter pub get

# Get platform-specific dependencies
flutter pub get

# (Optional) Update dependencies
flutter pub upgrade
```

---

## Project Structure

### Directory Layout
```
Flutter-WeatherAndLocationPill/
├── lib/                                # Main source code
│   ├── main.dart                       # App entry point
│   ├── models/                         # Data models
│   │   ├── location_option.dart
│   │   └── weather_snapshot.dart
│   ├── services/                       # Business logic & APIs
│   │   ├── weather_service.dart        # Open-Meteo integration
│   │   └── geolocation_service.dart    # GPS & location
│   ├── data/                           # Constants & static data
│   │   └── location_options.dart       # Predefined locations
│   └── utils/                          # Utility functions
│       └── weather_code_mapper.dart    # WMO code mapping
│
├── test/                               # Test files
│   └── widget_test.dart                # Widget & integration tests
│
├── android/                            # Android platform code
│   ├── app/
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml
│   │           └── kotlin/...          # Kotlin code
│   └── build.gradle.kts
│
├── ios/                                # iOS platform code (if added)
│   └── Runner/
│
├── web/                                # Web platform code
│   ├── index.html
│   └── manifest.json
│
├── windows/                            # Windows platform code
│   ├── runner/
│   └── CMakeLists.txt
│
├── pubspec.yaml                        # Project configuration
├── pubspec.lock                        # Dependency lock file
├── analysis_options.yaml               # Linting configuration
├── README.md                           # Project documentation
├── ABOUT.md                            # About the project
├── CONTRIBUTING.md                     # Contribution guidelines
├── DEVELOPMENT.md                      # This file
└── .gitignore                          # Git ignore rules
```

### Key Files Explained

#### pubspec.yaml
```yaml
# Main project configuration file
name: flutter_weather_and_location
version: 1.0.0+1

environment:
  sdk: ^3.11.1  # Dart version minimum

dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  geolocator: ^14.0.2
  google_fonts: ^8.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
```

#### analysis_options.yaml
```yaml
# Dart linting and analyzer configuration
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null
    - prefer_const_constructors
    # ... more rules
```

---

## Running the Application

### Connected Devices

```bash
# List connected devices
flutter devices

# Sample output:
# Chrome             • chrome      • web-javascript • Google Chrome 90.0
# Android SDK        • android-1   • android x86-64  • emulator-5554
# iPhone 12          • ios         • ios             • com.apple.CoreSimulator.SimDeviceType.iPhone-12
```

### Running on Different Platforms

#### Android Device/Emulator
```bash
# Default (uses first available)
flutter run

# Specific device
flutter run -d <device-id>

# Release build
flutter run --release

# Profile build (for performance testing)
flutter run --profile
```

#### Windows Desktop
```bash
# Enable desktop support (if not already)
flutter config --enable-windows-desktop

# Run on Windows
flutter run -d windows

# Release build
flutter run -d windows --release
```

#### Web Browser
```bash
# Chrome (default)
flutter run -d chrome

# Firefox
flutter run -d firefox

# Safari (macOS only)
flutter run -d safari

# Release build
flutter run -d web --release
```

#### iOS Simulator (macOS only)
```bash
# Start simulator
open -a Simulator

# Run app
flutter run -d ios

# Release build
flutter run -d ios --release
```

### Advanced Run Options

```bash
# Run with logs
flutter run --verbose

# Run specific entry point
flutter run --target=lib/main_staging.dart

# Run with specific VM service port
flutter run --vm-service-port=5858

# Run and pause on entry
flutter run --start-paused

# Run with observatory debugging
flutter run --observatory-port=8181
```

---

## Debugging

### Debug Mode (Default)
```bash
# Start app in debug mode
flutter run

# Debug mode features:
# - JIT compilation
# - Source-level debugging
# - Slower performance
# - Can modify code during session (hot reload)
```

### Hot Reload

```bash
# During `flutter run` session, press 'r'
# In VS Code: Ctrl+Shift+F5
# In Android Studio: Ctrl+\

# Changes reflected in app within 1 second
# State is preserved
```

### Hot Restart

```bash
# During `flutter run` session, press 'R'
# In VS Code: Ctrl+Shift+F6
# In Android Studio: Ctrl+M

# Full app restart
# Device reset
# Slower than hot reload
```

### Using Flutter DevTools

```bash
# Open DevTools dashboard
flutter pub global activate devtools
devtools

# Or open during `flutter run`:
# Press 'd' for DevTools

# Features:
# - Inspector: Widget hierarchy
# - Console: Debug output
# - Timeline: Performance profiling
# - Memory: Memory usage
# - Network: HTTP requests
# - Logging: App logs
```

### IDE Debugging

#### VS Code
1. Configure launch.json:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": ["--verbose"]
    }
  ]
}
```

2. Start debugging:
   - Click Debug icon → Flutter
   - Or press `F5`
   - Breakpoints work as expected

#### Android Studio/IntelliJ
1. Click "Run" → "Debug" (Shift+F9)
2. Set breakpoints in code
3. Use debug panel for step through, watches, etc.

### Logging

```dart
// Simple print (visible in debug console)
print('Debug message: $value');

// Better approach: use logging package
import 'dart:developer' as developer;

developer.log(
  'Message',
  name: 'weather_service',
  error: exception,
  stackTrace: stackTrace,
);

// With Flutter:
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug only: $value');
}
```

### Debugging Network Requests

```bash
# Monitor HTTP traffic while app runs
# 1. Start app with verbose logging
flutter run --verbose

# 2. Look for HTTP logs in console
# 3. Use DevTools Network tab
```

### Breakpoint Debugging

#### VS Code
1. Click line number to set breakpoint (red dot appears)
2. Start debugging: `F5`
3. When breakpoint hit:
   - Step over: `F10`
   - Step into: `F11`
   - Step out: `Shift+F11`
   - Continue: `F5`

#### Android Studio
Similar process: click line number, then use debug toolbar

---

## Common Development Tasks

### Adding a New Feature

#### 1. Create Model (if needed)
```dart
// lib/models/new_model.dart
class NewModel {
  const NewModel({required this.id, required this.name});
  
  final String id;
  final String name;
}
```

#### 2. Create Service (if needed)
```dart
// lib/services/new_service.dart
abstract class NewGateway {
  Future<void> doSomething();
}

class NewService implements NewGateway {
  @override
  Future<void> doSomething() async {
    // Implementation
  }
}
```

#### 3. Update UI
```dart
// lib/main.dart
// Integrate new service/model
```

#### 4. Write Tests
```dart
// test/new_feature_test.dart
void main() {
  test('new feature works', () {
    // Arrange, act, assert
  });
}
```

### Modifying Existing Code

```bash
# Before making changes
git checkout -b feature/modification

# Make changes
# Run tests to ensure nothing breaks
flutter test

# Format code
dart format lib/ test/

# Analyze
flutter analyze

# Commit
git add .
git commit -m "feat: modify existing feature"
```

### Adding Dependencies

```bash
# Add from pub.dev
flutter pub add package_name

# Or manually edit pubspec.yaml and run
flutter pub get

# View installed packages
flutter pub pubspec

# Check for updates
flutter pub outdated
```

### Removing Dependencies

```bash
# Remove package
flutter pub remove package_name

# Or manually edit pubspec.yaml and run
flutter pub get
```

### Code Formatting

```bash
# Format all code
dart format lib/ test/

# Format specific file
dart format lib/main.dart

# Check formatting without modifying
dart format --output=none lib/
```

### Code Analysis

```bash
# Run analyzer
flutter analyze

# With verbose output
flutter analyze --verbose

# Fix common issues
dart fix --apply

# Preview fixes without applying
dart fix
```

---

## Performance Profiling

### Timeline Analysis

```bash
# Collect timeline data
flutter run --profile

# In DevTools:
# 1. Open DevTools (press 'd')
# 2. Go to Timeline tab
# 3. Interact with app
# 4. View frame rendering time

# Frame should render in <16.67ms (60 FPS)
```

### Memory Profiling

```bash
# Monitor memory usage
flutter run --profile

# In DevTools:
# 1. Open DevTools
# 2. Go to Memory tab
# 3. Trigger garbage collection
# 4. Monitor memory spikes

# Look for:
# - Memory leaks (continuously increasing)
# - Excessive allocations
# - GC overhead
```

### CPU Profiling

```bash
# Profile CPU usage
flutter run --profile

# Record CPU profile:
# 1. Open DevTools
# 2. Go to CPU Profiler
# 3. Start recording
# 4. Interact with app
# 5. Stop and analyze

# Identify:
# - Hot spots (functions taking most time)
# - Inefficient algorithms
# - Unnecessary computations
```

### Frame Rate Analysis

```bash
# Check frame rate continuously
flutter run --profile

# Performance overlay:
# 1. Press 'P' during app run
# 2. See FPS and frame render time
# 3. Target: 60 FPS consistently
```

---

## Troubleshooting

### Common Issues

#### Issue: "flutter command not found"
```bash
# Solution 1: Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Solution 2: Use absolute path
/path/to/flutter/bin/flutter run

# Solution 3: Reinstall Flutter
flutter clean
flutter pub get
```

#### Issue: "Gradle build failed"
```bash
# Clear gradle cache
cd android
./gradlew clean
cd ..

# Then rebuild
flutter clean
flutter pub get
flutter run
```

#### Issue: "CocoaPods dependency resolution failed"
```bash
# For iOS issues
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

flutter clean
flutter pub get
```

#### Issue: "Device not found"
```bash
# List available devices
flutter devices

# Start Android emulator
emulator -list-avds          # List available
emulator -avd device_name    # Start specific

# Start iOS simulator
open -a Simulator
```

#### Issue: "Hot reload not working"
```bash
# Try hot restart
# Press 'R' during flutter run

# If still not working, do:
flutter clean
flutter pub get
flutter run
```

#### Issue: "App crashes on startup"
```bash
# Check logs
flutter run -v

# Look for error in console output

# Common causes:
# - Permission issues (check AndroidManifest.xml)
# - Missing dependency
# - Null pointer exception
# - Resource not found

# Check permissions:
# android/app/src/main/AndroidManifest.xml
```

### Debug Output

```bash
# Verbose output provides detailed information
flutter run --verbose 2>&1 | tee debug.log

# Save logs to file
flutter run > logs.txt 2>&1

# Search for specific errors
flutter run --verbose 2>&1 | grep "ERROR"
```

### Network Issues

```bash
# Test API connectivity
curl https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m

# If API unreachable:
# 1. Check internet connection
# 2. Check firewall rules
# 3. Try from different network
# 4. Check API status at https://open-meteo.com/
```

### Permission Issues

#### Android
```bash
# Check permissions in manifest
cat android/app/src/main/AndroidManifest.xml

# Grant permissions manually on device
# Settings → Apps → Weather Pill → Permissions → Location
```

#### iOS
```bash
# Check permissions in Info.plist
cat ios/Runner/Info.plist

# Look for:
# - NSLocationWhenInUseUsageDescription
# - NSLocationAlwaysAndWhenInUseUsageDescription
```

---

## Build & Release

### Debug Build
```bash
flutter build apk --debug        # Android
flutter build app --debug        # iOS
flutter build windows --debug    # Windows
flutter build web --debug        # Web
```

### Release Build
```bash
flutter build apk --release      # Android
flutter build app --release      # iOS  
flutter build windows --release  # Windows
flutter build web --release      # Web
```

### Size Analysis

```bash
# Analyze app size
flutter build apk --analyze-size

# Output shows:
# - Total APK size
# - Breakdown by component
# - Unused code
```

---

## Continuous Integration

### GitHub Actions Setup

Create `.github/workflows/flutter_ci.yml`:

```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

---

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Flutter Codelabs](https://codelabs.developers.google.com/?product=flutter)
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)

---

**Happy Coding!** 🚀

For issues or questions, refer to the CONTRIBUTING.md file or open an issue on GitHub.
