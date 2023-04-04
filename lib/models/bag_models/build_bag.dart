import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:yiwumart/util/product.dart';
import '../../bloc/bag_bloc/bag_bloc.dart';
import '../../catalog_screens/purchase_screen.dart';

class BagCartWidget extends StatefulWidget {
  const BagCartWidget({super.key});

  @override
  BagCartWidgetState createState() => BagCartWidgetState();
}

class BagCartWidgetState extends State<BagCartWidget> {
  bool isUpdating = false;
  void hideIndicator() {
    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isUpdating = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BagBloc, BagState>(
      builder: (context, state) {
        if (state is BagLoaded) {
          return Stack(
            children: [
              buildBagItems(state.cart),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PurchaseScreen(
                                      link: state.cart.link,
                                    )));
                      },
                      child: const Text(
                        'Оформить заказ',
                      ),
                    )),
              ),
              isUpdating ? const LoadingIndicator() : Container(),
            ],
          );
        } else {
          return const Center(child: Text('Ошибка'));
        }
      },
    );
  }

  Widget buildBagItems(cart) {
    final cartList = cart.items;
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
                            height: 30.h,
                            width: 80.w,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (cartItem.qty != 0) {
                                        isUpdating = true;
                                        cartItem.qty--;
                                        BlocProvider.of<BagBloc>(context)
                                            .add(ChangeQuantity(
                                          id: cartItem.id,
                                          quantity: cartItem.qty,
                                          context: context,
                                        ));
                                      }
                                    });
                                    hideIndicator();
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
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  cartItem.qty.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isUpdating = true;
                                      BlocProvider.of<BagBloc>(context)
                                          .add(ChangeQuantity(
                                        id: cartItem.id,
                                        quantity: cartItem.qty + 1,
                                        context: context,
                                      ));
                                    });
                                    hideIndicator();
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
                                      size: 20,
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

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
