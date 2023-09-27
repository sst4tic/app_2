part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {
}

class FavoritesLoaded extends FavoritesState {
  final List<Product> products;

  FavoritesLoaded({required this.products});
}

class FavoritesLoadingFailure extends FavoritesState {
  final Object? exception;

  FavoritesLoadingFailure({this.exception});
}