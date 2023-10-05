part of 'home_page_bloc.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<PopularCategories> popularCategories;
  final List<Product> productsOfDay;
  final List<PostsModel> posts;
  HomePageLoaded({
    required this.popularCategories,
    required this.productsOfDay,
    required this.posts,
      });
}

class HomePageError extends HomePageState {
  final Object? e;

  HomePageError({this.e});
}