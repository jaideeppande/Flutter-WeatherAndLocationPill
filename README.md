# Flutter Weather and Location Pill 🌤️📍

A beautiful, responsive Flutter application that displays real-time weather information with geolocation capabilities. Built with clean architecture principles and modern Flutter best practices.

## About

**Weather and Location Pill** is a feature-rich weather application that combines real-time weather data with location services. The app provides users with accurate weather information for their current location or predefined locations around the world. With an intuitive UI and seamless integration of location services, this application demonstrates best practices in Flutter development.

### Key Features

#### 🌍 Location Management
- **Auto-detect GPS Location**: Automatically detect your current location using device GPS with high accuracy
- **Predefined Locations**: Access weather for major cities worldwide including:
  - New York, USA
  - London, UK
  - Tokyo, Japan
  - Mumbai, India
  - And more!
- **Location Switching**: Easily switch between different locations with a dropdown selector
- **Reverse Geocoding**: Convert coordinates into human-readable location names

#### 🌡️ Real-time Weather Data
- **Current Temperature**: Display temperature in Celsius with precision
- **Weather Conditions**: Detailed weather code mapping to descriptive conditions
- **Wind Speed**: Current wind speed in km/h
- **Humidity**: Relative humidity percentage
- **Day/Night Detection**: Smart differentiation between day and night conditions
- **Real-time Updates**: Fresh data timestamp for each weather snapshot

#### 🎨 User Interface
- **Material Design 3**: Modern UI with Material You design system
- **Custom Typography**: Google Fonts integration with Space Grotesk font family
- **Responsive Layout**: Optimized for different screen sizes
- **Loading States**: Visual feedback during data fetching
- **Error Handling**: User-friendly error messages and recovery options
- **Status Messages**: Clear communication of app status (resolving location, fetching weather, etc.)

#### 📡 API Integration
- **Open-Meteo Weather API**: Free, open-source weather data with high precision
- **Open-Meteo Geocoding API**: Reverse geolocation capabilities
- **No API Keys Required**: Works without authentication for basic use

#### 🏗️ Architecture
- **Clean Architecture**: Separation of concerns with gateway pattern
- **Dependency Injection**: Easy testing and modularity
- **Abstract Interfaces**: Weather and Geolocation gateways for flexibility
- **Exception Handling**: Custom exceptions with meaningful error messages
- **Testable Code**: Designed for comprehensive unit and widget testing

---

## Project Structure

```
lib/
├── main.dart                    # Application entry point and main UI
├── models/
│   ├── location_option.dart    # Location model class
│   └── weather_snapshot.dart   # Weather data model with formatted getters
├── services/
│   ├── weather_service.dart    # Weather API integration (gateway pattern)
│   └── geolocation_service.dart # GPS and location services
├── data/
│   └── location_options.dart   # Predefined locations and constants
└── utils/
    └── weather_code_mapper.dart # WMO weather code to description mapping

test/
└── widget_test.dart            # Widget and integration tests

android/                         # Android platform-specific code
ios/                            # iOS platform-specific code (if added)
web/                            # Web platform-specific code
windows/                        # Windows platform-specific code
```

---

## Technical Details

### Dependencies

#### Core Dependencies
- **flutter**: Flutter SDK
- **google_fonts**: ^8.0.2 - Google Fonts library for custom typography
- **http**: ^1.6.0 - HTTP client for API requests
- **geolocator**: ^14.0.2 - Geolocation plugin for GPS access
- **cupertino_icons**: ^1.0.8 - iOS-style icons

#### Development Dependencies
- **flutter_test**: Flutter testing framework
- **flutter_lints**: ^6.0.0 - Lint rules for code quality

### Environment
- **Dart SDK**: ^3.11.1
- **Minimum Flutter Version**: Latest stable (compatible with Dart 3.11.1+)

### Platform Support
- ✅ Android
- ✅ Windows
- ✅ Web
- 📱 iOS (requires configuration - see Installation)

---

## Installation & Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Dart 3.11.1 or higher
- Git
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Step 1: Clone the Repository

```bash
git clone https://github.com/jaideeppande/Flutter-WeatherAndLocationPill.git
cd Flutter-WeatherAndLocationPill
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Platform-Specific Setup

#### Android Setup
1. Ensure Android SDK is installed (API level 21 or higher)
2. The app automatically requests location permissions at runtime
3. No additional configuration needed

#### Windows Setup
```bash
flutter config --enable-windows-desktop
flutter create --platforms=windows .
```

#### Web Setup
```bash
flutter web
flutter run -d chrome
```

#### iOS Setup (Optional)
1. Open `ios/Podfile` and ensure deployment target is iOS 12.0 or higher
2. Run `pod install` in the ios directory
3. Configure location permissions in `ios/Runner/Info.plist`

### Step 4: Run the Application

#### On Android Device/Emulator
```bash
flutter run
```

#### On Windows
```bash
flutter run -d windows
```

#### On Web
```bash
flutter run -d chrome
```

#### On iOS Simulator
```bash
flutter run -d ios
```

---

## Usage Guide

### Getting Started

1. **Launch the App**: Open the Weather Pill application on your device
2. **Grant Permissions**: Allow location access when prompted
3. **View Weather**: The app will automatically display weather for your current location

### Switching Locations

1. Tap the dropdown menu showing the current location
2. Select a new location from the list
3. The app will automatically fetch weather data for the selected location
4. Weather information updates within seconds

### Understanding the Display

- **Temperature**: Large, prominent display in Celsius
- **Weather Status**: Description of current weather conditions
- **Wind Speed**: Displayed in kilometers per hour (km/h)
- **Humidity**: Shown as a percentage (%)
- **Time Indicator**: Distinguishes between day and night conditions
- **Last Updated**: Timestamp of when the data was fetched

### Error Handling

If you encounter errors:
- **"Location services are disabled"**: Enable GPS in your device settings
- **"Location permission was denied"**: Grant location permissions in app settings
- **Network errors**: Check internet connection and retry
- Tap the refresh button to retry weather fetch

---

## Architecture Overview

### Gateway Pattern
The app uses the **Gateway Pattern** for abstraction:

```
┌─────────────────────────┐
│    WeatherLocationPage   │
│    (UI/Presentation)    │
└────────┬────────────────┘
         │
    ┌────┴────┐
    │          │
┌───▼────────┐ ┌──────────────────┐
│Weather     │ │Geolocation       │
│Gateway     │ │Gateway           │
│(Interface) │ │(Interface)       │
└───┬────────┘ └──────┬───────────┘
    │                 │
┌───▼────────┐ ┌──────▼───────────┐
│Weather     │ │Geolocation       │
│Service     │ │Service           │
│(Impl)      │ │(Impl)            │
└────────────┘ └──────────────────┘
    │                 │
    │ HTTP            │ GPS/Permissions
    │                 │
┌───▼────────┐ ┌──────▼───────────┐
│Open-Meteo  │ │Device Location   │
│API         │ │Provider          │
└────────────┘ └──────────────────┘
```

### Data Flow

1. **Initialization**: App loads predefined locations and initializes services
2. **User Action**: User selects location (auto-detect or manual)
3. **Location Resolution**: 
   - If GPS: Fetch current coordinates
   - If Manual: Use predefined coordinates
4. **Weather Fetch**: Call Open-Meteo API with coordinates
5. **Data Parsing**: Convert JSON response to WeatherSnapshot model
6. **UI Update**: Update state with new weather data
7. **Error Handling**: Display appropriate error messages if any step fails

### Model Classes

#### LocationOption
```dart
class LocationOption {
  final String id;           // Unique identifier
  final String label;        // Display name
  final bool usesGps;        // True if GPS-based
  final double? latitude;    // Coordinates (null for GPS)
  final double? longitude;   // Coordinates (null for GPS)
}
```

#### WeatherSnapshot
```dart
class WeatherSnapshot {
  final String locationLabel;    // Where this weather is for
  final double temperatureC;     // Temperature in Celsius
  final int weatherCode;         // WMO weather code
  final double windSpeedKph;     // Wind in km/h
  final double humidityPercent;  // Humidity %
  final bool isDay;              // Day/night status
  final DateTime fetchedAt;      // When data was fetched
}
```

---

## API Reference

### Open-Meteo Weather API

**Endpoint**: `https://api.open-meteo.com/v1/forecast`

**Parameters**:
- `latitude`: Location latitude
- `longitude`: Location longitude
- `current`: Data fields to retrieve (temperature, humidity, wind, weather code, day status)
- `temperature_unit`: Set to "celsius"
- `wind_speed_unit`: Set to "kmh"

**Response Example**:
```json
{
  "current": {
    "temperature_2m": 22.5,
    "relative_humidity_2m": 65,
    "weather_code": 2,
    "wind_speed_10m": 12.3,
    "is_day": 1
  }
}
```

### Open-Meteo Geocoding API

**Endpoint**: `https://geocoding-api.open-meteo.com/v1/search`

**Features**:
- Search locations by name
- Get coordinates from location names
- Reverse geocoding (convert coordinates to location names)

---

## Error Handling

The app implements comprehensive error handling:

### Custom Exceptions

#### WeatherServiceException
Thrown when:
- API request fails
- Invalid coordinates provided
- Network connectivity issues
- Malformed response data

#### GeolocationException
Thrown when:
- Location services disabled
- Permission denied
- GPS timeout
- Location not available

### User-Friendly Messages
All errors are caught and displayed as user-friendly messages:
- Clear explanation of what went wrong
- Suggested solutions
- Retry options

---

## Testing

The project includes widget tests for UI components and integration tests for service interactions.

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Coverage Areas
- Weather service API integration
- Geolocation service functionality
- Location switching logic
- UI state management
- Error handling scenarios

---

## Performance Considerations

### Optimization Features
- **State Management**: Efficient state updates using `setState`
- **API Caching**: Reduces redundant API calls
- **Lazy Loading**: Services initialized on demand
- **Error Recovery**: Graceful degradation on failures
- **Resource Management**: Proper cleanup of resources

### Network Optimization
- Uses lightweight Open-Meteo API (free tier)
- Minimal payload size (~1KB per request)
- No authentication overhead
- CDN-backed API endpoints

---

## Contributing

Contributions are welcome! Here's how to contribute:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Code Guidelines
- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Ensure tests pass before submitting PR
- Update README if adding new features

### Reporting Issues
- Use GitHub Issues to report bugs
- Provide clear description and reproduction steps
- Include screenshots/logs when applicable

---

## Roadmap

### Planned Features
- 🗓️ **Weather Forecast**: Extended 7-day forecast
- 📊 **Weather Charts**: Visualize temperature trends
- ⭐ **Favorites**: Save favorite locations
- 🔔 **Alerts**: Weather alerts and notifications
- 🌐 **Internationalization**: Multi-language support
- 🎨 **Themes**: Dark mode and multiple themes
- 📱 **iOS Support**: Native iOS app with proper permissions
- 🎯 **Search**: Location search functionality
- 📊 **Advanced Metrics**: Pressure, visibility, UV index
- ♻️ **Offline Mode**: Cache weather data for offline access

---

## Known Issues

- **iOS Support**: Currently not configured. Requires iOS deployment setup
- **Location Permissions**: Android requires runtime permission grant
- **API Rate Limiting**: Open-Meteo has generous free tier but may have rate limits

---

## License

This project is open source and available under the MIT License. See the LICENSE file for details.

---

## Credits

### APIs Used
- **[Open-Meteo](https://open-meteo.com/)**: Free weather API
- **[Open-Meteo Geocoding](https://open-meteo.com/en/docs/geocoding-api)**: Location services

### Packages
- **[Google Fonts](https://pub.dev/packages/google_fonts)**: Beautiful typography
- **[HTTP](https://pub.dev/packages/http)**: HTTP client
- **[Geolocator](https://pub.dev/packages/geolocator)**: Location services

### Design
- Material Design 3
- Google Material Icons

---

## Contact & Support

- **GitHub**: [jaideeppande](https://github.com/jaideeppande)
- **Repository**: [Flutter-WeatherAndLocationPill](https://github.com/jaideeppande/Flutter-WeatherAndLocationPill)

For questions, suggestions, or support, please open an issue on GitHub.

---

## Changelog

### Version 1.0.0 (Initial Release)
- ✨ Launch Weather and Location Pill
- 🌍 Location switching with GPS auto-detect
- 🌡️ Real-time weather data from Open-Meteo
- 🎨 Beautiful Material Design 3 UI
- 📱 Cross-platform support (Android, Windows, Web)
- 🧪 Widget and integration tests
- 📚 Comprehensive documentation

---

**Made with ❤️ by Jaidee Pande**

Last Updated: March 2026
