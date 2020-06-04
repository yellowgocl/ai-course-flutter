import 'package:course/models/base_data.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/decoration_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetOptionData extends BaseData {
  WidgetOptionData(Map<String, dynamic> data): super.fromJson(data);
  WidgetOptionData.fromJson(Map<String, dynamic> data) : super.fromJson(data);
  
  /**
   *  约束布局内的位置约束定义
   *   8    1    2
   *    \   |   /
   * 
   *   7——  9  ——3
   * 
   *    /   |   \
   *   6    5    4
   */
  AlignmentGeometry get alignment{
    var r = get('alignment', 9);
    return CommonUtil.getAlignment(r);
  }

  EdgeInsets get padding{
    var p = get('padding', null);
    return CommonUtil.getPadding(p);
  }

  set size(Size val) {
    set('size', val);
  }
  Size get size{
    var r = get('size', null);
    Size result = CommonUtil.getSize(r);
    if (result!=null && transformConversionType == TransformConversionType.viewport) {
      result = Size(ScreenUtil.to(result.width), ScreenUtil.to(result.height));
    }
    return result;
  }
  set transformConversionType(TransformConversionType val) {
    set('transformConversionType', val);
  }
  TransformConversionType get transformConversionType {
    return CommonUtil.getTransformConversionType(get('transformConversionType', null));
  }
  int get flex{
    return get<int>('flex', 0);
  }
  DecorationData get decoration{
    return CommonUtil.getDecorationData(get('decoration'));
  }

  Constraints get constraints{
    return CommonUtil.getConstraints(get('constraints'));
  }

}