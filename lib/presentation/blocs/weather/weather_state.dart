part of 'weather_bloc.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherResponse weather;
  final Units units;
  WeatherLoaded(this.weather, this.units);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

class WeatherLocationDenied extends WeatherState {}