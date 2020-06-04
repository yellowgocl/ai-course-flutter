import 'package:course/models/event/base_event.dart';
import 'package:course/utils/platformUtil.dart';
import 'package:flutter/foundation.dart';

class NativeEvent extends BaseEvent<NativeEventParams>{
  NativeEvent({event, NativeEventParams params}): super(event: event, params: params){
    _mergeNativeInfo();
  }
  NativeEvent.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    // print(json);
    _mergeNativeInfo();
  }
  
  @override
  NativeEventParams buildParams(val) {
    // TODO: implement buildParams
    NativeEventParams r = val is Map ? NativeEventParams.fromJson(Map<String, dynamic>.from(val)) : NativeEventParams(id: event);
    return r;
  }

  _mergeNativeInfo() {
    if (isVaild) {
      Map<String, dynamic> temp = {
        "zc_eventIndex": event?.index,
        "zc_eventName": describeEnum(event),
        "zc_eventDate": DateTime.now().toIso8601String(),
        "zc_appName": platformUtil.platformData.appName,
        "zc_version": platformUtil.platformData.version,
        "zc_buildNumber": platformUtil.platformData.buildNumber,
      };
      source.addAll(temp);
      origin.addAll(temp);
    }
  }
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    Map<String, dynamic> su = super.toJson();
    su['event'] = su['zc_eventName'];
    return su;
  }
}

class NativeEventParams extends BaseEventParams {
  NativeEventParams({id,}): super(id: id);
  NativeEventParams.fromJson(Map<String, dynamic> json): super.fromJson(json);
  
}