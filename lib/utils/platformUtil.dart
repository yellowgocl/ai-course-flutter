// import 'dart:convert';

import 'dart:io';
import 'package:course/models/common/platform_data.dart';
import 'package:course/models/event/native_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

import 'eventUtil.dart';

/**
 * 用户平台交互定义，主要在这里实现和宿主通信，methodChannel和eventChannel定义。
 */
class _PlatformUtil {
  
  static const String METHOD_CHANNEL_DEFAULT = 'com.example.flutterinandroid/data';
  static const String METHOD_CHANNEL_IOS = 'com.zib.robot/native_get';
  MethodChannel _methodChannel;
  static PlatformData _platformData;
  static final _instance = new _PlatformUtil._internal();
  factory _PlatformUtil () {
    return _instance;
  }
  _PlatformUtil._internal();
  static _PlatformUtil get instance {
    return new _PlatformUtil();
  }
  PlatformData get platformData {
    return _platformData??PlatformData();
  }
  Future<bool> initialized() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    _platformData = PlatformData.fromJson(Map<String, dynamic>.from({
      "appName": info?.appName,
      "version": info?.version,
      "buildNumber": info?.buildNumber,
      "packageName": info?.packageName,
    }));
    return Future.value(info != null);
  }
  get methodChannel {
    String methodChannelValue = Platform.isIOS ? METHOD_CHANNEL_IOS : METHOD_CHANNEL_DEFAULT;
    if (_methodChannel == null) {
      _methodChannel = MethodChannel(methodChannelValue);
      _methodChannel.setMethodCallHandler(_receiveFromHost);
    }
    return _methodChannel;
  }

  Future<Directory> get documentDir {
    return getApplicationDocumentsDirectory();
  }

  Future<bool> _receiveFromHost(MethodCall call) async {
    try {
      if (call.method == 'fromHostToClient') {
        NativeEvent event;
        try {
          event = NativeEvent.fromJson(Map<String,dynamic>.from(call.arguments));
        } catch (e) {
          print("error: $e");
          return false;
        }

        EventUtil.fire(event);
        return event.isVaild;
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
      return (false);
    }
    return false;
  }
  
  Future<dynamic> invokeMethod (NativeEvent args) async {
    // flutter_test
    // debugPrint(args.toJson().toString());
    assert(args != null);
    var result;
    try{
      result = await methodChannel.invokeMethod('formClientToHost', args.toJson());
      // debugPrint(result);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } on MissingPluginException catch (e) {
      debugPrint(e.toString());
    }
    return Future.value(result);
  }

  
}

final _PlatformUtil platformUtil = _PlatformUtil.instance;