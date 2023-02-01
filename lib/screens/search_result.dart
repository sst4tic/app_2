import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../catalog_screens/product_screen.dart';
import '../models/shimmer_model.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/styles.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.query}) : super(key: key);
  final String query;
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var _isLoading = false;
  var _isLoaded = false;
  int selectedIndex = -1;
  List<Product> list = [];
  ScrollController sController = ScrollController();
  int page = 1;
  bool hasMore = true;
  final Set<int> _isFavLoading = {};

  late Future<List<Product>> productFuture = getProducts();

  Future<List<Product>> getProducts() async {
    var url =
        '${Constants.API_URL_DOMAIN}action=search_view&q=${widget.query}&page=$page';
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
      SliverGrid(
        gridDelegate: GridDelegateClass.gridDelegate,
        delegate: SliverChildBuilderDelegate(childCount: product.length,
                (BuildContext context, int index) {
              final media =
              product[index].media?.map((e) => e.toJson()).toList();
              final photo = media?[0]['links']['local']['thumbnails']['350'];
              final productItem = product[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            name: productItem.name,
                            link: productItem.link,
                          )));
                },
                child: Container(
                  padding: REdgeInsets.only(left: 7, right: 7, top: 6),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              media != null
                                  ? 'https://cdn.yiwumart.org/$photo'
                                  : 'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    height: MediaQuery.of(context).size.height * 0.195,
                                    'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
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
                      if (Constants.USER_TOKEN != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildButton(index, productItem.id),
                            IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(
                                _isFavLoading.contains(index) ||
                                    productItem.is_favorite!
                                    ? Icons.favorite
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
                                Func().addToFav(productId: productItem.id, index: index,
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
                      else
                        buildButton(index, productItem.id),
                    ],
                  ),
                ),
              );
            }),
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
  Widget buildButton(index, id) => ElevatedButton.icon(
      icon: _isLoading && selectedIndex == index
          ? Container(
        width: 16,
        height: 16,
        padding: const EdgeInsets.all(1.0),
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      )
          : Icon(
          _isLoaded && selectedIndex == index
              ? Icons.done
              : Icons.shopping_basket,
          size: 16),
      onPressed: () {
        setState(() {
          _isLoading = true;
          selectedIndex = index;
        });
        Func()
            .addToBag(
          productId: id,
          context: context,
          onSuccess: () {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          },
          onFailure: () {
            setState(() {
              _isLoading = false;
              _isLoaded = false;
            });
          },
        ).then((value) {
          Future.delayed(const Duration(seconds: 2))
              .then((value) => setState(() {
            _isLoading = false;
            _isLoaded = false;
          }));
        });
      },
      style: BagButtonStyle(context: context, isLoaded: _isLoaded, selectedIndex: selectedIndex, index: index),
      label: Text(
        _isLoaded && selectedIndex == index ? 'Добавлен' : 'В корзину',
        style: const TextStyle(fontSize: 11),
        textAlign: TextAlign.center,
      ));
}


