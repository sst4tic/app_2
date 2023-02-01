import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiwumart/catalog_screens/product_screen.dart';
import 'package:yiwumart/util/constants.dart';

import '../models/shimmer_model.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key, required this.url}) : super(key: key);
  final url;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static var url;
  static var dUrl;

  @override
  void initState() {
    super.initState();
    url = widget.url;
    dUrl = jsonDecode(url);
  }
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
      ),
      body: 
      Stack(
        children: [
          WebView(
            onPageFinished: (url) {
              setState(() {
                isLoading = false;
              });
            },
            javascriptChannels: {
              JavascriptChannel(
                name: 'WebViewMessage',
                onMessageReceived: (JavascriptMessage message) {
                  if(message.message != '') {
                    var dMessage = jsonDecode(message.message);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              name: dMessage['title'],
                              link: '${dMessage['url']}',
                            )));
                  }
                },
              )
            },
            initialUrl: '${dUrl['url']}?token=${Constants.USER_TOKEN}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
          Visibility(
            visible: isLoading,
            child:  Positioned.fill(
                child: buildDetailShimmer(context),
          )
          )
        ]
      ),
    );
  }
}
