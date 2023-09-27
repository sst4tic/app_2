import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../util/constants.dart';
import '../../util/product.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    Future<List<Product>> getFavorites() async {
      var url = '${Constants.API_URL_DOMAIN_V3}products/favorite_list';
      final response =
          await http.get(Uri.parse(url), headers: Constants.headers());
      final body = jsonDecode(response.body);
      return List.from(body['data']?.map!((e) => Product.fromJson(e)).toList());
    }

    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final products = await getFavorites();
        emit(FavoritesLoaded(products: products));
        event.completer?.complete();
      } catch (e) {
        emit(FavoritesLoadingFailure(exception: e));
      }
    });
  }
}
