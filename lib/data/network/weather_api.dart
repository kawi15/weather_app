import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather_response.dart';

part 'weather_api.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/2.5/")
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET("weather")
  Future<WeatherResponse> getWeather(
      @Query("lat") double lat,
      @Query("lon") double lon,
      @Query("appid") String apiKey, {
        @Query("units") String? units,
        @Query("lang") String? lang,
      });
}