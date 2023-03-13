import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiwumart/screens/order_detail_screen.dart';
import '../util/order_list.dart';

Widget buildOrder(List<OrderList> order) => ListView.builder(
    padding: REdgeInsets.all(10),
    shrinkWrap: true,
    itemCount: 10,
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
        child: Card(
          margin: const EdgeInsets.only(bottom: 12.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            color: Theme.of(context).colorScheme.secondary,
            height: 75.h,
            child: Column(
              children: [
                Container(
                  height: 25.h,
                  padding: REdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: Row(children: [
                    Text(orderItem.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text(orderItem.date,
                        style: const TextStyle(
                            fontSize: 14,
                          fontWeight: FontWeight.w400
                            )),
                  ]),
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
                        color: orderItem.status == 5
                            ? Colors.green[800]
                            : orderItem.status == 6
                                ? Colors.red
                                : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            orderItem.status == 5
                                ? FontAwesomeIcons.checkDouble
                                : orderItem.status == 6
                                    ? FontAwesomeIcons.times
                                    : FontAwesomeIcons.clock,
                            size: 12,
                            color: orderItem.status == 5
                                ? Colors.white
                                : orderItem.status == 6
                                    ? Colors.red
                                    : Theme.of(context).primaryColorLight,
                          ),
                          const SizedBox(width: 5),
                          Text(orderItem.statusName,
                              style: TextStyle(
                                  color: orderItem.status == 5
                                      ? Colors.white
                                      : orderItem.status == 6
                                          ? Colors.red
                                          : Theme.of(context).primaryColorLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text('${orderItem.total} ₸',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );
    });

// if status == 5 => green
// if 6 => red
