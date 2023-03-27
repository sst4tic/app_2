import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  int selectedIndex = -1;
  int page = 1;
  bool hasMore = true;


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
          SliverToBoxAdapter(
            child: BuildGridWidget(products: product,),
          ),
          Func.sizedGrid,
        ],
      );
}
