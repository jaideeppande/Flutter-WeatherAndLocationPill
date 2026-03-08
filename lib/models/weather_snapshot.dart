class WeatherSnapshot {
  const WeatherSnapshot({
    required this.locationLabel,
    required this.temperatureC,
    required this.weatherCode,
    required this.windSpeedKph,
    required this.humidityPercent,
    required this.isDay,
    required this.fetchedAt,
  });

  final String locationLabel;
  final double temperatureC;
  final int weatherCode;
  final double windSpeedKph;
  final double humidityPercent;
  final bool isDay;
  final DateTime fetchedAt;

  String get temperatureText => '${temperatureC.toStringAsFixed(0)}°C';
  String get windText => '${windSpeedKph.toStringAsFixed(0)} km/h';
  String get humidityText => '${humidityPercent.toStringAsFixed(0)}%';
}
