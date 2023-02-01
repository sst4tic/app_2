import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiwumart/catalog_screens/purchase_screen.dart';
import 'package:yiwumart/models/shimmer_model.dart';
import '../catalog_screens/product_screen.dart';
import '../util/constants.dart';

class ShoppingBag extends StatefulWidget {
  const ShoppingBag({
    Key? key,
  }) : super(key: key);

  @override
  State<ShoppingBag> createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Корзина',
        ),
        centerTitle: false,
      ),
      body: Constants.USER_TOKEN.isEmpty
          ? const Center(
              child: Text(
                'Авторизуйтесь',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          : Stack(children: [
              SafeArea(
                child: WebView(
                  javascriptChannels: {
                    JavascriptChannel(
                      name: 'WebViewMessage',
                      onMessageReceived: (JavascriptMessage message) {
                        if (message.message != '') {
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
                    ),
                    JavascriptChannel(
                      name: 'WebViewMessageCheckout',
                      onMessageReceived: (JavascriptMessage message) {
                        if (message.message != '') {
                          var dMessage = jsonDecode(message.message);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PurchaseScreen(
                                        link: '${dMessage['link']}',
                                      )));
                        }
                      },
                    ),
                    JavascriptChannel(
                      name: 'WebViewMessageCartLoaded',
                      onMessageReceived: (JavascriptMessage message) {
                        if (message.message != '') {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                      '${Constants.BASE_URL_DOMAIN}/cart?token=${Constants.USER_TOKEN}',
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Positioned.fill(
                  child: buildBagShimmer(context),
                ),
              )
            ]),
    );
  }
}
