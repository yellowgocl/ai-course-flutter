import 'package:course/component/webView.dart' as Lib;
import 'package:course/config/config.dart';
import 'package:course/core/gameController.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Report extends StatefulWidget {
  // final url = 'http://10.1.5.100:8080/#/report/course/1231';
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = '${Environment.config.reportUrl}${gameController.learnRecordId}';
  }
  @override
  Widget build(BuildContext context) {
    return Lib.WebView(url: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}