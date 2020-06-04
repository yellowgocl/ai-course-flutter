import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SharedPreferencesUtil{
_SharedPreferencesUtil _platformData;
  static final _instance = new _SharedPreferencesUtil._internal();
  factory _SharedPreferencesUtil () {
    return _instance;
  }
  SharedPreferences prefs;
  _SharedPreferencesUtil._internal();
  static _SharedPreferencesUtil get instance {
    return new _SharedPreferencesUtil();
  }
  Future<bool> initialized() async{
    prefs = await SharedPreferences.getInstance();
    return Future.value(prefs != null);
  }

  Future<bool> refreshProcess(String courseId, String userId, Map data) {
    return prefs.setString("$userId-$courseId", jsonEncode(data).toString());
  }

  Future<Map> getProcess(String courseId, String userId) {
    String courseSharedData = prefs.getString("$userId-$courseId");
    Map courseData;
    if (courseSharedData == null){
      return Future.value(null);
    }
    debugPrint("courseData: $courseSharedData");

    // 是否为合法数据
    if (jsonDecode(courseSharedData) is Map) {
      courseData = jsonDecode(courseSharedData);
      if (courseData["currentPoint"] == null 
          || courseData["currentBlockId"] == null 
          || courseData["list"] == null) {
        clearProcess(courseId, userId);
        courseData = null;
      }
    }else{
      clearProcess(courseId, userId);
      courseData = null;
    }

    return Future.value(courseData);
  }

  Future<bool> clearProcess(String courseId, String userId) {
    return Future.value(prefs.remove("$userId-$courseId"));
  }
}

final _SharedPreferencesUtil sharedPreferences = _SharedPreferencesUtil.instance;