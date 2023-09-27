import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../catalog_screens/product_screen.dart';
import '../util/order_detail.dart';
import '../util/product.dart';

Widget buildOrderDetails({required OrderDetail details, context}) {
  final cartList = details.items;
  return Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: ListView(
      padding: REdgeInsets.all(10),
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 12.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            height: 75.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25.h,
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Text(details.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Container(
                  height: 30.h,
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(children: [
                    Container(
                      height: 20.h,
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: details.status == 5
                            ? Colors.green[800]
                            : details.status == 6
                                ? Colors.red
                                : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            details.status == 5
                                ? FontAwesomeIcons.checkDouble
                                : details.status == 6
                                    ? FontAwesomeIcons.times
                                    : FontAwesomeIcons.clock,
                            size: 12,
                            color: details.status == 5
                                ? Colors.white
                                : details.status == 6
                                    ? Colors.red
                                    : Theme.of(context).primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          Text(details.statusName,
                              style: TextStyle(
                                  color: details.status == 5
                                      ? Colors.white
                                      : details.status == 6
                                          ? Colors.red
                                          : Theme.of(context).primaryColorLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 20.h,
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Text(details.date,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 35.h,
          child: AppBar(
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            title: const Text(
              'Товары',
            ),
          ),
        ),
        const Divider(height: 0, thickness: 1),
        ListView.separated(
          itemCount: cartList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final cartItem = cartList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(
                      product: Product(
                        reviewCount: 0,
                        rating: 0,
                        id: cartItem.id,
                        name: cartItem.title,
                        price: cartItem.price,
                        is_favorite: null,
                        link: cartItem.link,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                padding: REdgeInsets.only(
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
                      child: Image.network(
                        cartItem.img,
                        height: 60.h,
                        width: 60.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            height: 60.h,
                            width: 60.w,
                            child: Image.network(
                              'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cartItem.title,
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
          height: 30.h,
          child: AppBar(
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            actions: [
              Container(
                  padding: REdgeInsets.only(left: 10, top: 5, bottom: 5),
                  height: 15.h,
                  child: Text('Итоговая сумма: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColorLight,
                      ))),
              Container(
                  padding: REdgeInsets.only(right: 10, top: 5, bottom: 5),
                  height: 15.h,
                  child: Text('${details.total} ₸',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    ),
  );
}
