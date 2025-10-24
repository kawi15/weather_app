part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class FetchWeatherByCoordsEvent extends WeatherEvent {
  final String city;
  final Units units;
  final String lang;
  FetchWeatherByCoordsEvent({required this.city, required this.units, required this.lang});
}

class FetchWeatherForCurrentLocationEvent extends WeatherEvent {
  final String lang;
  final Units units;
  FetchWeatherForCurrentLocationEvent({required this.units, required this.lang});
}