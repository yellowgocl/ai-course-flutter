import 'package:course/api/http.dart';
import 'package:course/config/config.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/base_data.dart';
import 'package:course/models/common/request_header_data.dart';
import 'package:course/models/remote/common/course_response_data.dart';
import 'package:course/models/remote/common/score_response_data.dart';
import 'package:course/models/remote/common/token_data.dart';
import 'package:course/models/remote/response_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RequestData extends BaseData {
  RequestData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  RequestData({id, String url, Map<String, dynamic> extra, Map<String, dynamic> headers}): super(id: id) {
    this.url = url;
    this.extra = extra;
    this.headers = headers;
  }
  set url(String val) {
    set('url', val);
  }
  String get url{
    return get<String>('url', null);
  }
  Map<String, dynamic> get extra{
    return get('extra', null);
  }
  set extra(Map<String, dynamic> val) {
    set("extra", val);
  }
  Map<String, dynamic> get headers {
    return get('headers', null);
  }
  set headers(Map<String, dynamic> val) {
    set("headers", val);
  }
  Options get options{
    return Options(extra: extra, headers: headers);
  }
}

class Api {
  static final Map<String, RequestData> requestInfos = Map<String, RequestData>.from({
    "token": RequestData(url:'${Environment.config.oms}/token'),
    "evaluating": RequestData(url: '${Environment.config.aiHost}/evaluating', extra: Map<String, dynamic>.from({
      // "mock": 'assets/data/mock/score.json'
    })),
    "qanda": RequestData(url: '${Environment.config.aiHost}/qanda', extra: Map<String, dynamic>.from({
      // "mock": 'assets/data/mock/score2.json'
    })),
    "course": RequestData(url: '${Environment.config.course}/unit', extra: Map<String, dynamic>.from({
      "mock": 'assets/data/mock/course.json'
    })),
    "createRecord": RequestData(url: '${Environment.config.course}/learn/record', extra: Map<String, dynamic>.from({
      "mock": 'assets/data/mock/create_record.json'})),
  });

  static Future<TokenData> fetchToken() async {
    RequestData req =  requestInfos["token"];
    String url = req?.url;
    TokenData r = await http.post<TokenData>(url, options: req.options, wrapperCall: ResponseDataHepler.wrapperTokenData);
    gameController.token = r.value;
    return r;
  }

  // 课程获取接口
  static Future<CourseResponseData> fetchCourse({courseId = "0"}) async {
    RequestData req =  requestInfos["course"];
    String url = "${req?.url}/$courseId/with/all";

    String deviceType = "mobile";
    RequestHeaderData headerData = RequestHeaderData(appId: gameController.appId, accessToken: gameController.accessToken, token: gameController.token, deviceId: gameController.deviceId, deviceType: deviceType);
    req.headers = headerData.header;

    print("headerData: ${req.options.headers.toString()}");
    CourseResponseData r = await http.get<CourseResponseData>(url, options: req.options, wrapperCall: ResponseDataHepler.wrapperCourseData);
    if (r.code == StatusCode.TOKEN_INVAILD) {
      await fetchToken();

      RequestHeaderData headerData = RequestHeaderData(appId: gameController.appId, accessToken: gameController.accessToken, token: gameController.token, deviceId: gameController.deviceId, deviceType: deviceType);
      req.headers = headerData.header;

      r = await http.get<CourseResponseData>(url, options: req.options, wrapperCall: ResponseDataHepler.wrapperCourseData);
    }
    if (r.code == StatusCode.TOKEN_INVAILD) {
      gameController.showApiDialog(
        title: "课程获取失败",
        onPositive: () {
          Navigator.of(gameController.context).pop();
          print('确定');
          fetchCourse(courseId: courseId);
        }
      );
    }
    print(r.flag);
    return r;
  }

  // 创建学习记录
  static Future<ResponseData> fetchLearnRecord({String courseId}) async {
    RequestData req = requestInfos["createRecord"];
    String url = req?.url;

    String appId = gameController.appId;
    String token = gameController.token;
    String accessToken = gameController.accessToken;
    String deviceId = gameController.deviceId;
    String deviceType = "mobile";
    RequestHeaderData headerData = RequestHeaderData(appId: appId, accessToken: accessToken, token: token, deviceId: deviceId, deviceType: deviceType);

    req.headers = headerData.header;

    // return await http.post<ResponseData>(url, options: req.options, data: Map<String, dynamic>.from({"unitId": courseId, "score": 0, "remarks": ""}));
    ResponseData r = await http.post<ResponseData>(url, options: req.options, data: Map<String, dynamic>.from({"unitId": courseId, "score": 0, "remarks": ""}));
    if (r.code == StatusCode.TOKEN_INVAILD) {
      await fetchToken();
      token = gameController.token;

      print("readed token");
      print(accessToken);
      print(token);

      RequestHeaderData headerData = RequestHeaderData(appId: appId, accessToken: accessToken, token: token, deviceId: deviceId, deviceType: deviceType);

      req.headers = headerData.header;

      r = await http.post<ResponseData>(url, options: req.options, data: Map<String, dynamic>.from({"unitId": courseId, "score": 0, "remarks": ""}));
    }
    if (r.code == StatusCode.TOKEN_INVAILD) {
      gameController.showApiDialog(
        title: "课程获取失败",
        onPositive: () {
          Navigator.of(gameController.context).pop();
          print('确定');
          fetchLearnRecord(courseId: courseId);
        }
      );
    }
    print(r.flag);
    return r;
  }

  // 更新学习记录
  static Future<ResponseData> updateLearnRecord({int id, String unitId, double score, Map data, String remarks}) async {
    RequestData req = requestInfos["createRecord"];
    String url = req?.url;

    String appId = gameController.appId;
    String token = gameController.token;
    String accessToken = gameController.accessToken;
    String deviceId = gameController.deviceId;
    String deviceType = "mobile";
    RequestHeaderData headerData = RequestHeaderData(appId: appId, accessToken: accessToken, token: token, deviceId: deviceId, deviceType: deviceType);

    req.headers = headerData.header;

    gameController.showLoading = true;
    // ResponseData responseData = await http.put<ResponseData>(url, options: req.options, data: {"id": id, "unitId": unitId, "score": score, "data": data, "remarks": remarks});
    ResponseData r = await http.put<ResponseData>(url, options: req.options, data: {"id": id, "unitId": unitId, "score": score, "data": data, "remarks": remarks});
    if (r.code == StatusCode.TOKEN_INVAILD) {
      await fetchToken();

      token = gameController.token;
      RequestHeaderData headerData = RequestHeaderData(appId: appId, accessToken: accessToken, token: token, deviceId: deviceId, deviceType: deviceType);

    req.headers = headerData.header;

      r = await http.put<ResponseData>(url, options: req.options, data: {"id": id, "unitId": unitId, "score": score, "data": data, "remarks": remarks});
    }
    if (r.code == StatusCode.TOKEN_INVAILD) {
      gameController.showApiDialog(
        title: "课程获取失败",
        onPositive: () {
          Navigator.of(gameController.context).pop();
          print('确定');
          updateLearnRecord(id: id, unitId: unitId, score: score, data: data, remarks: remarks);
        }
      );
    }
    print(r.flag);
    gameController.showLoading = false;
    // return responseData;
    return r;
  }

  // 评分接口
  static Future<ScoreResponseData> evaluating({String text, String audio}) async {
    RequestData req =  requestInfos["evaluating"];
    debugPrint("$text, $audio");
    gameController.showLoading = true;
    ScoreResponseData scoreResponseData = await http.post<ScoreResponseData>(req?.url, options: req.options, data: Map<String, dynamic>.from({"text": text, "audio": audio}), wrapperCall: ResponseDataHepler.wrapperScoreData);
    gameController.showLoading = false;
    return scoreResponseData;
  }
  static Future<ScoreResponseData> qanda({String audio, String type, List<String> keywords, List<String> answers}) async {
    RequestData req =  requestInfos["qanda"];
    gameController.showLoading = true;
    ScoreResponseData scoreResponseData = await http.post<ScoreResponseData>(req?.url, options: req.options, data: Map<String, dynamic>.from({"audio": audio, "type": type, "Option": {"keywords": keywords, "answers": answers}}), wrapperCall: ResponseDataHepler.wrapperScoreData);
    gameController.showLoading = false;
    return scoreResponseData;
  }
}