import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_snapshot.dart';

abstract class WeatherGateway {
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
    required String locationLabel,
  });

  Future<String> reverseGeocode({
    required double latitude,
    required double longitude,
  });
}

class WeatherServiceException implements Exception {
  const WeatherServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

class WeatherService implements WeatherGateway {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const String _weatherHost = 'api.open-meteo.com';
  static const String _geoHost = 'geocoding-api.open-meteo.com';

  final http.Client _client;

  @override
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
    required String locationLabel,
  }) async {
    final Uri uri = Uri.https(_weatherHost, '/v1/forecast', <String, String>{
      'latitude': latitude.toStringAsFixed(5),
      'longitude': longitude.toStringAsFixed(5),
      'current':
          'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,is_day',
      'temperature_unit': 'celsius',
      'wind_speed_unit': 'kmh',
      'timezone': 'auto',
    });

    final http.Response response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw WeatherServiceException(
        'Weather API returned status ${response.statusCode}.',
      );
    }

    final dynamic payload = jsonDecode(response.body);
    if (payload is! Map<String, dynamic>) {
      throw const WeatherServiceException('Unexpected weather response.');
    }

    final dynamic currentData = payload['current'];
    if (currentData is! Map<String, dynamic>) {
      throw const WeatherServiceException('Current weather data was missing.');
    }

    return WeatherSnapshot(
      locationLabel: locationLabel,
      temperatureC: _readDouble(currentData, 'temperature_2m'),
      humidityPercent: _readDouble(currentData, 'relative_humidity_2m'),
      weatherCode: _readInt(currentData, 'weather_code'),
      windSpeedKph: _readDouble(currentData, 'wind_speed_10m'),
      isDay: _readInt(currentData, 'is_day') == 1,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<String> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.https(_geoHost, '/v1/reverse', <String, String>{
      'latitude': latitude.toStringAsFixed(5),
      'longitude': longitude.toStringAsFixed(5),
      'count': '1',
      'language': 'en',
      'format': 'json',
    });

    try {
      final http.Response response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _fallbackLabel(latitude, longitude);
      }

      final dynamic payload = jsonDecode(response.body);
      if (payload is! Map<String, dynamic>) {
        return _fallbackLabel(latitude, longitude);
      }

      final dynamic results = payload['results'];
      if (results is! List || results.isEmpty) {
        return _fallbackLabel(latitude, longitude);
      }

      final dynamic firstResult = results.first;
      if (firstResult is! Map<String, dynamic>) {
        return _fallbackLabel(latitude, longitude);
      }

      final String name = _readText(firstResult['name']);
      final String admin1 = _readText(firstResult['admin1']);
      final String country = _readText(firstResult['country']);

      final List<String> segments = <String>[
        name,
        admin1,
        country,
      ].where((String part) => part.isNotEmpty).toList();

      if (segments.isEmpty) {
        return _fallbackLabel(latitude, longitude);
      }

      if (segments.length == 1) {
        return segments.first;
      }

      return '${segments[0]}, ${segments[1]}';
    } on TimeoutException {
      return _fallbackLabel(latitude, longitude);
    } on Object {
      return _fallbackLabel(latitude, longitude);
    }
  }

  String _readText(dynamic value) {
    if (value is String) {
      return value.trim();
    }
    return '';
  }

  String _fallbackLabel(double latitude, double longitude) {
    final String lat = latitude.toStringAsFixed(2);
    final String lon = longitude.toStringAsFixed(2);
    return '$lat, $lon';
  }

  double _readDouble(Map<String, dynamic> data, String key) {
    final dynamic value = data[key];
    if (value is num) {
      return value.toDouble();
    }
    throw WeatherServiceException('Weather field "$key" was not available.');
  }

  int _readInt(Map<String, dynamic> data, String key) {
    final dynamic value = data[key];
    if (value is num) {
      return value.toInt();
    }
    throw WeatherServiceException('Weather field "$key" was not available.');
  }
}
