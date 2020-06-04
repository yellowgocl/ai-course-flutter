import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as Lib;

class WebView extends StatefulWidget {
  final url;
  final String initialUrl;
  final Lib.JavascriptMode javascriptMode;
  WebView({Key key, @required this.url, this.initialUrl, this.javascriptMode: Lib.JavascriptMode.disabled}): super(key: key,);
  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final Completer<Lib.WebViewController> _controllerCompleter = Completer<Lib.WebViewController>();
  Lib.WebViewController _controller;

  @override
  void didUpdateWidget(WebView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // print(widget.url);
    _controller?.loadUrl(widget.url);
    // _controller?.reload();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lib.WebViewController>(
      future: _controllerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<Lib.WebViewController> snapshot) {
        final bool isReady = snapshot.connectionState == ConnectionState.done;
        _controller = snapshot.data;
        // print('isReady:$isReady');
        if (isReady) _controller.loadUrl(widget.url);
        return Lib.WebView(
          initialUrl: widget.initialUrl,
          javascriptMode: widget.javascriptMode,
          onWebViewCreated: ((Lib.WebViewController mWebViewController) {
            _controllerCompleter.complete(mWebViewController);
          }),
          javascriptChannels: <Lib.JavascriptChannel>[].toSet(),
          navigationDelegate: ((Lib.NavigationRequest request){
            return Lib.NavigationDecision.navigate;
          }),
          onPageStarted: (String url) {
            print('webview on page started: $url');
          },
          onPageFinished: (String url) {
            print('webview on page finished: $url');
          },
        );
      },
    );
    
  }
}