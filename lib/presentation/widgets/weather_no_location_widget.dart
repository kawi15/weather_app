import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/blocs/language/language_cubit.dart';
import 'package:weather/presentation/blocs/units/units_cubit.dart';
import 'package:weather/presentation/blocs/weather/weather_bloc.dart';

import '../../l10n/app_localizations.dart';

class WeatherNoLocationWidget extends StatelessWidget {
  const WeatherNoLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            local.failedToGetLocation,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                AppSettings.openAppSettings().then((_) {
                  context.read<WeatherBloc>().add(FetchWeatherForCurrentLocationEvent(
                      units: context.read<UnitsCubit>().state,
                      lang: context.read<LanguageCubit>().state.languageCode
                  ));
                });
              },
              child: Text(
                  local.openSettings
              )
          )
        ],
      ),
    );
  }
}
