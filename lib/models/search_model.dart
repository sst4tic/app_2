import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yiwumart/catalog_screens/catalog_item.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/search_result.dart';
import 'package:yiwumart/util/product.dart';
import '../catalog_screens/product_screen.dart';
import '../util/function_class.dart';
import '../util/search.dart';

class SearchModel extends SearchDelegate {
  final Set<String> _history = {};

  SearchModel() {
    _loadHistory();
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history');
    if (history != null) {
      _history.addAll(history);
    }
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
        future: Func.searchProducts(query),
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
    final buttons = [
      "Телевизор",
      "Вытяжка",
      "Мультиварка",
      "Холодильник",
      "Посудомоечная машина"
    ];
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
                print(name);
                print(index);
                print(isSelected);
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
                      Text(
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
          Expanded(
            child: ListView.separated(
              itemCount: _history.toSet().toList().length,
              itemBuilder: (BuildContext context, int index) {
                var revertHistory = _history.toList().reversed;
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.access_time),
                    contentPadding: REdgeInsets.symmetric(horizontal: 12),
                    title: Text(revertHistory.toList()[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          final value = revertHistory.toList()[index];
                          _history.remove(value);
                          _saveHistory();
                        });
                      },
                    ),
                    onTap: () {
                      query = revertHistory.toSet().toList()[index];
                      showResults(context);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 6,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildProduct(List search) => GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 53.w / 25.5.h,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h),
        itemCount: search.length > 4 ? 4 : search.length,
        itemBuilder: (context, index) {
          final searchItem = search[index];
          final photo = searchItem.media?[0].links.local.thumbnails.s350;
          return GestureDetector(
            onTap: () {
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
                              link: searchItem.link, reviewCount: 0,
                            ),
                          )));
            },
            child: Container(
              padding: REdgeInsets.only(left: 8, right: 8, top: 6),
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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${searchItem.price} ₸',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${searchItem.name}\n',
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                style:
                    const TextStyle(
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
