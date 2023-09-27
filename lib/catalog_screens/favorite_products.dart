import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:yiwumart/models/feedback_model.dart';
import 'package:yiwumart/util/styles.dart';
import '../bloc/favorites_bloc/favorites_bloc.dart';
import '../models/bag_models/bag_button_model.dart';
import '../models/gridview_model.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';

class FavoriteProducts extends StatefulWidget {
  const FavoriteProducts({Key? key}) : super(key: key);

  @override
  State<FavoriteProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  final _favoritesBloc = FavoritesBloc();

  @override
  void initState() {
    super.initState();
    _favoritesBloc.add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Избранное',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Padding(
            padding: REdgeInsets.only(
              left: 11,
              right: 11,
              bottom: 10,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => FavoritesBloc(),
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          bloc: _favoritesBloc,
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return buildGridShimmer();
            } else if (state is FavoritesLoaded) {
              final product = state.products;
              if (product.isEmpty) {
                return const Center(
                  child: Text(
                    'Ничего не найдено',
                    style: TextStyle(fontSize: 25),
                  ),
                );
              }
              return buildFavorites(product);
            } else if (state is FavoritesLoadingFailure) {
              return Center(
                child: Text(state.exception.toString()),
              );
            } else {
              return const Text("No widget to build");
            }
          },
        ),
      ),
    );
  }

  Widget buildFavorites(List<Product> product) {
    const String noPhotoImage =
        'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg';
    return ListView.builder(
        padding: REdgeInsets.all(12),
        itemCount: product.length,
        itemBuilder: (context, index) {
          final productItem = product[index];
          final media = productItem.media?.map((e) => e.toJson()).toList();
          final allPhotos = media
              ?.map((e) =>
                  'https://cdn.yiwumart.org/${e['links']['local']['thumbnails']['350']}')
              .toList();
          if (allPhotos != null && index < allPhotos.length) {
            final photoAtIndex = allPhotos[index];
            print(photoAtIndex);
          } else {
            print(noPhotoImage);
          }
          // final photo = product[index].media?.map((e) => 'https://cdn.yiwumart.org/${e.links?.local.thumbnails.s350}');
          // final mappedPhoto = photo ?? noPhotoImage;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductScreen(product: productItem)));
            },
            child: Container(
                margin: REdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 95,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  allPhotos != null && index < allPhotos.length
                                      ? allPhotos[index]
                                      : noPhotoImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: REdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        productItem.name.toUpperCase(),
                                        style: const TextStyle(
                                          color: Color(0xFF181C32),
                                          fontSize: 13,
                                          fontFamily: 'Noto Sans',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      'assets/icons/favorite_fill.svg',
                                      color:
                                          const Color.fromRGBO(252, 47, 61, 1),
                                      fit: BoxFit.cover,
                                      height: 15,
                                      width: 15,
                                    ),
                                    // ScaleTransition(
                                    //   scale: _animations[index],
                                    //   child: SvgPicture.asset(
                                    //     _isFavLoading.contains(index) ||
                                    //         productItem.is_favorite!
                                    //         ? 'assets/icons/favorite_fill.svg'
                                    //         : 'assets/icons/favorite.svg',
                                    //     color: _isFavLoading.contains(index) ||
                                    //         productItem.is_favorite!
                                    //         ? Colors.white
                                    //         : const Color.fromRGBO(35, 35, 35, 1),
                                    //     fit: BoxFit.cover,
                                    //     height: 13,
                                    //     width: 13,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    StarRating(
                                      rating: double.parse(
                                          productItem.rating.toString()),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(${productItem.reviewCount} отзыва)',
                                      style: const TextStyle(
                                        color: Color(0xFF7C7C7C),
                                        fontSize: 8,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${productItem.price} ₸',
                                      style: const TextStyle(
                                        color: Color(0xFF181C32),
                                        fontSize: 15,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    BagButton(index: index, id: productItem.id),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
  }
}
