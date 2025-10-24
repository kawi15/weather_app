import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather/data/repositories/favorites_repository.dart';
import 'package:weather/data/services/db_service.dart';
import 'package:weather/data/services/location_service.dart';
import 'package:weather/data/services/units_service.dart';
import 'package:weather/presentation/blocs/favorite/favorites_bloc.dart';
import 'package:weather/presentation/blocs/language/language_cubit.dart';
import 'package:weather/presentation/blocs/units/units_cubit.dart';
import 'package:weather/presentation/blocs/weather/weather_bloc.dart';
import 'package:weather/presentation/pages/weather_page.dart';
import 'package:weather/presentation/viewmodels/weather_viewmodel.dart';
import 'l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

import 'data/network/weather_api.dart';
import 'data/repositories/weather_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late final Dio dio;
  late final WeatherApi api;
  late final WeatherRepository repository;
  late final LocationService locationService;
  late final WeatherViewModel viewModel;
  late final DBService dbService;
  late final FavoritesRepository favoritesRepository;
  late final UnitsService unitsService;
  late final UnitsCubit unitsCubit;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    api = WeatherApi(dio);
    repository = WeatherRepository(api);
    locationService = LocationService();
    viewModel = WeatherViewModel(repository, locationService);
    dbService = DBService();
    favoritesRepository = FavoritesRepository(dbService);
    unitsService = UnitsService();
    unitsCubit = UnitsCubit(unitsService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => UnitsCubit(unitsService)),
        BlocProvider(create: (_) => WeatherBloc(viewModel)),
        BlocProvider(create: (_) => FavoritesBloc(favoritesRepository))
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Weather app',
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const WeatherPage(),
          );
        }
      ),
    );
  }
}
