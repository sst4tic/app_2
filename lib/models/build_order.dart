import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiwumart/screens/order_detail_screen.dart';
import '../util/order_list.dart';

Widget buildOrder(List<OrderList> order) => ListView.builder(
    padding: REdgeInsets.all(10),
    shrinkWrap: true,
    itemCount: order.length,
    itemBuilder: (context, index) {
      final orderItem = order[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetails(
                id: orderItem.id,
              ),
            ),
          );
        },
        child: Container(
          padding: REdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          margin: const EdgeInsets.only(bottom: 12.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(orderItem.title,
                      style:  const TextStyle(
                        color: Color(0xFF181C32),
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w600,
                      )),
                  Container(
                    padding: REdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: orderItem.status == 5
                          ? Colors.green[800]
                          : orderItem.status == 6
                          ? Colors.red
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 8,),
                        const SizedBox(width: 5),
                        Text(orderItem.statusName,
                            style: TextStyle(
                                color: orderItem.status == 5
                                    ? Colors.white
                                    : orderItem.status == 6
                                    ? Colors.red
                                    : Theme.of(context).primaryColorLight,
                              fontSize: 10,
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              Text(orderItem.date,
                  style: const TextStyle(
                    color: Color(0xFF919191),
                    fontSize: 10,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 10),
              ListView.separated(
                  itemBuilder: (context, index) {
                    final product = orderItem.products[index];
                return ListTile(
                  contentPadding: REdgeInsets.all(0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                     product.imageThumb,
                      width: 43,
                      height: 43,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          FontAwesomeIcons.image,
                          size: 32,
                        );
                      }
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 12,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Text(
                    product.price,
                    style: const TextStyle(
                      color: Color(0xFF282E4D),
                      fontSize: 15,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  )
                );
              },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(height: 0),
                  itemCount: orderItem.products.length),
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
                        text: orderItem.total,
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
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () =>  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetails(
                    id: orderItem.id,
                  ),
                ),
              ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(10000, 38),
                  ),
                  child: const Text(
                'Посмотреть детали',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Noto Sans',
                  fontWeight: FontWeight.w700,
                ),
              ))
            ],
          ),
        ),
      );
    });

// if status == 5 => green
// if 6 => red
