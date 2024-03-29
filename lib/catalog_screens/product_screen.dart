import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/util/custom_page_route.dart';
import 'package:yiwumart/util/product_item.dart';
import '../models/build_product.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/styles.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  late bool isFavorite;
  var _isLoading = false;
  var _isLoaded = false;
  int selectedIndex = -1;
  late Future<ProductItem> productFuture;
  late final AnimationController _controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    productFuture = Func().getProduct(id: widget.id);
    productFuture.then((productItem) {
      setState(() {
        isFavorite = productItem.is_favorite;
      });
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productFuture,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: buildCartShimmer(context),
          );
        } else if (snapshot.hasData) {
          final product = snapshot.data!;
          // print all product data
          return CustomWillPopScope(
                action: () {
                  Navigator.pop(context, product);
                  setState(() {
                    product.is_favorite = isFavorite;
                  });
                },
                onWillPop: true,
            child: Scaffold(
                appBar:
        AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context, product);
                    setState(() {
                      product.is_favorite = isFavorite;
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                actions: [
                  Constants.USER_TOKEN.isNotEmpty
                      ? IconButton(
                          padding: REdgeInsets.only(right: 4),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: ScaleTransition(
                            scale: animation,
                            child: SvgPicture.asset(
                              isFavorite
                                  ? 'assets/icons/favorite_fill.svg'
                                  : 'assets/icons/favorite.svg',
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            if (isFavorite) {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            }
                            Func().addToFavItem(
                              productId: widget.id,
                              onAdded: () {
                                setState(() {
                                  isFavorite = true;
                                  product.is_favorite = isFavorite;
                                });
                              },
                              onRemoved: () {
                                setState(() {
                                  isFavorite = false;
                                  product.is_favorite = isFavorite;
                                });
                              },
                            );
                            _controller.forward();
                            Future.delayed(const Duration(milliseconds: 200), () {
                              _controller.reverse();
                            });
                          },
                        )
                      : Container(),
                  IconButton(
                    onPressed: () async {
                      Share.share(product.link);
                    },
                    icon: const Icon(Icons.ios_share),
                  ),
                ],
              ),
                body: BuildProduct(productItem: product)),
          );
        } else {
          return const Text("No widget to build");
        }
      },
    );
  }

  Widget buildButton(id) => ElevatedButton.icon(
      icon: _isLoading
          ? Container(
              width: 17,
              height: 17,
              padding: const EdgeInsets.all(1.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Icon(_isLoaded ? Icons.done : Icons.shopping_cart, size: 17),
      onPressed: () {
        setState(() {
          _isLoading = true;
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
        )
            .then((value) {
          Future.delayed(const Duration(seconds: 2))
              .then((value) => setState(() {
                    _isLoading = false;
                    _isLoaded = false;
                  }));
        });
      },
      style: BagButtonItemStyle(context: context, isLoaded: _isLoaded),
      label: Text(
        _isLoaded ? 'Добавлено' : 'В корзину',
        style: const TextStyle(
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ));
}
