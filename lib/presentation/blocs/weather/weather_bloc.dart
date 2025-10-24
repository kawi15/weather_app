import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/models/weather_response.dart';
import 'package:weather/data/enums/units.dart';

import '../../viewmodels/weather_viewmodel.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherViewModel viewModel;



  WeatherBloc(this.viewModel) : super(WeatherInitial()) {

    on<FetchWeatherByCoordsEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await viewModel.getWeatherForCity(event.city, units: event.units, lang: event.lang);
        emit(WeatherLoaded(weather, event.units));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<FetchWeatherForCurrentLocationEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await viewModel.getWeatherForCurrentLocation(units: event.units, lang: event.lang);
        emit(WeatherLoaded(weather, event.units));
      } catch (e) {
        if (e.toString().contains('Brak uprawnień do lokalizacji') ||
            e.toString().contains('Lokalizacja wyłączona')) {
          emit(WeatherLocationDenied());
        } else {
          emit(WeatherError(e.toString()));
        }
      }
    });
  }
}