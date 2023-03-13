import 'package:flutter/material.dart';
import '../models/build_order_details.dart';
import '../models/shimmer_model.dart';
import '../util/function_class.dart';
import '../util/order_detail.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    Key? key, required this.id
  }) : super(key: key);

  final int id;
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static var id;
  late Future<OrderDetail> orderDetailsFuture;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    orderDetailsFuture = Func().getOrderDetails(id: id);
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
      ),
      body: FutureBuilder<OrderDetail>(
        future: orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildDetailShimmer(context);
          } else if (snapshot.hasData) {
            final order = snapshot.data!;
            return buildOrderDetails(details: order, context: context);
          } else {
            print(snapshot.error);
            return const Text("No widget to build");
          }
        },
      )
    );
  }
}