import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enums/units.dart';
import '../blocs/language/language_cubit.dart';
import '../blocs/units/units_cubit.dart';
import '../blocs/weather/weather_bloc.dart';

class UnitsDropdown extends StatelessWidget {
  const UnitsDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsCubit, Units>(
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
    );
  }
}
