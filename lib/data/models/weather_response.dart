import 'package:json_annotation/json_annotation.dart';

part 'weather_response.g.dart';

@JsonSerializable()
class WeatherResponse {
  final String name;
  final MainWeather main;
  final List<WeatherDescription> weather;

  WeatherResponse({
    required this.name,
    required this.main,
    required this.weather,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$WeatherResponseFromJson(json);
}

@JsonSerializable()
class MainWeather {
  final double temp;
  final int humidity;

  MainWeather({required this.temp, required this.humidity});

  factory MainWeather.fromJson(Map<String, dynamic> json) =>
      _$MainWeatherFromJson(json);
}

@JsonSerializable()
class WeatherDescription {
  final String description;
  final String icon;

  WeatherDescription({required this.description, required this.icon});

  factory WeatherDescription.fromJson(Map<String, dynamic> json) =>
      _$WeatherDescriptionFromJson(json);
}