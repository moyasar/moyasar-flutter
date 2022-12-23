import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDSWebView extends StatelessWidget {
  final String transactionUrl;
  final String callbackUrl;
  final Function on3dsDone;

  const ThreeDSWebView(
      {super.key,
      required this.transactionUrl,
      required this.callbackUrl,
      required this.on3dsDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            initialUrl: transactionUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (pageUrl) {
              final redirectedTo = Uri.parse(pageUrl);
              final callbackUri = Uri.parse(callbackUrl);

              final bool hasReachedFinalRedirection =
                  redirectedTo.host == callbackUri.host;

              if (hasReachedFinalRedirection) {
                final queryParams = redirectedTo.queryParameters;

                String? status = queryParams['status'];
                String? message = queryParams['message'];

                on3dsDone(status, message);
              }
            },
          ),
        ),
      ),
    );
  }
}
