import '../models/favorite_city.dart';
import '../services/db_service.dart';

class FavoritesRepository {
  final DBService db;

  FavoritesRepository(this.db);

  Future<void> addCity(FavoriteCity city) => db.addFavorite(city);
  Future<void> removeCity(String name) => db.removeFavorite(name);
  Future<List<FavoriteCity>> getAll() => db.getFavorites();
}