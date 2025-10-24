import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/favorite_city.dart';
import '../../../data/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc(this.repository) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      final favorites = await repository.getAll();
      emit(FavoritesLoaded(favorites));
    });

    on<AddFavoriteEvent>((event, emit) async {
      await repository.addCity(FavoriteCity(name: event.cityName));
      final favorites = await repository.getAll();
      emit(FavoritesLoaded(favorites));
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      await repository.removeCity(event.cityName);
      final favorites = await repository.getAll();
      emit(FavoritesLoaded(favorites));
    });
  }
}