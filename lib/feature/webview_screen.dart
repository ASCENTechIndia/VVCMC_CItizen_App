import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vvcmc_citizen_app/widgets/webview_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;
  final LoadRequestMethod? method;
  final Uint8List? body;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    this.method,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: WebView(url: url, method: method, body: body),
    );
  }
}
