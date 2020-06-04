import 'package:course/models/base_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/tweenUtil.dart';
import 'package:flutter/widgets.dart';

class TweenData extends BaseData{
  TweenData({double begin, double end, Duration duration, Curve curve, Curve reverseCurve}): super(){
    this.begin = begin;
    this.end = end;
    this.duration = duration;
    this.curve = curve;
    this.reverseCurve = reverseCurve??this.curve;
  }
  TweenData.fromJson(Map<String, dynamic> json): super.fromJson(json);

  set begin(double val) {
    set('begin', val);
  }
  double get begin{
    return CommonUtil.getDouble(get('begin', 1));
  }
  set end(double val) {
    set('end', val);
  }
  double get end{
    return CommonUtil.getDouble(get('end', 1));
  }
  Duration get duration{
    return CommonUtil.getDuration(get('duration', null))??Duration(milliseconds: 50);
  }
  set duration(Duration val) {
    set('duration', val);
  }

  Curve get curve{
    return TweenUtil.getCurve(get('curve', null));
  }
  set curve(Curve val) {
    set('curve', val);
  }
  Curve get reverseCurve{
    return TweenUtil.getCurve(get('reverseCurve', null));
  }
  set reverseCurve(Curve val) {
    set('reverseCurve', val);
  }
}