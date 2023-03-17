import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../catalog_screens/product_screen.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/styles.dart';
import 'bag_button_model.dart';

// build products of day for auth user
class BuildGridWidget extends StatefulWidget {
  final List<Product> products;

  const BuildGridWidget({Key? key, required this.products}) : super(key: key);

  @override
  BuildGridWidgetState createState() => BuildGridWidgetState();
}

class BuildGridWidgetState extends State<BuildGridWidget> {
  final Set<int> _isFavLoading = {};

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: GridDelegateClass.gridDelegate,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final productItem = widget.products[index];
        final media =
            widget.products[index].media?.map((e) => e.toJson()).toList();
        final photo = media!.isEmpty
            ? 'storage/warehouse/products/images/no-image-ru.jpg'
            : media[0]['links']['local']['thumbnails']['350'];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        ProductScreen(product: productItem)))
                .then((product) =>
            {
              if (product != null)
                {
                  setState(() {
                    productItem.is_favorite = product.is_favorite;
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
                InkWell(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        media.isNotEmpty
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
                      '${productItem.price} ₸',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                            fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
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
                            productItem.is_favorite = !productItem.is_favorite!;
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// build products of day for non auth user
Widget buildProductsOfDay(List<Product> product) => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: GridDelegateClass.gridDelegate,
      itemCount: product.length,
      itemBuilder: (context, index) {
        final productItem = product[index];
        final media =
            product[index].media?.map((e) => e.toJson()).toList() ?? [];
        final photo = media.isEmpty
            ? 'storage/warehouse/products/images/no-image-ru.jpg'
            : media[0]['links']['local']['thumbnails']['350'];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductScreen(
                          product: productItem,
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
                      '${productItem.price} ₸',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                            fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                BagButton(index: index, id: productItem.id),
              ],
            ),
          ),
        );
      },
    );
