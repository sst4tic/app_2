import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/util/custom_page_route.dart';
import 'package:yiwumart/util/product_item.dart';
import '../models/build_product.dart';
import '../util/constants.dart';
import '../util/function_class.dart';
import '../util/product.dart';
import '../util/styles.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late int id;
  String? shareLink;
  late Future<bool> favFuture;
  late bool isFavorite;
  bool isPageLoading = true;
  var _isLoading = false;
  var _isLoaded = false;
  int selectedIndex = -1;
  late Future<ProductItem> productFuture;
  late Product product;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    id = product.id;
    shareLink = product.link;
    productFuture = Func().getProduct(id: id);
    productFuture.then((productItem) {
      setState(() {
        isFavorite = productItem.is_favorite;
        isPageLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isPageLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: buildCartShimmer(context),
      );
    } else {
      return
        CustomWillPopScope(
        action: () {
          Navigator.pop(context, product);
          setState(() {
            product.is_favorite = isFavorite;
          });
        },
          onWillPop: true,
        child:
        Scaffold(
          appBar: AppBar(
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
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        }
                        Func().addToFavItem(
                          productId: id,
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
                      },
                    )
                  : Container(),
              IconButton(
                onPressed: () async {
                  Share.share(shareLink!);
                },
                icon: const Icon(Icons.ios_share),
              ),
            ],
          ),
          body: Stack(
            children: [
              FutureBuilder(
                  future: productFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return buildCartShimmer(context);
                    } else if (snapshot.hasData) {
                      final product = snapshot.data!;
                      return buildProduct(product: product, context: context);
                    } else {
                      return const Text("No widget to build");
                    }
                  }),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: WidgetsBinding.instance.window.platformBrightness == Brightness.light ?
                      Theme.of(context).colorScheme.secondary : Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      WidgetsBinding.instance.window.platformBrightness == Brightness.light ? BoxShadow(
                        color: Colors.grey[700]!.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ) : const BoxShadow(),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.price} ₸', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                      buildButton(product.id),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
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
          : Icon(_isLoaded ? Icons.done : Icons.shopping_basket, size: 17),
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

