import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// The widget that shows the 3DS step.
class ThreeDSWebView extends StatefulWidget {
  final String transactionUrl;
  final Function on3dsDone;
  final Uri callbackUri = Uri.parse(PaymentConfig.callbackUrl);

  ThreeDSWebView(
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
      // JavaScript must stay enabled — bank 3DS challenge pages require it.
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        // Allow-list schemes: bank/gateway redirects and the callback URL are
        // http(s) only. Block every other scheme (javascript:, data:, file:,
        // intent:, ...) so a compromised or malicious 3DS page cannot escape
        // the payment flow.
        onNavigationRequest: (NavigationRequest request) {
          final scheme = Uri.tryParse(request.url)?.scheme;
          if (scheme != 'https' && scheme != 'http') {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (pageUrl) {
          final redirectedTo = Uri.parse(pageUrl);

          final bool hasReachedFinalRedirection =
              redirectedTo.host == widget.callbackUri.host;

          if (hasReachedFinalRedirection) {
            final queryParams = redirectedTo.queryParameters;

            String status = queryParams['status'] ?? '';
            String message = queryParams['message'] ?? '';

            widget.on3dsDone(status, message);
          }
        },
      ));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.height,
          width: WidgetsBinding
              .instance.platformDispatcher.views.first.physicalSize.width,
          child: WebViewWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
