import 'package:geolocator/geolocator.dart';

class Coordinates {
  const Coordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

abstract class GeolocationGateway {
  Future<Coordinates> getCurrentCoordinates();
}

class GeolocationException implements Exception {
  const GeolocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GeolocationService implements GeolocationGateway {
  @override
  Future<Coordinates> getCurrentCoordinates() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const GeolocationException(
        'Location services are disabled. Turn GPS on and try again.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const GeolocationException('Location permission was denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const GeolocationException(
        'Location permission is permanently denied. Update it from settings.',
      );
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return Coordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
