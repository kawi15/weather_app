import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/data/enums/units.dart';
import 'package:weather/data/models/weather_response.dart';
import 'package:weather/presentation/blocs/weather/weather_bloc.dart';
import 'package:weather/presentation/viewmodels/weather_viewmodel.dart';

class MockWeatherViewModel extends Mock implements WeatherViewModel {}

void main() {
  late WeatherBloc bloc;
  late MockWeatherViewModel mockViewModel;
  late WeatherResponse fakeWeather;

  setUp(() {
    registerFallbackValue(Units.metric);
    mockViewModel = MockWeatherViewModel();
    bloc = WeatherBloc(mockViewModel);
    fakeWeather = WeatherResponse(name: 'London', main: MainWeather(temp: 20, humidity: 20), weather: []);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is WeatherInitial', () {
    expect(bloc.state, isA<WeatherInitial>());
  });

  test('emits [WeatherLoading, WeatherLoaded] on FetchWeatherByCoordsEvent success', () async {
    when(() => mockViewModel.getWeatherForCity(any(),
        units: any(named: 'units'), lang: any(named: 'lang')))
        .thenAnswer((_) async => fakeWeather);

    final expectedStates = <WeatherState>[];

    bloc.stream.listen(expectedStates.add);

    bloc.add(FetchWeatherByCoordsEvent(city: 'London', units: Units.metric, lang: 'en'));

    await Future.delayed(const Duration(milliseconds: 10));

    expect(expectedStates.length, 2);
    expect(expectedStates[0], isA<WeatherLoading>());
    expect(expectedStates[1], isA<WeatherLoaded>());
    expect((expectedStates[1] as WeatherLoaded).weather.name, 'London');
  });

  test('emits [WeatherLoading, WeatherError] on FetchWeatherByCoordsEvent failure', () async {
    when(() => mockViewModel.getWeatherForCity(any(),
        units: any(named: 'units'), lang: any(named: 'lang')))
        .thenThrow(Exception('API error'));

    final emitted = <WeatherState>[];
    bloc.stream.listen(emitted.add);

    bloc.add(FetchWeatherByCoordsEvent(city: 'Paris', units: Units.metric, lang: 'en'));

    await Future.delayed(const Duration(milliseconds: 10));

    expect(emitted.first, isA<WeatherLoading>());
    expect(emitted.last, isA<WeatherError>());
    expect((emitted.last as WeatherError).message, contains('API error'));
  });

  test('emits [WeatherLoading, WeatherLoaded] on FetchWeatherForCurrentLocationEvent success', () async {
    when(() => mockViewModel.getWeatherForCurrentLocation(
        units: any(named: 'units'), lang: any(named: 'lang')))
        .thenAnswer((_) async => fakeWeather);

    final emitted = <WeatherState>[];
    bloc.stream.listen(emitted.add);

    bloc.add(FetchWeatherForCurrentLocationEvent(units: Units.metric, lang: 'en'));

    await Future.delayed(const Duration(milliseconds: 10));

    expect(emitted.first, isA<WeatherLoading>());
    expect(emitted.last, isA<WeatherLoaded>());
  });

  test('emits [WeatherLoading, WeatherLocationDenied] when location permission denied', () async {
    when(() => mockViewModel.getWeatherForCurrentLocation(
        units: any(named: 'units'), lang: any(named: 'lang')))
        .thenThrow(Exception('Brak uprawnień do lokalizacji'));

    final emitted = <WeatherState>[];
    bloc.stream.listen(emitted.add);

    bloc.add(FetchWeatherForCurrentLocationEvent(units: Units.metric, lang: 'pl'));

    await Future.delayed(const Duration(milliseconds: 10));

    expect(emitted.first, isA<WeatherLoading>());
    expect(emitted.last, isA<WeatherLocationDenied>());
  });

  test('emits [WeatherLoading, WeatherError] when current location fails for other reason', () async {
    when(() => mockViewModel.getWeatherForCurrentLocation(
        units: any(named: 'units'), lang: any(named: 'lang')))
        .thenThrow(Exception('Timeout error'));

    final emitted = <WeatherState>[];
    bloc.stream.listen(emitted.add);

    bloc.add(FetchWeatherForCurrentLocationEvent(units: Units.metric, lang: 'en'));

    await Future.delayed(const Duration(milliseconds: 10));

    expect(emitted.first, isA<WeatherLoading>());
    expect(emitted.last, isA<WeatherError>());
    expect((emitted.last as WeatherError).message, contains('Timeout error'));
  });
}
