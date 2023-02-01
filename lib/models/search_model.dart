import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/catalog_item.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/search_result.dart';
import '../catalog_screens/product_screen.dart';
import '../util/function_class.dart';
import '../util/search.dart';

class SearchModel extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
      appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
  @override
  String get searchFieldLabel => 'Поиск';
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != '' ? IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ) : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
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
    return FutureBuilder<Search>(
        future: Func.searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: 300,
                      child: buildSearchShimmer()),
                  buildCatalogShimmer()
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final search = snapshot.data!;
            if(search.products.total == 0 && search.categories.total == 0){
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
    if (query.isEmpty) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      );
    }
    return FutureBuilder<Search>(
        future: Func.searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 300,
                        child: buildSearchShimmer()),
                    buildCatalogShimmer()
                  ],
              ),
            );
          } else if (snapshot.hasData) {
            final search = snapshot.data!;
            if(search.products.total == 0 && search.categories.total == 0){
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
              "Произошла ошибка",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ));
          }
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
                        name: searchItem.name,
                        link: searchItem.link,
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
                    child:
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photo != null
                              ? 'https://cdn.yiwumart.org/$photo'
                              : 'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                          errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                  'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                                height: MediaQuery.of(context).size.height * 0.195,
                              ),
                            );
                          },
                          height: MediaQuery.of(context).size.height * 0.195,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // SizedBox(height: 5.h),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CatalogItems(id: searchItem.id, name: searchItem.name)));
                },
                title: Text(
                  searchItem.name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ),
          ),
        );
      });

  Widget buildFuture(search, context) => SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: REdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Найдено ${search.products.total} товаров',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 10
                ),
                SizedBox(
                    height: 225.h, child: buildProduct(search.products.items)),
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
                        minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 35.h)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                      child: const Text(
                        'Показать найденные товары',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                ),
                SizedBox(height: 10.h),
                search.categories.items.isEmpty
                    ? Container() : const Text(
                  'Категории',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,),
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