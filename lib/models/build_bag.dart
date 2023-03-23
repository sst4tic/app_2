import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:yiwumart/util/product.dart';
import '../util/cart_list.dart';
import '../util/constants.dart';
import 'package:http/http.dart' as http;
import '../util/function_class.dart';

class BagCartWidget extends StatefulWidget {
  final CartItem cart;
  final VoidCallback qtyChangeCallback;

  const BagCartWidget(
      {super.key, required this.cart, required this.qtyChangeCallback});

  @override
  BagCartWidgetState createState() => BagCartWidgetState();
}

class BagCartWidgetState extends State<BagCartWidget> {
  @override
  Widget build(BuildContext context) {
    var cart = widget.cart;
    final cartList = widget.cart.items;
    void changeQty({required int id, required int qty}) async {
      var url =
          '${Constants.API_URL_DOMAIN}action=cart_product_qty&product_id=$id&qty=$qty';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          Constants.header: Constants.bearer,
        },
      );
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        setState(() {
          cartList.forEach((element) {
            if (element.id == id) {
              element.qty = qty;
              cart = CartItem(
                  items: cartList, totalSum: cart.totalSum, link: cart.link);
            }
          });
          widget.qtyChangeCallback.call();
          Func().showSnackbar(
              context, 'Количество товара изменено', body['success']);
        });
      } else {
        widget.qtyChangeCallback.call();
        Func().showSnackbar(context, body['message'], body['success']);
      }
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: REdgeInsets.all(10),
        children: [
          SizedBox(
            height: 35.h,
            child: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              title: const Text('Товары',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              centerTitle: false,
            ),
          ),
          const Divider(height: 0, thickness: 1),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cartList.length,
            itemBuilder: (context, index) {
              final cartItem = cartList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        product: Product(
                          id: cartItem.id,
                          name: cartItem.name,
                          price: cartItem.price,
                          is_favorite: null,
                          link: cartItem.link,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  height: 80.h,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(cartItem.imageThumb,
                            height: 60.h, width: 60.w, fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://yiwumart.org/images/shop/products/no-image-ru.jpg',
                            height: 60.h,
                            width: 60.w,
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cartItem.name,
                                style: const TextStyle(fontSize: 15),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 15.h),
                            Text(
                              '${cartItem.price} ₸ / шт.',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            height: 25.h,
                            width: 70.w,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (cartItem.qty != 0) {
                                        cartItem.qty--;
                                      }
                                    });
                                    changeQty(
                                        id: cartItem.id, qty: cartItem.qty);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  cartItem.qty.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      cartItem.qty++;
                                    });
                                    changeQty(
                                        id: cartItem.id, qty: cartItem.qty);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
                thickness: 1,
              );
            },
          ),
          const Divider(height: 0, thickness: 1),
          SizedBox(
            height: 35.h,
            child: AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              actions: [
                Container(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  height: 10.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Итоговая сумма: ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${cart.totalSum} ₸',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
