import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yiwumart/util/product.dart';
import '../../models/posts_model.dart';
import '../../util/function_class.dart';
import '../../util/popular_catalog.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<LoadHomePage>((event, emit) async {
      try {
        emit(HomePageLoading());
        final popularCategories = await Func.getPopularCategories();
        final productsOfDay = await Func.getProducts();
        final posts = await Func.getPosts();
        emit(HomePageLoaded(
          popularCategories: popularCategories,
          productsOfDay: productsOfDay,
          posts: posts,
        ));
      } catch (e) {
        emit(HomePageError(e: e));
      }
    });
  }
}
