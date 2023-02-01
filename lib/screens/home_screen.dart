
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/catalog_item.dart';
import 'package:yiwumart/models/search_model.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/notification_screen.dart';
import 'package:yiwumart/util/function_class.dart';
import 'package:yiwumart/util/popular_catalog.dart';
import '../catalog_screens/product_screen.dart';
import '../util/constants.dart';
import '../util/product.dart';
import '../util/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = false;
  var _isLoaded = false;
  int selectedIndex = -1;
  bool favClick = false;
  final Set<int> _isFavLoading = {};
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
            title:SvgPicture.asset(
              'assets/img/logo.svg',
              height: 15.h,
            ),
            actions: [
              if (Constants.USER_TOKEN != '')
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  },
                  icon: const Icon(
                    CupertinoIcons.bell_fill,
                  ),
                ),
            ],
            bottom: AppBar(
              titleSpacing: 10,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child:
                Container(
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
            )
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: REdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text('Популярные категории',
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
                                  return buildCatalog(data);
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
                        const Text('Товары дня', style: TextStyles.headerStyle),
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
                                    return buildProduct(product!);
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
                                              productFuture = Func.getProducts();
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

  Widget buildCatalog(List<PopularCategories> categories) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final categoryItem = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CatalogItems(
                            id: categoryItem.id,
                            name: categoryItem.name,
                          )));
            },
            child: Container(
              margin: index == categories.length - 1
                  ? const EdgeInsets.only(right: 0)
                  : const EdgeInsets.only(right: 7),
              width: 150,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0,
                child: Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(categoryItem.image),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CatalogItems(
                                            id: categoryItem.id,
                                            name: categoryItem.name,
                                          )));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(43, 46, 74, 0.8)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                categoryItem.name,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          );
        },
      );

  Widget buildProduct(List<Product> product) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: GridDelegateClass.gridDelegate,
        itemCount: product.length,
        itemBuilder: (context, index) {
          final productItem = product[index];
          final media = product[index].media?.map((e) => e.toJson()).toList();
          final photo = media?[0]['links']['local']['thumbnails']['350'];
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
                color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8)),
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
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${productItem.price} ₸',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // SizedBox(height: 4.h),
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
                              fontSize: 12.5.sp, fontWeight: FontWeight.w500),
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
        },
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
