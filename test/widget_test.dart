import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_weather_and_location/main.dart';
import 'package:flutter_weather_and_location/models/weather_snapshot.dart';
import 'package:flutter_weather_and_location/services/geolocation_service.dart';
import 'package:flutter_weather_and_location/services/weather_service.dart';

void main() {
  testWidgets('renders weather pill with resolved weather data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        weatherGateway: _FakeWeatherGateway(),
        geolocationGateway: _FakeGeolocationGateway(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Weather + Location Pill'), findsOneWidget);
    expect(find.text('Test City, Test Region'), findsOneWidget);
    expect(find.text('22°C'), findsOneWidget);
    expect(find.byKey(const Key('weather-temperature')), findsOneWidget);
  });
}

class _FakeGeolocationGateway implements GeolocationGateway {
  @override
  Future<Coordinates> getCurrentCoordinates() async {
    return const Coordinates(latitude: 12.9, longitude: 77.5);
  }
}

class _FakeWeatherGateway implements WeatherGateway {
  @override
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
    required String locationLabel,
  }) async {
    return WeatherSnapshot(
      locationLabel: locationLabel,
      temperatureC: 22.4,
      weatherCode: 2,
      windSpeedKph: 8.1,
      humidityPercent: 66.0,
      isDay: true,
      fetchedAt: DateTime(2026, 3, 9, 10, 30),
    );
  }

  @override
  Future<String> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    return 'Test City, Test Region';
  }
}
