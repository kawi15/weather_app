import 'package:weather/data/enums/units.dart';

import '../../data/models/weather_response.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/services/location_service.dart';

class WeatherViewModel {
  final WeatherRepository repository;
  final LocationService locationService;

  WeatherViewModel(this.repository, this.locationService);

  Future<WeatherResponse> getWeatherByCoords(
      double lat,
      double lon, {
        required Units units,
        String lang = 'pl',
      }) async {
    return await repository.fetchWeather(lat, lon, units, lang);
  }

  Future<WeatherResponse> getWeatherForCity(
      String city, {
        required Units units,
        String lang = 'pl',
      }) async {
    final (lat, lon) = await locationService.getCoordinatesFromCity(city);
    return await getWeatherByCoords(lat, lon, units: units, lang: lang);
  }

  Future<WeatherResponse> getWeatherForCurrentLocation({
    required Units units,
    String lang = 'pl',
  }) async {
    final (lat, lon) = await locationService.getCurrentLocation();
    return await getWeatherByCoords(lat, lon, units: units, lang: lang);
  }
}