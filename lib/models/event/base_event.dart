import 'package:course/models/base_data.dart';
import 'package:course/models/builder_data.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:flutter/foundation.dart';

/**
 * {
 *    "event": "",
 *    "params": {}
 * }
 */

abstract class BaseEvent<T extends BaseEventParams> extends BaseData {
  BaseEvent({id, event, params}): super(id: id) {
    this.event = EventUtil.getEvent(event);
    this.params = params;
  }
  BaseEvent.fromJson(Map<String, dynamic> json): super.fromJson(json){
    if (!(get('event', null) is Events)) {
      set('event', EventUtil.getEvent(get('event', null)));
    }
    this.params = buildParams(get('params', null));
  }
  set event(Events val) {
    set('event', val);
  }
  Events get event{
    return EventUtil.getEvent(get('event', null));
  }
  T get params {
    var r = get('params', null);
    if (r is T) {
      return r;
    }
    return buildParams(r);
  }
  set params (val) {
    if (val is T) {
      set("params", val);
    } else {
      set("params", buildParams(val));
    }
  }
  bool get isVaild{
    return event != null;
  }

  T buildParams(val) {
    if (val is T) {
      return val;
    }
    BaseEventParams result = BaseEventParams(id: event);
    if (val is Map<String, dynamic>) {
      result = BaseEventParams.fromJson(val, id: event) as T;
    }
    return result;
  }
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    var su = super.toJson();
    su['params'] = params?.toJson()??null;
    return su;
  }
}

class BaseEventParams extends BaseData {
  BaseEventParams.fromJson(Map<String, dynamic> json, { id }): super.fromJson(json){
    this.id = id;
  }
  BaseEventParams({id}): super(id: id);
  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    var su = super.toJson();
    if (id is Events) {
      su['id'] = describeEnum(id);
    }
    return su;
  }
}