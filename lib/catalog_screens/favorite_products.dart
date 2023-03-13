import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:yiwumart/models/bag_button_model.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/styles.dart';

class FavoriteProducts extends StatefulWidget {
  const FavoriteProducts({Key? key}) : super(key: key);

  @override
  State<FavoriteProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  int selectedIndex = -1;
  int page = 1;
  bool hasMore = true;
  final Set<int> _isFavLoading = {};


  late Future<List<Product>> favoritesFuture = getFavorites();

  static Future<List<Product>> getFavorites() async {
    var url =
        '${Constants.API_URL_DOMAIN}action=favorite_list';
    final response = await http.get(Uri.parse(url), headers: {Constants.header: Constants.bearer});
    final body = jsonDecode(response.body);
    return List.from(body['data']?.map!((e) => Product.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Избранные товары',
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: FutureBuilder<List<Product>>(
            future: favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildGridShimmer();
              } else if (snapshot.hasData) {
                final product = snapshot.data;
                if (product!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Ничего не найдено',
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
                return SafeArea(child: buildFavorites(product));
              } else {
                return const Text("No widget to build");
              }
            }),
      ),
    );
  }

  Widget buildFavorites(List<Product> product) => CustomScrollView(
        slivers: [
          Func.sizedGrid,
          SliverGrid(
            gridDelegate: GridDelegateClass.gridDelegate,
            delegate: SliverChildBuilderDelegate(childCount: product.length,
                (BuildContext context, int index) {
              final media =
                  product[index].media?.map((e) => e.toJson()).toList();
              final photo = media!.isEmpty ? 'storage/warehouse/products/images/no-image-ru.jpg' : media[0]['links']['local']['thumbnails']['350'];
              final productItem = product[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              ProductScreen(product: productItem)))
                      .then((product) => {
                    if (product != null) {
                      setState(() {
                        productItem.is_favorite = product.is_favorite;
                        product.is_favorite
                            ? _isFavLoading.add(index)
                            : _isFavLoading.remove(index);
                      })
                    }
                  });
                },
                child: Container(
                  padding: REdgeInsets.only(left: 7, right: 7, top: 6),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              media.isNotEmpty
                                  ? 'https://cdn.yiwumart.org/$photo'
                                  : 'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                                    height: MediaQuery.of(context).size.height *
                                        0.195,
                                  ),
                                );
                              },
                              height:
                                  MediaQuery.of(context).size.height * 0.195,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${productItem.price} ₸',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${productItem.name}\n',
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BagButton(index: index, id: productItem.id),
                            IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(
                                _isFavLoading.contains(index) ||
                                        productItem.is_favorite!? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (productItem.is_favorite!) {
                                  setState(() {
                                    productItem.is_favorite =
                                        !productItem.is_favorite!;
                                  });
                                }
                                Func().addToFav(
                                  productId: productItem.id,
                                  index: index,
                                  onAdded: () {
                                    setState(() => _isFavLoading.add(index));
                                  },
                                  onRemoved: () {
                                    setState(() {
                                      _isFavLoading.remove(index);
                                    });
                                  },
                                );
                              },
                            )
                          ],
                        )
                    ],
                  ),
                ),
              );
            }),
          ),
          Func.sizedGrid,
        ],
      );
}
