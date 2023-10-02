import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../catalog_screens/product_screen.dart';
import '../util/order_detail.dart';
import '../util/product.dart';

Widget buildOrderDetails({required OrderDetail details, context}) {
  final cartList = details.items;
  return Column(
    children: [
      Container(
        padding: REdgeInsets.all(10),
        margin: REdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              details.title,
              style: const TextStyle(
                color: Color(0xFF181C32),
                fontSize: 15,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              details.date,
              style: const TextStyle(
                color: Color(0xFF919191),
                fontSize: 10,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
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
                    child: ListTile(
                        contentPadding: REdgeInsets.all(0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.img,
                            width: 43,
                            height: 43,
                          ),
                        ),
                        title: Text(
                          cartItem.title.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF181C32),
                            fontSize: 12,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Text(
                          '${cartItem.price} ₸',
                          style: const TextStyle(
                            color: Color(0xFF282E4D),
                            fontSize: 15,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        )));
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 0,
                  thickness: 1,
                );
              },
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Итоговая сумма: ',
                      style: TextStyle(
                        color: Color(0xFF464646),
                        fontSize: 12,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '${details.total} ₸',
                      style: const TextStyle(
                        color: Color(0xFF282E4D),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        padding: REdgeInsets.all(10),
        margin: REdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Статус заказа',
              style: TextStyle(
                color: Color(0xFF181C32),
                fontSize: 16,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w600,
              ),
            ),

            // ...List.generate(4, (index) {
            //   return EasyStepper(activeStep: 0, steps: [
            //     EasyStep(
            //       icon: Icon(Icons.circle),
            //     ),
            //     EasyStep(
            //       icon: Icon(Icons.circle),
            //
            //     ),EasyStep(
            //       icon: Icon(Icons.circle),
            //
            //     ),EasyStep(
            //       icon: Icon(Icons.circle),
            //     ),
            //   ]);
            // }),
          ],
        ),
      )
    ],
  );
}
