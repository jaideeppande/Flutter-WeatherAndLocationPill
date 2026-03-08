class LocationOption {
  const LocationOption({
    required this.id,
    required this.label,
    this.latitude,
    this.longitude,
    this.usesGps = false,
  });

  final String id;
  final String label;
  final double? latitude;
  final double? longitude;
  final bool usesGps;

  bool get hasCoordinates => latitude != null && longitude != null;
}
