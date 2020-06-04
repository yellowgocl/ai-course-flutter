import 'dart:io';

import 'package:course/models/base_data.dart';
import 'package:course/models/enum/enums.dart';

class PlatformData extends BaseData {
  PlatformData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  PlatformData({id, PlatformType platform, String version, String buildNumber, String appName, String packageName,}): super(id:id) {
    this.packageName = packageName;
    this.appName = appName;
    this.version = version;
    this.buildNumber = buildNumber;
    this.platform = platform;
  }
  set platform(PlatformType val) {
    set('platform', val);
  }
  PlatformType get platform{
    PlatformType type = PlatformType.ANDROID;
    if (Platform.isWindows) {
      type = PlatformType.WINDOWS;
    } else if (Platform.isFuchsia) {
      type = PlatformType.FUCHSIA;
    } else if (Platform.isIOS) {
      type = PlatformType.IOS;
    } else if (Platform.isLinux) {
      type = PlatformType.LINUX;
    } else if (Platform.isMacOS) {
      type = PlatformType.MACOS;
    }
    return type;
  }
  set version(String val){
    set('version', val);
  }
  String get version{
    return get<String>('version', '1.0.0');
  }
  set buildNumber(String val){
    set('buildNumber', val);
  }
  String get buildNumber{
    return get<String>('buildNumber', '1');
  }
  set appName(String val){
    set('appName', val);
  }
  String get appName{
    return get<String>('appName', 'course');
  }
  set packageName(String val){
    set('packageName', val);
  }
  String get packageName{
    return get<String>('packageName', 'course.zib.com.course');
  }
}