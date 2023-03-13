import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yiwumart/util/constants.dart';

import '../autorization/login.dart';
import '../models/shimmer_model.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Профиль',
        ),
      ),
      body:
      SafeArea(
        child:
        Stack(
          children: [
            WebView(
              onPageFinished: (url) {
                if(mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                webViewController.loadUrl(
                  '${Constants.BASE_URL_DOMAIN}/my/edit',
                  headers: {
                    Constants.header: Constants.bearer,
                  },
                );
              },
            javascriptChannels: {
              JavascriptChannel(
                name: 'WebViewMessage',
                onMessageReceived: (JavascriptMessage message) async {
                  if(message.message != '') {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.clear().then((value) => Constants.USER_TOKEN ='');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Login()),
                            (route) => false);
                  }
                },
              )
            },
          ),
            Visibility(
              visible: isLoading,
              child: Positioned.fill(
                  child: buildEditShimmer(context)),
            )
          ],
        ),
      ),
    );
  }
}
