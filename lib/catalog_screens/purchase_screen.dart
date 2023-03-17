import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/shimmer_model.dart';
import '../screens/main_screen.dart';
import '../util/constants.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    print(widget.link);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Оформление заказа',
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              onPageFinished: (url) {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onWebViewCreated: (WebViewController webViewController) {
                webViewController.loadUrl(
                  widget.link,
                  headers: {
                    Constants.header: Constants.bearer,
                  },
                );
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: {
                JavascriptChannel(
                  name: 'WebViewMessage',
                  onMessageReceived: (JavascriptMessage message) {
                    if (message.message != '') {
                      scakey.currentState!.onThirdItemTapped();
                    }
                  },
                ),
              },
            ),
            Visibility(
              visible: isLoading,
              child: Positioned.fill(child: buildPurchaseShimmer(context)),
            )
          ],
        ),
      ),
    );
  }
}
