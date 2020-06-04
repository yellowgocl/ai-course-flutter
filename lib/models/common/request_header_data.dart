import 'dart:convert';

import 'package:course/models/base_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:crypto/crypto.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';


class RequestHeaderData extends BaseData {

  // "application/json; charset=utf-8"
  // "application/x-www-form-urlencoded; charset=utf-8"

  RequestHeaderData({String appId, String contentType, String deviceType, String deviceId, String accessToken, id, String token}): super(id: id) {
    this.appId = appId;
    this.contentType = contentType;
    this.deviceType = deviceType;
    this.deviceId = deviceId;
    this.accessToken = accessToken;
    this.token = token;
  }
  RequestHeaderData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  
  String get secret {
    switch(appId) {
      case "10000":
        return "2k762g1o8ywfu7bh2dby";
        break;
      case "10001":
        return "ycvylq7l2d7j81131c22";
        break;
      case "10002":
        return "a1fw817u923dso8bhr2p";
        break;
      case "10003":
        return "xdtfv9m3dngcvgybd25e";
        break;
    }
    return null;
  }
  String get appId {
    return get<String>('appId', null);
  }
  set appId(String val) {
    set('appId', val);
  }
  String get contentType {
    String r = get<String>('contentType', 'application/json; charset=utf-8');
    if (r == null || r.length == 0) {
      r = isVaild ? "application/x-www-form-urlencoded; charset=utf-8" : "application/json; charset=utf-8";
    }
    return r;
  }
  set contentType(String val) {
    set('contentType', val);
  }
  String get deviceType{
    return get<String>('deviceType', null);
  }
  set deviceType(String val){
    set('deviceType', val);
  }
  String get accessToken{
    return get<String>('accessToken', null);
  }
  set accessToken(String val){
    set('accessToken', val);
  }
  bool get isVaild{
    return secret != null;
  }
  String get deviceId{
    return get<String>('deviceId', null);
  }
  set deviceId(String val) {
    set('deviceId', val);
  }
  String get token{
    return get<String>('token', null);
  }
  set token(String val) {
    set('token', val);
  }

  Map<String, dynamic> get header {
    // TODO: implement toJson
    return Map<String, dynamic>.from({
      "Content-Type": contentType,
      "deviceType": deviceType,
      "appId": appId,
      "deviceId": deviceId,
      "authorization": accessToken,
      "token": token
    });
  }
}