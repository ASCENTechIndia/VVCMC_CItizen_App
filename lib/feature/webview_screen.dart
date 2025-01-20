import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/webview_widget.dart';

class WebViewScreen extends StatelessWidget {
  static const String routeName = "/web_view";

  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: colorScheme.primary,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: colorScheme.onPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      body: WebView(url: url),
    );
  }
}
