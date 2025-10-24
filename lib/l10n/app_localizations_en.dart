// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appHeader => 'Weather app';

  @override
  String get labelTextField => 'Enter the city';

  @override
  String get downloadWeather => 'Download weather';

  @override
  String get error => 'Error';

  @override
  String get city => 'City';

  @override
  String get failedToGetLocation =>
      'Failed to load location. Please enter city name';

  @override
  String get addedToFav => 'added to favorites';

  @override
  String get favoriteCities => 'Favorite cities';

  @override
  String get noFavoriteCities => 'No favorite cities';

  @override
  String get humidity => 'Humidity';
}
