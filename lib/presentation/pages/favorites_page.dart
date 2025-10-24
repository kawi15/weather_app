import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/blocs/language/language_cubit.dart';
import '../blocs/favorite/favorites_bloc.dart';
import '../blocs/units/units_cubit.dart';
import '../blocs/weather/weather_bloc.dart';
import '../../l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  final TextEditingController controller;

  const FavoritesPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(local.favoriteCities)),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return Center(child: Text(local.noFavoriteCities));
            }
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];
                return ListTile(
                  title: Text(city.name),
                  onTap: () {
                    context.read<WeatherBloc>().add(FetchWeatherByCoordsEvent(
                        city: city.name,
                        units: context.read<UnitsCubit>().state,
                        lang: context.read<LanguageCubit>().state.languageCode));
                    controller.clear();
                    Navigator.pop(context);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(RemoveFavoriteEvent(city.name));
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}