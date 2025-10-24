import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../enums/units.dart';
import '../models/weather_response.dart';
import '../network/weather_api.dart';

class WeatherRepository {
  final WeatherApi api;

  WeatherRepository(this.api);

  Future<WeatherResponse> fetchWeather(double lat, double lng, Units units, String lang) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    try {
      return await api.getWeather(lat, lng, apiKey, units: units.value, lang: lang);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('API key invalid');
      }
      throw e;
    }


  }
}