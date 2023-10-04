import 'package:flutter/material.dart';
import '../models/build_order.dart';
import '../models/shimmer_model.dart';
import '../util/function_class.dart';
import '../util/order_list.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  bool isLoading = true;
  late Future<List<OrderList>> orderFuture;

  @override
  void initState() {
    super.initState();
    orderFuture = Func().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'История покупок',
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: FutureBuilder<List<OrderList>>(
              future: orderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildPurchaseHistoryShimmer(context);
                } else if (snapshot.hasData) {
                  final order = snapshot.data!;
                  if (order.isEmpty) {
                    return const Center(
                      child: Text('Нет покупок'),
                    );
                  }
                  return buildOrder(order);
                } else {
                  print(snapshot.error);
                  print(snapshot.stackTrace);
                  return const Text("No widget to build");
                }
              }),
        ));
  }
}
