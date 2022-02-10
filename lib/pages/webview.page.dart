import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import 'package:yatayat_drivers_app/shared/constants.shared.dart';

class ShowWebsite extends StatefulWidget {
  const ShowWebsite({Key? key}) : super(key: key);
  static const id = 'showWebsite';

  @override
  _ShowWebsiteState createState() => _ShowWebsiteState();
}

class _ShowWebsiteState extends State<ShowWebsite> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
    FocusScope.of(context).unfocus();
    return Scaffold(
      appBar: AppBar(
        title: Text('Hamro Yatayat'),
        backgroundColor: kThemeColor,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
