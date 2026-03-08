import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/location_options.dart';
import 'models/location_option.dart';
import 'models/weather_snapshot.dart';
import 'services/geolocation_service.dart';
import 'services/weather_service.dart';
import 'utils/weather_code_mapper.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.weatherGateway, this.geolocationGateway});

  final WeatherGateway? weatherGateway;
  final GeolocationGateway? geolocationGateway;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Pill',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A84FF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
      ),
      home: WeatherLocationPage(
        weatherGateway: weatherGateway ?? WeatherService(),
        geolocationGateway: geolocationGateway ?? GeolocationService(),
      ),
    );
  }
}

class WeatherLocationPage extends StatefulWidget {
  const WeatherLocationPage({
    super.key,
    required this.weatherGateway,
    required this.geolocationGateway,
  });

  final WeatherGateway weatherGateway;
  final GeolocationGateway geolocationGateway;

  @override
  State<WeatherLocationPage> createState() => _WeatherLocationPageState();
}

class _WeatherLocationPageState extends State<WeatherLocationPage> {
  late String _selectedLocationId;
  WeatherSnapshot? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _selectedLocationId = locationOptions.first.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshWeather());
  }

  Future<void> _refreshWeather() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _statusMessage = 'Resolving location...';
    });

    try {
      final _ResolvedLocation location = await _resolveSelectedLocation();

      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Fetching weather from Open-Meteo...';
      });

      final WeatherSnapshot weather = await widget.weatherGateway.fetchWeather(
        latitude: location.latitude,
        longitude: location.longitude,
        locationLabel: location.label,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _weather = weather;
        _isLoading = false;
        _statusMessage = null;
        _errorMessage = null;
      });
    } on GeolocationException catch (error) {
      _setError(error.message);
    } on WeatherServiceException catch (error) {
      _setError(error.message);
    } on TimeoutException {
      _setError('The weather request timed out. Please try again.');
    } on Object {
      _setError('Unable to load weather right now. Please try again.');
    }
  }

  Future<_ResolvedLocation> _resolveSelectedLocation() async {
    final LocationOption selected = locationOptions.firstWhere(
      (LocationOption option) => option.id == _selectedLocationId,
      orElse: () => locationOptions.first,
    );

    if (selected.usesGps) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Detecting your GPS location...';
        });
      }

      final Coordinates coordinates = await widget.geolocationGateway
          .getCurrentCoordinates();

      final String detectedLabel = await widget.weatherGateway.reverseGeocode(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

      return _ResolvedLocation(
        label: detectedLabel,
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
    }

    if (!selected.hasCoordinates) {
      throw const WeatherServiceException(
        'Selected location is not configured.',
      );
    }

    return _ResolvedLocation(
      label: selected.label,
      latitude: selected.latitude!,
      longitude: selected.longitude!,
    );
  }

  void _setError(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _statusMessage = null;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF74C7F8),
              Color(0xFFA2D2FF),
              Color(0xFFFEE08B),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            const _BackdropOrb(
              alignment: Alignment(-1.1, -1.0),
              diameter: 280,
              color: Color(0x66FFFFFF),
            ),
            const _BackdropOrb(
              alignment: Alignment(1.05, -0.2),
              diameter: 220,
              color: Color(0x55B8F2E6),
            ),
            const _BackdropOrb(
              alignment: Alignment(-0.65, 1.05),
              diameter: 240,
              color: Color(0x44FFD8A8),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Weather + Location Pill',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sora(
                            fontSize: 42,
                            height: 1.05,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0A284B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Pick a city or auto-detect with GPS, then stream live weather from Open-Meteo.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF13375A),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 30),
                        _buildLiquidGlassPill(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidGlassPill(BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).width < 700;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.2,
            ),
            gradient: LinearGradient(
              colors: <Color>[
                Colors.white.withValues(alpha: 0.44),
                Colors.white.withValues(alpha: 0.16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.34),
                blurRadius: 34,
                spreadRadius: -20,
                offset: const Offset(-6, -8),
              ),
              BoxShadow(
                color: const Color(0x330A284B),
                blurRadius: 40,
                spreadRadius: -18,
                offset: const Offset(10, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (compact) ...<Widget>[
                _buildDropdown(),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildRefreshButton(),
                ),
              ] else
                Row(
                  children: <Widget>[
                    Expanded(child: _buildDropdown()),
                    const SizedBox(width: 12),
                    _buildRefreshButton(),
                  ],
                ),
              const SizedBox(height: 18),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildWeatherContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.46),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocationId,
          isExpanded: true,
          dropdownColor: const Color(0xFFF7FBFF),
          borderRadius: BorderRadius.circular(20),
          style: const TextStyle(
            color: Color(0xFF13375A),
            fontWeight: FontWeight.w700,
          ),
          iconEnabledColor: const Color(0xFF13375A),
          items: locationOptions
              .map(
                (LocationOption option) => DropdownMenuItem<String>(
                  value: option.id,
                  child: Text(option.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: _isLoading
              ? null
              : (String? nextValue) {
                  if (nextValue == null) {
                    return;
                  }
                  setState(() {
                    _selectedLocationId = nextValue;
                  });
                  _refreshWeather();
                },
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    final bool gpsSelection = _selectedLocationId == gpsLocationId;
    return FilledButton.icon(
      onPressed: _isLoading ? null : _refreshWeather,
      icon: Icon(gpsSelection ? Icons.my_location : Icons.wb_cloudy_outlined),
      label: Text(gpsSelection ? 'Use GPS' : 'Refresh'),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF0A4A88),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context) {
    if (_isLoading) {
      return Container(
        key: const ValueKey<String>('loading'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _statusMessage ?? 'Loading weather...',
                style: const TextStyle(
                  color: Color(0xFF13375A),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        key: const ValueKey<String>('error'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, color: Color(0xFF8A2424)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Color(0xFF8A2424),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return Container(
        key: const ValueKey<String>('idle'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Select a location to load live weather.',
          style: TextStyle(
            color: Color(0xFF13375A),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final WeatherSnapshot weather = _weather!;
    final String condition = WeatherCodeMapper.descriptionFor(
      weather.weatherCode,
      isDay: weather.isDay,
    );
    final String updatedAt = TimeOfDay.fromDateTime(
      weather.fetchedAt,
    ).format(context);

    return Container(
      key: const ValueKey<String>('weather'),
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.66),
                ),
                child: Icon(
                  _iconForWeather(weather.weatherCode, weather.isDay),
                  color: const Color(0xFF0A4A88),
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      weather.locationLabel,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0E2D4D),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      condition,
                      style: const TextStyle(
                        color: Color(0xFF1D4871),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                weather.temperatureText,
                key: const Key('weather-temperature'),
                style: const TextStyle(
                  color: Color(0xFF09233D),
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _MetricPill(label: 'Wind', value: weather.windText),
              _MetricPill(label: 'Humidity', value: weather.humidityText),
              _MetricPill(label: 'Source', value: 'Open-Meteo'),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Updated at $updatedAt',
              style: const TextStyle(
                color: Color(0xFF355D85),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForWeather(int code, bool isDay) {
    if (code == 0) {
      return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (code >= 1 && code <= 3) {
      return Icons.cloud_rounded;
    }
    if (code == 45 || code == 48) {
      return Icons.blur_on_rounded;
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.umbrella_rounded;
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }
    if (code == 95 || code == 96 || code == 99) {
      return Icons.thunderstorm_rounded;
    }
    return Icons.wb_cloudy_rounded;
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.5),
        border: Border.all(color: Colors.white.withValues(alpha: 0.68)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF153A5E), fontSize: 13),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({
    required this.alignment,
    required this.diameter,
    required this.color,
  });

  final Alignment alignment;
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _ResolvedLocation {
  const _ResolvedLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}
