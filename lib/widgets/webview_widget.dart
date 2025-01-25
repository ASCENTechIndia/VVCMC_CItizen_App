import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String url;

  const WebView({super.key, required this.url});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                loadingPercentage = 0;
              });
            }
          },
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                loadingPercentage = progress;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                loadingPercentage = 100;
              });
            }
          },
          onWebResourceError: (WebResourceError err) {
            final noInternet =
                err.description == "net::ERR_INTERNET_DISCONNECTED";
            print(err.description);
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  content: Text(
                    noInternet
                        ? "Looks like you are not connected to the internet\nPlease connect to a network and try again."
                        : "Oops! Something went wrong, please try again later",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text("Okay"),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
                );
              },
            );
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      );

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          )
        else
          buildBody()
      ],
    );
  }

  Widget buildBody() {
    return WebViewWidget(controller: controller);
  }
}
