import 'package:course/models/base_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class MediaData extends BaseData{
  MediaData({String name, Duration duration, @required String src}):super(){
    this.duration = duration;
    this.name = name;
    this.src = src;
  }
  MediaData.fromJson(Map<String, dynamic> source): super.fromJson(source);

  set name(String val) {
    set('name', val);
  }
  String get name{
    return get<String>('name', null);
  }

  set src(String val) {
    set('src', val);
  }
  String get src{
    return get<String>('src', null);
  }

  set duration(Duration val) {
    set('duration', val);
  }
  Duration get duration {
    var r = get('duration', 0);
    if (!(r is Duration)) {
      r = CommonUtil.getDuration(r);
      this.duration = r;
    }
    return r;
  }
}