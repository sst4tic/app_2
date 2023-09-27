import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/gridview_model.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.query}) : super(key: key);
  final String query;
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  int selectedIndex = -1;
  List<Product> list = [];
  ScrollController sController = ScrollController();
  int page = 1;
  bool hasMore = true;

  late Future<List<Product>> productFuture = getProducts();

  Future<List<Product>> getProducts() async {
    var url =
        '${Constants.API_URL_DOMAIN_V3}search/view?q=${widget.query}&page=$page';
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        if (List.from(body['data'].map((e) => Product.fromJson(e)).toList())
            .isNotEmpty) {
          page++;
        }
        if (List.from(body['data'].map((e) => Product.fromJson(e)).toList())
            .isEmpty) {
          hasMore = false;
        }
        list.addAll(
            List.from(body['data'].map((e) => Product.fromJson(e)).toList()));
      });
    }
    return list;
  }
  @override
  void initState() {
    super.initState();
    sController.addListener(() {
      if (sController.position.maxScrollExtent == sController.offset) {
        if (hasMore) {
          getProducts();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты поиска',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder<List<Product>>(
              future: productFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildGridShimmer();
                } else if (snapshot.hasData) {
                  final catalog = snapshot.data;
                  if (catalog!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Нет товаров',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return buildCatalog(catalog);
                } else {
                  return const Text("No widget to build");
                }
              }),
        ),
    );
  }
  Widget buildCatalog(List<Product> product) => CustomScrollView(
    controller: sController,
    slivers: [
      Func.sizedGrid,
      SliverToBoxAdapter(
        child: BuildGridWidget(products: product,),
      ),
      Func.sizedGrid,
      Func.sizedGrid,
      SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.04),
                child: Center(
                    child: product.length >= 6 && hasMore
                        ? const CircularProgressIndicator()
                        : const Text('Больше данных нет')));
          },
          childCount: 1,
        ),
      )
    ],
  );
}


