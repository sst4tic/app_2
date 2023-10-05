import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiwumart/models/star_rating.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/create_feedback_page.dart';
import 'package:yiwumart/screens/feedback_page.dart';
import '../catalog_screens/product_screen.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/product_item.dart';
import 'bag_models/bag_button_model.dart';
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
  double test = 3.5;

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
              Row(
                children: [
                  StarRating(
                    rating: double.parse(product.rating.toString()),
                    onRatingChanged: (rating) {
                      setState(() {
                        test = rating;
                      });
                    },
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    '(${product.reviewCount} отзывов)',
                    style: const TextStyle(
                      color: Color(0xFF7C7C7C),
                      fontSize: 13,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${product.price} ₸',
                style: const TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 22,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w700,
                ),
              )
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Артикул товара',
                    style: TextStyle(
                      color: Color(0xFF5E6278),
                      fontSize: 14,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    product.sku,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text(
                    'Наличие',
                    style: TextStyle(
                      color: Color(0xFF5E6278),
                      fontSize: 14,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 13,
                    height: 13,
                    decoration: ShapeDecoration(
                      color: product.availability == 'Нет в наличии'
                          ? Colors.red
                          : Colors.green,
                      shape: const OvalBorder(),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  SvgPicture.asset(
                    'assets/icons/truck_icon.svg',
                    height: 18.h,
                    width: 18.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    product.availability,
                    style: const TextStyle(
                      color: Color(0xFF5E6278),
                      fontSize: 14,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          padding: REdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Отзывы",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                 // if(product.reviewCount > 1)
                   GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedbackPage(reviews: product.reviews,))),
                    child: const Text(
                      'Все',
                      style: TextStyle(
                        color: Color(0xFF2C2D4F),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
              if (product.reviewCount != 0) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StarRating(
                      rating: double.parse(product.rating.toString()),
                      size: 25,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      '(${product.reviewCount} отзывов)',
                      style: const TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 13,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          product.reviews![0].user!.fullName!,
                          style: const TextStyle(
                            color: Color(0xFF4A4E64),
                            fontSize: 16,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StarRating(
                          rating: double.parse(
                              product.reviews![0].rating!.toString()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.reviews![0].date!,
                      style: const TextStyle(
                        color: Color(0xFF7C7C7C),
                        fontSize: 13,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.reviews![0].body!,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Отзыв был полезен? ',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.thumb_up_alt_outlined,
                            size: 16, color: Color(0xFF7C7C7C)),
                        SizedBox(width: 2.w),
                        const Text(
                          '1',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        const Icon(Icons.thumb_down_alt_outlined,
                            size: 16, color: Color(0xFF7C7C7C)),
                        SizedBox(width: 2.w),
                        const Text(
                          '0',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 13,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                        )
                      ],
                    )
                  ],
                ),
              ] else ...[
                const Divider(),
                const SizedBox(height: 8.0),
                const Center(
                  child: Text(
                    'На этот товар пока нет отзывов. \nЗакажите и будьте первым!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF7C7C7C),
                      fontSize: 14,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),

        product.reviewCheck
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateFeedbackPage(
                                prodId: product.id.toString(),
                              ))),
                  child: const Text('Оставить отзыв'),
                ),
              )
            : const SizedBox.shrink(),
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
                height: 295.h,
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
                              print(snapshot.error);
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
                final fullImageUrl = media!
                    .map((e) =>
                        'https://cdn.yiwumart.org/${e['links']['local']['full']}')
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
                          child: ImageList(
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
                              Expanded(
                                child: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  icon: SvgPicture.asset(
                                    _isFavLoading.contains(index) ||
                                            productItem.is_favorite!
                                        ? 'assets/icons/favorite_fill.svg'
                                        : 'assets/icons/favorite.svg',
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
                                        setState(
                                            () => _isFavLoading.add(index));
                                      },
                                      onRemoved: () {
                                        setState(() {
                                          _isFavLoading.remove(index);
                                        });
                                      },
                                    );
                                  },
                                ),
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
