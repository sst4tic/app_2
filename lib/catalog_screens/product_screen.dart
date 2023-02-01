import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yiwumart/models/shimmer_model.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.name, required this.link}) : super(key: key);
  final String? name;
  final String link;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? link;
  String? name;
  String? shareLink;
  @override
  void initState() {
    super.initState();
    name = widget.name;
    shareLink = widget.link;
    link = '${widget.link}?token=app';
  }
  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              Share.share(shareLink!);
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],
        title: Text(
          name!,
          maxLines: 1,
            style: Theme.of(context).textTheme.titleSmall
        ),
      ),
      body: Stack(
        children: [
             SafeArea(
               child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: link,
                onPageFinished: (url) {
                  if(mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
            ),
             ),
          Visibility(
            visible: isLoading,
            child: Positioned.fill(
                child: buildCartShimmer(context)),
          )
        ]
      )
    );
  }
}