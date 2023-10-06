import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiwumart/util/constants.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Оплата'),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url == 'https://yiwumart.org/cart') {
              Navigator.pop(context);
            }
            return NavigationDecision.navigate;
          },

          onWebViewCreated: (WebViewController webViewController) {
            webViewController.loadUrl(url, headers: Constants.headers());
          },
        ));
  }
}
