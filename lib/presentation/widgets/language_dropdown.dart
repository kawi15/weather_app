import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/language/language_cubit.dart';
import '../blocs/units/units_cubit.dart';
import '../blocs/weather/weather_bloc.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
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
    );
  }
}
