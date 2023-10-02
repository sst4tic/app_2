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
              ListView.separated(itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: REdgeInsets.all(0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://cdn.yiwumart.org/storage/warehouse/products/images/no-image-ru.jpg',
                      width: 43,
                      height: 43,
                    ),
                  ),
                  title: const Text(
                    'Морозильник типа "ларь"\nQ BC/BD 420L (1294*598*84)',
                    style: TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 12,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Text(
                    '368 000 т',
                    style: TextStyle(
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
                  itemCount: 2),
            ],
          ),
        ),
      );
    });

// if status == 5 => green
// if 6 => red
