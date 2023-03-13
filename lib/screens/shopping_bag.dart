import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/purchase_screen.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import 'package:yiwumart/screens/main_screen.dart';
import '../models/build_bag.dart';
import '../util/cart_list.dart';
import '../util/constants.dart';
import '../util/function_class.dart';

class ShoppingBag extends StatefulWidget {
  const ShoppingBag({
    Key? key,
  }) : super(key: key);

  @override
  State<ShoppingBag> createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  late Future<CartItem> cartList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Constants.USER_TOKEN.isNotEmpty ?
    cartList = Func().getCart().then((val) {
      if (val.items.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
      }
      return val;
    }) : null;
  }

  void updateCart() {
    setState(() {
      cartList = Func().getCart().then((val) {
        if (val.items.isEmpty) {
          setState(() {
            isLoading = true;
          });
        }
        return val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Корзина',
          ),
          centerTitle: false,
        ),
        body: Constants.USER_TOKEN.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.remove_shopping_cart_outlined,
                      size: 50,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Для использования корзины\n необходимо войти в аккаунт',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        scakey.currentState?.onItemTapped(3);
                      },
                      child: const Text(
                        'Войти в аккаунт',
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  FutureBuilder<CartItem>(
                    future: cartList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildBagShimmer(context);
                      } else if (snapshot.hasData) {
                        final cartList = snapshot.data!;
                        if (snapshot.data!.items.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.remove_shopping_cart_outlined,
                                  size: 50,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Ваша корзина пуста',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        } else {
                          return BagCartWidget(
                              cart: cartList,
                              qtyChangeCallback: () => updateCart());
                        }
                      } else {
                        return const Center(child: Text("No widget to build"));
                      }
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: isLoading
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                fixedSize: Size(1.sw, 5.h),
                              ),
                              onPressed: () async {
                                final cartLink = await cartList.then((value) => value.link);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             PurchaseScreen(
                                                link: cartLink,)));
                              },
                              child: const Text(
                                'Оформить заказ',
                              ),
                            )),
                  )
                ],
              ));
  }
}
