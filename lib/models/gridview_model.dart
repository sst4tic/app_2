import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yiwumart/models/feedback_model.dart';
import 'package:yiwumart/models/image_list_model.dart';
import '../catalog_screens/product_screen.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/styles.dart';
import 'bag_models/bag_button_model.dart';

class BuildGridWidget extends StatefulWidget {
  final List<Product> products;

  const BuildGridWidget({Key? key, required this.products}) : super(key: key);

  @override
  BuildGridWidgetState createState() => BuildGridWidgetState();
}

class BuildGridWidgetState extends State<BuildGridWidget>
    with TickerProviderStateMixin {
  final Set<int> _isFavLoading = {};

  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.products.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      );
      final animation = Tween(begin: 1.0, end: 1.25).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void didUpdateWidget(BuildGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (int i = 0; i < widget.products.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      );
      final animation = Tween(begin: 1.0, end: 1.25).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                            productItem.is_favorite = product.is_favorite;
                            product.is_favorite
                                ? _isFavLoading.add(index)
                                : _isFavLoading.remove(index);
                          })
                        }
                    });
          },
          child: Container(
            padding: REdgeInsets.only(left: 7, right: 7, top: 6, bottom: 6),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: [
                    Flexible(
                      child: Text(
                        '${productItem.name}\n'.toUpperCase(),
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
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    StarRating(
                      size: 12,
                      rating: double.parse(productItem.rating.toString()),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '(${productItem.reviewCount} отзыва)',
                        style: const TextStyle(
                          color: Color(0xFF7C7C7C),
                          fontSize: 10,
                          fontFamily: 'Noto Sans',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${productItem.price} ₸',
                      style: const TextStyle(
                        color: Color(0xFF181C32),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                        child: BagButton(index: index, id: productItem.id)),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: () {
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
                        _controllers[index].forward();
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _controllers[index].reverse();
                        });
                      },
                      child: Container(
                        padding: REdgeInsets.all(8.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isFavLoading.contains(index) ||
                                  productItem.is_favorite!
                              ? Colors.red
                              : Colors.transparent,
                          border: Border.fromBorderSide(BorderSide(
                              color: _isFavLoading.contains(index) ||
                                      productItem.is_favorite!
                                  ? Colors.transparent
                                  : Colors.grey[300]!,
                              width: 1.5)),
                        ),
                        child: ScaleTransition(
                          scale: _animations[index],
                          child: SvgPicture.asset(
                            _isFavLoading.contains(index) ||
                                    productItem.is_favorite!
                                ? 'assets/icons/favorite_fill.svg'
                                : 'assets/icons/favorite.svg',
                            color: _isFavLoading.contains(index) ||
                                    productItem.is_favorite!
                                ? Colors.white
                                : const Color.fromRGBO(35, 35, 35, 1),
                            fit: BoxFit.cover,
                            height: 13,
                            width: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
