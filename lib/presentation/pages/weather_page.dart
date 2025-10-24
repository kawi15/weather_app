import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/blocs/units/units_cubit.dart';
import 'package:weather/presentation/widgets/language_dropdown.dart';
import 'package:weather/presentation/widgets/units_dropdown.dart';
import 'package:weather/presentation/widgets/weather_error.dart';
import 'package:weather/presentation/widgets/weather_no_location_widget.dart';
import 'package:weather/presentation/widgets/weather_widget.dart';

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
  final TextEditingController controller = TextEditingController();


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
  //TODO napisać parę testów
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
            UnitsDropdown(),
            SizedBox(width: 8),
            LanguageDropdown(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: local.labelTextField,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _fetchWeather(controller.text.trim()),
                icon: const Icon(Icons.cloud_outlined),
                label: Text(local.downloadWeather),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherInitial || state is WeatherLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WeatherLoaded) {
                      return WeatherWidget(state: state);
                    } else if (state is WeatherError) {
                      return WeatherErrorWidget(message: '${local.error}: ${state.message}');
                    } else if (state is WeatherLocationDenied) {
                      return WeatherNoLocationWidget();
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
                  MaterialPageRoute(builder: (_) => FavoritesPage(controller: controller)),
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
