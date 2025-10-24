import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<(double lat, double lon)> getCoordinatesFromCity(String cityName) async {
    try {
      final locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return (loc.latitude, loc.longitude);
      } else {
        throw Exception('Nie znaleziono lokalizacji dla: $cityName');
      }
    } catch (e) {
      throw Exception('Błąd geokodowania: $e');
    }
  }

  Future<(double lat, double lon)> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Lokalizacja wyłączona');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw Exception('Brak uprawnień do lokalizacji');
    }

    final position = await Geolocator.getCurrentPosition();
    return (position.latitude, position.longitude);
  }
}