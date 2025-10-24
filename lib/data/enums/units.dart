enum Units {
  standard, // Kelvin
  metric,   // Celsius
  imperial, // Fahrenheit
}

extension UnitsExtension on Units {
  String get value {
    switch (this) {
      case Units.standard:
        return 'standard';
      case Units.metric:
        return 'metric';
      case Units.imperial:
        return 'imperial';
    }
  }

  String get label {
    switch (this) {
      case Units.standard:
        return 'K';
      case Units.metric:
        return '°C';
      case Units.imperial:
        return '°F';
    }
  }
}