
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiwumart/screens/order_detail_screen.dart';
import 'package:yiwumart/util/constants.dart';

import '../models/shimmer_model.dart';


class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'История покупок',
        ),
      ),
      body:
      SafeArea(
        child: Stack(
          children: [
            WebView(
              onPageFinished: (url) {
                if(mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              javascriptChannels: {
                JavascriptChannel(
                  name: 'WebViewMessage',
                  onMessageReceived: (JavascriptMessage message) {
                    if(message.message != '') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetails(
                                      url: message.message,
                              )));
                    }
                  },
                )
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: '${Constants.BASE_URL_DOMAIN}/my/orders?token=${Constants.USER_TOKEN}',
            ),
            Visibility(
              visible: isLoading,
              child: Positioned.fill(
                  child: buildPurchaseHistoryShimmer(context)),
            )
          ]
        ),
      ),
    );
  }
}
