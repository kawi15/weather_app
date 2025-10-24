part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavoritesEvent extends FavoritesEvent {}
class AddFavoriteEvent extends FavoritesEvent {
  final String cityName;
  AddFavoriteEvent(this.cityName);
}
class RemoveFavoriteEvent extends FavoritesEvent {
  final String cityName;
  RemoveFavoriteEvent(this.cityName);
}