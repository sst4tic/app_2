part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}


class LoadFavorites extends FavoritesEvent {
  final Completer? completer;

  LoadFavorites({this.completer});
}


