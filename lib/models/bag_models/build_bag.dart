import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:yiwumart/util/cart_list.dart';
import 'package:yiwumart/util/function_class.dart';
import '../../bloc/bag_bloc/bag_bloc.dart';
import '../../catalog_screens/purchase_screen.dart';

class BagCartWidget extends StatefulWidget {
  const BagCartWidget({super.key, required this.bagBloc});

  final BagBloc bagBloc;

  @override
  BagCartWidgetState createState() => BagCartWidgetState();
}

class BagCartWidgetState extends State<BagCartWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BagBloc, BagState>(
      bloc: widget.bagBloc,
      builder: (context, state) {
        if (state is BagLoaded) {
          return Stack(
            children: [
              buildBagItems(state.cart, state.selectedItems, widget.bagBloc,
                  state.allSelected),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    padding: REdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fixedSize: Size(1.sw, 40.h),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PurchaseScreen(
                                      cartId: state.cart.cartId!,
                                      totalSum: state.cart.totalSum,
                                    )));
                      },
                      child: const Text(
                        'Оформить заказ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )),
              ),
            ],
          );
        } else {
          return const Center(child: Text('Ошибка'));
        }
      },
    );
  }

  Widget buildBagItems(CartItem cart, Set<int> selectedValues, BagBloc bagBloc,
      bool isSelectAll) {
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
              titleSpacing: 0,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                    value: isSelectAll,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => const BorderSide(
                          width: 1.0, color: Color(0xFFC7C7C7)),
                    ),
                    onChanged: (val) {
                      for (var element in cartList) {
                        // make check if element is selected
                        // if(!selectedValues.contains(element.id)) {
                        // selectedValues.add(element.id);
                        // bagBloc.add(SelectItem(id: element.id));
                        // }
                        bagBloc
                            .add(SelectItem(id: element.id, isSelectAll: true));
                      }
                    },
                  ),
                  const Text('Выбрать все',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        if (selectedValues.isNotEmpty) {
                          Func().showDeleteCart(
                              context: context,
                              submitCallback: () {
                                if (selectedValues.isNotEmpty) {
                                  bagBloc
                                      .add(DeleteSelected(ids: selectedValues));
                                }
                              });
                        }
                      },
                      child: Text('Удалить выбранное',
                          style: TextStyle(
                            color: selectedValues.isEmpty
                                ? Colors.grey
                                : const Color(0xFFCC444A),
                            fontSize: 12,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w500,
                          ))),
                ],
              ),
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
                      builder: (context) => ProductScreen(id: cartItem.id,)
                    ),
                  );
                },
                child: Container(
                  padding: REdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  height: 80.h,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.blue,
                          value: selectedValues.contains(cartItem.id),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                width: 1.0, color: Color(0xFFC7C7C7)),
                          ),
                          onChanged: (val) {
                            bagBloc.add(SelectItem(id: cartItem.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
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
                                    if (cartItem.qty != 0) {
                                      cartItem.qty--;

                                      bagBloc.add(ChangeQuantity(
                                        id: cartItem.id,
                                        quantity: cartItem.qty,
                                        context: context,
                                      ));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: const Color(0xFFD6D6D6),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      cartItem.qty == 1
                                          ? CupertinoIcons.trash
                                          : Icons.remove,
                                      color:
                                          const Color.fromRGBO(13, 110, 253, 1),
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
                                    bagBloc.add(ChangeQuantity(
                                      id: cartItem.id,
                                      quantity: cartItem.qty + 1,
                                      context: context,
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: const Color(0xFFD6D6D6),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Color.fromRGBO(13, 110, 253, 1),
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
