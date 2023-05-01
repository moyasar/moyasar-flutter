import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDSWebView extends StatefulWidget {
  final String transactionUrl;
  final Function on3dsDone;

  const ThreeDSWebView(
      {super.key, required this.transactionUrl, required this.on3dsDone});

  @override
  State<ThreeDSWebView> createState() => _ThreeDSWebViewState();
}

class _ThreeDSWebViewState extends State<ThreeDSWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    initWebViewController();
  }

  void initWebViewController() {
    final controller = WebViewController()
      ..loadRequest(Uri.parse(widget.transactionUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (pageUrl) {
        final redirectedTo = Uri.parse(pageUrl);
        final callbackUri = Uri.parse(PaymentConfig.callbackUrl);

        final bool hasReachedFinalRedirection =
            redirectedTo.host == callbackUri.host;

        if (hasReachedFinalRedirection) {
          final queryParams = redirectedTo.queryParameters;

          String? status = queryParams['status'];
          String? message = queryParams['message'];

          widget.on3dsDone(status, message);
        }
      }));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
