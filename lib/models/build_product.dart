import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import '../catalog_screens/product_screen.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/product_item.dart';
import 'bag_button_model.dart';
import 'image_list_model.dart';

class BuildProduct extends StatefulWidget {
  const BuildProduct({Key? key, required this.productItem}) : super(key: key);
  final ProductItem productItem;

  @override
  State<BuildProduct> createState() => _BuildProductState();
}

class _BuildProductState extends State<BuildProduct> {
  late ProductItem product;
  final Set<int> _isFavLoading = {};
  late Future<List<Product>> similarFuture;

  @override
  void initState() {
    super.initState();
    product = widget.productItem;
    similarFuture = Func.getSimilarProducts(
        catId: product.categoryId!, productId: product.id);
  }

  @override
  Widget build(BuildContext context) {
    final media = product.media!.map((e) => e.toJson()).toList();
    var mediaQuery = MediaQuery.of(context).size;
    return ListView(
      padding: REdgeInsets.only(bottom: 80),
      shrinkWrap: true,
      children: [
        SizedBox(
            height: mediaQuery.height * 0.4,
            child: ImageList(
              imageUrls: media.isNotEmpty
                  ? media
                      .map((e) =>
                          'https://cdn.yiwumart.org/${e['links']['local']['thumbnails']['750']}')
                      .toList()
                  : [
                      'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg'
                    ],
              fullImageUrl: media.isNotEmpty
                  ? media
                      .map((e) =>
                          'https://cdn.yiwumart.org/${e['links']['local']['full']}')
                      .toList()
                  : [
                      'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg'
                    ],
            )),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                product.categoryName!,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${product.price} ₸',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "О товаре",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Артикул товара",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      product.sku,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Наличие",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      product.availability,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: product.availability != 'Нет в наличии'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        product.description != null
            ? Container(
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Описание",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    product.description != null
                        ? Html(
                            data: product.description,
                            shrinkWrap: true,
                            style: {
                                'body': Style(
                                  fontSize: FontSize(14.0),
                                  color: Theme.of(context).primaryColorLight,
                                  padding: EdgeInsets.zero,
                                  margin: Margins.zero,
                                ),
                              })
                        : const Text(
                            'Описание отсутствует',
                            style: TextStyle(fontSize: 14.0),
                          ),
                  ],
                ))
            : const SizedBox.shrink(),
        const SizedBox(height: 8.0),
        // create container for similar products
        product.categoryId != null
            ? Container(
                padding: const EdgeInsets.all(10),
                height: 280.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Похожие товары",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: FutureBuilder<List<Product>>(
                          future: similarFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return buildSimilar(snapshot.data!);
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Произошла ошибка'),
                              );
                            }
                            return buildGridShimmer();
                          }),
                    ),
                  ],
                ))
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget buildSimilar(List<Product> product) => CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 200,
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: product.length,
              (BuildContext context, int index) {
                final productItem = product[index];
                final media =
                productItem.media?.map((e) => e.toJson()).toList();
                final allPhotos = media!
                    .map((e) =>
                'https://cdn.yiwumart.org/${e['links']['local']['thumbnails']['750']}')
                    .toList();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    ProductScreen(product: productItem)))
                        .then((product) => {
                              if (product != null)
                                {
                                  setState(() {
                                    productItem.is_favorite =
                                        product.is_favorite;
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.195,
                          child: ImageView(
                            imageUrls: media.isNotEmpty
                                ? allPhotos
                                : [
                              'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg'
                            ],
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
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (Constants.USER_TOKEN != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BagButton(index: index, id: productItem.id),
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
                        else
                          BagButton(index: index, id: productItem.id),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
