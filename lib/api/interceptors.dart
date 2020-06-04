
import 'package:course/api/api.dart';
import 'package:course/api/http.dart';
import 'package:course/config/config.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/common/request_header_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:dio/dio.dart';

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';

class CommonInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    // TODO: implement onRequest
    // print('interceptor on request:${options.path}');
    if (Api.requestInfos['token'].url == options?.path ) {
      // 在这里设置对应的token请求头
      String appId = gameController.appId??'10000';
      RequestHeaderData headerData = RequestHeaderData(appId: appId);
      Map<String, dynamic> params = _getTokenParams(headerData.appId, headerData.secret);
      options.headers = headerData.header;
      options.queryParameters = params;
    }

    if (Environment.env == Env.dev && options.extra.containsKey("mock")) {
      Map<String, dynamic> temp = await CommonUtil.loadAssetsJson(options.extra["mock"]);
      // response.data = temp;
      return temp != null ? http.resolve(temp) : super.onRequest(options);
    } else {
      return super.onRequest(options);
    }
  }
  @override
  Future onResponse(Response response) async {
    // TODO: implement onResponse
    // if (Environment.env == Env.dev) {
    //   if (response.request.extra.containsKey("mock")) {
    //     Map<String, dynamic> temp = await CommonUtil.loadAssetsJson(response.request.extra["mock"]);
    //     response.data = temp;
    //   }
    // }
    return super.onResponse(response);
  }

  static Map<String, dynamic> _getTokenParams(String appId, String secret) {
    String timestamp = formatDate(DateTime.now(), [yyyy,mm,dd,HH,nn,ss,SSS]);
    String str = "appId" + appId + "timestamp" + timestamp;
    String key = secret;

    var strBytes = utf8.encode(str);
    var keyBytes = utf8.encode(key);

    var hmacSha1 = new Hmac(sha1, keyBytes); // HMAC-SHA256
    var hmac = hmacSha1.convert(strBytes);
    return Map<String, dynamic>.from({
      "sign": base64Encode(hmac.bytes),
      "timestamp": timestamp,
      "appId": appId
    });
  }
}