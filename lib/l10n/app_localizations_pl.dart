// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appHeader => 'Aplikacja pogodowa';

  @override
  String get labelTextField => 'Wprowadź nazwę miasta';

  @override
  String get downloadWeather => 'Pobierz pogodę';

  @override
  String get error => 'Błąd';

  @override
  String get city => 'Miasto';

  @override
  String get failedToGetLocation =>
      'Nie udało się pobrać lokalizacji. Wprowadź nazwę miasta';

  @override
  String get addedToFav => 'dodano do ulubionych';

  @override
  String get favoriteCities => 'Ulubione miasta';

  @override
  String get noFavoriteCities => 'Brak ulubionych miast';

  @override
  String get humidity => 'Wilgotność';

  @override
  String get openSettings => 'Otwórz ustawienia';
}
