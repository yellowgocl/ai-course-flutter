import 'dart:convert';

import 'package:course/api/interceptors.dart';
import 'package:course/models/remote/common/course_response_data.dart';
import 'package:course/models/remote/common/score_response_data.dart';
import 'package:course/models/remote/common/token_data.dart';
import 'package:course/models/remote/response_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class StatusCode {
  static const int TOKEN_INVAILD = 401;
  static const int ACCESS_TOKEN_INVAILD = 4010;
  static const int ACCESS_TOKEN_REFRESH_FAILURE = 4012;
  static const int NO_DATA = 4040;
}

class _Http {
  static final _instance = new _Http._internal();
  factory _Http () {
    return _instance;
  }
  _Http._internal();
  
  static _Http get instance {
    return new _Http();
  }

  Dio _request;

  void initialize(BaseOptions options) {
    _request = Dio(options);
    _request.interceptors.add(CommonInterceptor());
  }

  lock(){
    _request?.lock();
  }
  get responseLock{
    return _request.interceptors.responseLock;
  }
  get errorLock{
    return _request.interceptors.errorLock;
  }
  unlock() {
    _request?.unlock();
  }
  clear() {
    _request?.clear();
  }
  Future<Response<T>> resolve<T>(response) {
    return _request?.resolve(response);
  }
  Future<Response<T>> reject<T>(err) {
    return _request?.reject(err);
  }

  void close({bool force: false}) {
    _request?.close(force: force);
  }
  Future<T> get<T extends ResponseData>(String url, { Options options, Map<String, dynamic> params, CancelToken cancelToken, Function(int, int) onReceiveProgress, T Function(Map<String, dynamic> json) wrapperCall}) async {
    print('####### dio request(get, url: $url) start #######');
    debugPrint('url: $url, \n options: ${options.headers.toString()}, \n params: $params, \n cancelToken: $cancelToken');
    ResponseData result;
    try {
      Response response = await _request.get(url, options: options, queryParameters: params, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
      wrapperCall = wrapperCall??ResponseDataHepler.wrapperDefault;
      result = wrapperCall(response.data is String ? jsonDecode(response.data) : response.data);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('dio request(get, url: $url) was cancel.');
      } else {
        print('dio request(get, url: $url) request error: $e');
      }
    }
    print('response: $result');
    print('####### dio request(get, url: $url) end #######');
    return result;
  }

  Future<T> post<T extends ResponseData>(String url, { data, Options options, Map<String, dynamic> params, CancelToken cancelToken, Function(int, int) onReceiveProgress, Function(int, int)onSendProgress, T Function(Map<String, dynamic> json) wrapperCall}) async {
    print('####### dio request(post, url: $url) start #######');
    print('url: $url, \n options: $options, \n data: $data, \n params: $params, \n cancelToken: $cancelToken');
    T result;
    try {
      Response response = await _request.post(url, data: data, options: options, queryParameters: params, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress, onSendProgress: onSendProgress);
      wrapperCall = wrapperCall??ResponseDataHepler.wrapperDefault;
      result = wrapperCall(response.data is String ? jsonDecode(response.data) : response.data);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('dio request(post, url: $url) was cancel.');
      } else {
        print('dio request(post, url: $url) request error: $e');
      }
      result = wrapperCall(Map<String, dynamic>.from({"code": e.response.statusCode, "message": e.response.data}));
    }
    print('response: $result');
    print('####### dio request(post, url: $url) end #######');
    
    return result;
  }

  Future<T> put<T extends ResponseData>(String url, { data, Options options, Map<String, dynamic> params, CancelToken cancelToken, Function(int, int) onReceiveProgress, Function(int, int)onSendProgress, T Function(Map<String, dynamic> json) wrapperCall}) async {
    print('####### dio request(put, url: $url) start #######');
    print('url: $url, \n options: $options, \n data: $data, \n params: $params, \n cancelToken: $cancelToken');
    T result;
    try {
      Response response = await _request.put(url, data: data, options: options, queryParameters: params, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress, onSendProgress: onSendProgress);
      wrapperCall = wrapperCall??ResponseDataHepler.wrapperDefault;
      result = wrapperCall(response.data is String ? jsonDecode(response.data) : response.data);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('dio request(put, url: $url) was cancel.');
      } else {
        print('dio request(put, url: $url) request error: $e');
      }
      result = wrapperCall(Map<String, dynamic>.from({"code": e.response.statusCode, "message": e.response.data}));
    }
    print('response: $result');
    print('####### dio request(put, url: $url) end #######');
    
    return result;
  }

}

class ResponseDataHepler{
  static TokenData wrapperTokenData(Map<String, dynamic> json) {
    return json != null ? TokenData.fromJson(json) : null;
  }
  static CourseResponseData wrapperCourseData(Map<String, dynamic> json) {
    return json != null ? CourseResponseData.fromJson(json) : null;
  }
  static ScoreResponseData wrapperScoreData(Map<String, dynamic> json) {
    return json != null ? ScoreResponseData.fromJson(json) : null;
  }
  static ResponseData wrapperDefault(Map<String, dynamic> json) {
    return json != null ? ResponseData.fromJson(json) : null;
  }
}

final _Http http = _Http.instance;