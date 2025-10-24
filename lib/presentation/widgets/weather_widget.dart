import 'package:flutter/material.dart';
import 'package:weather/data/enums/units.dart';
import 'package:weather/presentation/blocs/weather/weather_bloc.dart';

import '../../l10n/app_localizations.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherLoaded state;

  const WeatherWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final w = state.weather;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF8F94FB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              w.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.thermostat, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '${w.main.temp.toStringAsFixed(1)} ${state.units.label}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.water_drop, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '${local.humidity}: ${w.main.humidity}%',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              w.weather.first.description,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
