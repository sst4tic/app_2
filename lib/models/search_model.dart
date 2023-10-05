import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/catalog_screens/catalog_item.dart';
import 'package:yiwumart/models/star_rating.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/search_result.dart';
import 'package:yiwumart/util/product.dart';
import '../catalog_screens/product_screen.dart';
import '../util/function_class.dart';
import '../util/search.dart';

class SearchModel extends SearchDelegate {
  final Set<String> _history = {};
  List<String> buttons = [];

  SearchModel() {
    _loadHistory();
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history');
    if (history != null) {
      _history.addAll(history);
    }
    buttons = await Func().getPopularSearch();
  }

  _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', _history.toSet().toList());
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
                elevation: 0.0,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
        );
  }

  @override
  String get searchFieldLabel => 'Поиск';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != ''
          ? IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        _saveHistory();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      );
    }
    if (query.trim().isNotEmpty) {
      _history.add(query);
      _saveHistory();
    }
    SharedPreferences.getInstance().then((prefs) {
      final jsonHistory = json.encode(_history.toList());
      prefs.setString("history", jsonHistory);
    });
    return FutureBuilder<Search>(
        future: Func.searchProducts(search: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildSearchShimmer();
          } else if (snapshot.hasData) {
            final search = snapshot.data!;
            if (search.products.total == 0 && search.categories.total == 0) {
              return Center(
                child: Text(
                  'Ничего не найдено',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return buildFuture(search, context);
          } else {
            return const Center(
                child: Text(
              "Ничего не найдено",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ));
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8.h,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
              'Популярные запросы',
              style: TextStyle(
                color: Color(0xFF7B7B7B),
                fontSize: 14,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Container(
            padding: REdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            width: double.infinity,
            child: GroupButton(
              options: const GroupButtonOptions(
                mainGroupAlignment: MainGroupAlignment.start,
              ),
              onSelected: (name, index, isSelected) {
                query = name;
                showResults(context);
              },
              buttons: buttons,
              buttonBuilder: (isSelected, index, context) => Container(
                padding: REdgeInsets.symmetric(vertical: 4, horizontal: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  index,
                  style: const TextStyle(
                    color: Color(0xFF494949),
                    fontSize: 13,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          _history.isNotEmpty
              ? Container(
                  padding: REdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Text(
                        'История поиска',
                        style: TextStyle(
                          color: Color(0xFF7B7B7B),
                          fontSize: 14,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            setState(() {
                              _history.clear();
                              _saveHistory();
                            });
                          },
                          child: const Text(
                            'Очистить',
                            style: TextStyle(
                              color: Color(0xFF0D6EFD),
                              fontSize: 14,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                    ],
                  ),
                )
              : Container(),
          if (_history.isNotEmpty) ...[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              padding: REdgeInsets.all(12),
              child: GroupButton(
                options: const GroupButtonOptions(
                  mainGroupAlignment: MainGroupAlignment.start,
                ),
                onSelected: (name, index, isSelected) {
                  query = name;
                  showResults(context);
                },
                buttons: _history.toList().reversed.toList(),
                buttonBuilder: (isSelected, index, context) => Container(
                  padding: REdgeInsets.symmetric(vertical: 4, horizontal: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        index,
                        style: const TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 13,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _history.remove(index);
                              _saveHistory();
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 12,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: REdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: REdgeInsets.all(2),
                            child: Image.network(
                              'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg',
                              width: 63,
                              height: 45,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Морозильник типа "ларь" CI-1 asdsdasdasdsadsad ad',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF181C32),
                                  fontSize: 12,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '365 000',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(0xFF181C32),
                                  fontSize: 13,
                                  fontFamily: 'Noto Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.close,
                          size: 12,
                        )
                      ],
                    ),
                  );
                })
          ]
        ],
      );
    });
  }

  Widget buildProduct(List search) => GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 43.w / 25.5.h,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h),
        itemCount: search.length > 4 ? 4 : search.length,
        itemBuilder: (context, index) {
          final searchItem = search[index];
          final photo = searchItem.media?[0].links.local.thumbnails.s350;
          return GestureDetector(
            onTap: () {
              Func.searchProducts(search: query, productId: searchItem.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductScreen(
                            product: Product(
                              rating: 0,
                              id: searchItem.id,
                              name: searchItem.name,
                              price: searchItem.price,
                              is_favorite: null,
                              link: searchItem.link,
                              reviewCount: '0 отзывов',
                            ),
                          )));
            },
            child: Container(
              padding: REdgeInsets.only(left: 8, right: 8, top: 6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photo != null
                              ? 'https://cdn.yiwumart.org/$photo'
                              : 'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                                height:
                                    MediaQuery.of(context).size.height * 0.195,
                              ),
                            );
                          },
                          height: MediaQuery.of(context).size.height * 0.195,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '${searchItem.name}\n'.toUpperCase(),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 14,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(children: [
                    StarRating(
                      rating: double.parse(searchItem.rating.toString()),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '(${searchItem.reviewCount})',
                      style: const TextStyle(
                        color: Color(0xFF7B7B7B),
                        fontSize: 12,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]),
                  SizedBox(height: 5.h),
                  Text(
                    '${searchItem.price} ₸',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          );
        },
      );

  Widget buildCategories(List search) => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: search.length,
      itemBuilder: (context, index) {
        final searchItem = search[index];
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatalogItems(
                            id: searchItem.id, name: searchItem.name)));
              },
              title: Text(
                searchItem.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          ),
        );
      });

  Widget buildFuture(search, context) => SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: REdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: search.products.total != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Найдено ${search.products.total} товаров',
                              style: const TextStyle(
                                color: Color(0xFF7B7B7B),
                                fontSize: 14,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 225.h,
                                child: buildProduct(search.products.items)),
                            SizedBox(height: 10.h),
                            Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SearchResult(
                                                  query: query,
                                                )));
                                  },
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        MediaQuery.of(context).size.width,
                                        35.h)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                    ),
                                  ),
                                  child: const Text(
                                    'Показать найденные товары',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Noto Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                          'Товары не найдены',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                ),
                SizedBox(height: 10.h),
                search.categories.items.isEmpty
                    ? Container()
                    : const Text(
                        'Категории',
                        style: TextStyle(
                          color: Color(0xFF494949),
                          fontSize: 16,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                SizedBox(height: 10.h),
                search.categories.items.isEmpty
                    ? Container()
                    : buildCategories(search.categories.items),
              ],
            ),
          ),
        ),
      );
}
