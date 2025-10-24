import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/enums/units.dart';
import 'package:weather/presentation/blocs/units/units_cubit.dart';

import '../../l10n/app_localizations.dart';
import '../blocs/favorite/favorites_bloc.dart';
import '../blocs/language/language_cubit.dart';
import '../blocs/weather/weather_bloc.dart';
import 'favorites_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});


  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final unitsCubit = context.read<UnitsCubit>();
      final languageCubit = context.read<LanguageCubit>();
      await unitsCubit.loadUnits();
      final units = unitsCubit.state;
      final lang = languageCubit.state;
      context.read<WeatherBloc>().add(FetchWeatherForCurrentLocationEvent(units: units, lang: lang.languageCode));
    });
  }

  void _fetchWeather(String city) {
    if (city.isNotEmpty) {
      context.read<WeatherBloc>().add(FetchWeatherByCoordsEvent(
          city: city,
          units: context.read<UnitsCubit>().state,
          lang: context.read<LanguageCubit>().state.languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              local.appHeader,
              style: const TextStyle(color: Colors.white, fontSize: 20)
          ),
          backgroundColor: Colors.deepPurple,
          actions: [
            BlocBuilder<UnitsCubit, Units>(
              builder: (context, units) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<Units>(
                    value: units,
                    icon: const Icon(Icons.thermostat_outlined, color: Colors.white),
                    dropdownColor: Colors.blueGrey[900],
                    items: Units.values.map((unit) {
                      return DropdownMenuItem<Units>(
                        value: unit,
                        child: Text(
                          unit.label,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      if (selected != null) {
                        context.read<UnitsCubit>().updateUnits(selected);
                        final state = context.read<WeatherBloc>().state;
                        if (state is WeatherLoaded) {
                          context.read<WeatherBloc>().add(FetchWeatherByCoordsEvent(
                              city: state.weather.name,
                              units: selected,
                              lang: context.read<LanguageCubit>().state.languageCode
                          ));
                        } else {
                          context.read<WeatherBloc>().add(FetchWeatherForCurrentLocationEvent(
                              units: selected,
                              lang: context.read<LanguageCubit>().state.languageCode
                          ));
                        }
                      }
                    },
                  ),
                );
              },
            ),
            SizedBox(width: 8),
            BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<Locale>(
                    value: locale,
                    dropdownColor: Colors.blueGrey[900],
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Row(
                          children: [
                            Text('🇬🇧 ', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text('English', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: Locale('pl'),
                        child: Row(
                          children: [
                            Text('🇵🇱 ', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text('Polski', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (selectedLocale) {
                      if (selectedLocale != null) {
                        context.read<LanguageCubit>().changeLanguage(selectedLocale);
                        final state = context.read<WeatherBloc>().state;
                        if (state is WeatherLoaded) {
                          context.read<WeatherBloc>().add(FetchWeatherByCoordsEvent(
                              city: state.weather.name,
                              units: context.read<UnitsCubit>().state,
                              lang: selectedLocale.languageCode
                          ));
                        } else {
                          context.read<WeatherBloc>().add(FetchWeatherForCurrentLocationEvent(
                              units: context.read<UnitsCubit>().state,
                              lang: selectedLocale.languageCode
                          ));
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: local.labelTextField,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _fetchWeather(_controller.text.trim()),
                child: Text(local.downloadWeather),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WeatherLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WeatherLoaded) {
                      final w = state.weather;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              w.name,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text('${w.main.temp} ${state.units.label}'),
                            Text('${local.humidity}: ${w.main.humidity}%'),
                            Text(w.weather.first.description),
                          ],
                        ),
                      );
                    } else if (state is WeatherError) {
                      return Center(
                          child: Text('${local.error}: ${state.message}',
                              style: const TextStyle(color: Colors.red)));
                    } else if (state is WeatherLocationDenied) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              local.failedToGetLocation,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: local.city,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _fetchWeather(_controller.text.trim()),
                              child: Text(local.downloadWeather),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                return FloatingActionButton(
                  heroTag: 'addFav',
                  onPressed: () {
                    if (state is WeatherLoaded) {
                      final city = state.weather.name;
                      context.read<FavoritesBloc>().add(AddFavoriteEvent(city));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$city ${local.addedToFav}')),
                      );
                    }
                  },
                  child: const Icon(Icons.favorite),
                );
              }
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'showFav',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
                context.read<FavoritesBloc>().add(LoadFavoritesEvent());
              },
              child: const Icon(Icons.list),
            ),
          ],
        ),
      ),
    );
  }
}
