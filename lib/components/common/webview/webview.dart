import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// // [Only for web]
// import 'package:universal_html/html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String url;
  final Function(int)? onProgress;

  const WebView({
    Key? key,
    required this.url,
    this.onProgress,
  }) : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: widget.onProgress,
            onNavigationRequest: (NavigationRequest request) {
              if (request.url != widget.url) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (kIsWeb)
        ? _IframeView(
            source: widget.url,
          )
        : WebViewWidget(
            controller: controller,
          );
  }
}

class _IframeView extends StatefulWidget {
  final String source;

  const _IframeView({Key? key, required this.source}) : super(key: key);

  @override
  _IframeViewState createState() => _IframeViewState();
}

class _IframeViewState extends State<_IframeView> {
  // Widget _iframeWidget;
  // // [Only for web]
  // final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    // // [Only for web]
    // _iframeElement.src = widget.source;
    // _iframeElement.style.border = 'none';
    //
    // if (kIsWeb) {
    //   //ignore: undefined_prefixed_name
    //   ui.platformViewRegistry.registerViewFactory(
    //     widget.source, //use source as registered key to ensure uniqueness
    //     (int viewId) => _iframeElement,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: widget.source,
    );
  }
}
