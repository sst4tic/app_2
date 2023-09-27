import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/util/product.dart';

import '../../util/function_class.dart';
import '../../util/popular_catalog.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<LoadHomePage>((event, emit) async {
      print('LOOOOOOADDDD');
      try {
        emit(HomePageLoading());
        final popularCategories = await Func.getPopularCategories();
        final productsOfDay = await Func.getProducts();
        emit(HomePageLoaded(
          popularCategories: popularCategories,
          productsOfDay: productsOfDay,
        ));
        print('DONE !');
      } catch (e) {
        emit(HomePageError(e: e));
      }
    });
  }
}
