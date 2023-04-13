import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/models/search_model.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/util/function_class.dart';
import 'package:yiwumart/util/popular_catalog.dart';
import '../models/gridview_model.dart';
import '../models/popular_categories_model.dart';
import '../util/product.dart';
import '../util/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = -1;
  late Future<List<PopularCategories>> popularCategoriesFuture;
  late Future<List<Product>> productFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    popularCategoriesFuture = Func.getPopularCategories();
    productFuture = Func.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              elevation: 0,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/img/logo.svg',
                height: 15.h,
              ),
              bottom: AppBar(
                titleSpacing: 10,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onTap: () {
                        showSearch(context: context, delegate: SearchModel());
                      },
                    ),
                  ),
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: REdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                         Text('Популярные категории',
                            style: TextStyles.headerStyle),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 180,
                          child: FutureBuilder<List<PopularCategories>>(
                              future: popularCategoriesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return buildHorizontalShimmer();
                                } else if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  return buildPopularCategories(data);
                                } else {
                                  return Center(
                                      child: Column(
                                    children: [
                                      const Text('Произошла ошибка'),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              popularCategoriesFuture =
                                                  Func.getPopularCategories();
                                            });
                                          },
                                          child:
                                              const Text('Повторить попытку'))
                                    ],
                                  ));
                                }
                              }),
                        ),
                        const SizedBox(height: 15),
                         Text('Товары дня', style: TextStyles.headerStyle),
                        const SizedBox(height: 15),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: SingleChildScrollView(
                            child: FutureBuilder<List<Product>>(
                                future: productFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return buildGridShimmer();
                                  } else if (snapshot.hasData) {
                                    final product = snapshot.data;
                                    return buildProductsOfDay(product!);
                                  } else {
                                    return Center(
                                        child: Column(
                                      children: [
                                        const Text('Произошла ошибка',
                                            style: TextStyle(fontSize: 20)),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              productFuture =
                                                  Func.getProducts();
                                            });
                                          },
                                          child: const Text('Повторить'),
                                        )
                                      ],
                                    ));
                                  }
                                }),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
