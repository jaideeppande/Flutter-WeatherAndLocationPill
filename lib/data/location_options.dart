import '../models/location_option.dart';

const String gpsLocationId = 'gps_auto';

const List<LocationOption> locationOptions = <LocationOption>[
  LocationOption(id: gpsLocationId, label: 'Auto detect (GPS)', usesGps: true),
  LocationOption(
    id: 'new_york',
    label: 'New York, USA',
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  LocationOption(
    id: 'london',
    label: 'London, UK',
    latitude: 51.5072,
    longitude: -0.1276,
  ),
  LocationOption(
    id: 'tokyo',
    label: 'Tokyo, Japan',
    latitude: 35.6764,
    longitude: 139.6500,
  ),
  LocationOption(
    id: 'mumbai',
    label: 'Mumbai, India',
    latitude: 19.0760,
    longitude: 72.8777,
  ),
  LocationOption(
    id: 'sydney',
    label: 'Sydney, Australia',
    latitude: -33.8688,
    longitude: 151.2093,
  ),
];
