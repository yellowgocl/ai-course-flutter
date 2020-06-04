import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/models/remote/components/widget_option_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class AssetData<T extends AssetOptionData> extends WidgetData<T> {
  AssetData(Map<String, dynamic> data) : super(data);
}

class AssetOptionData extends WidgetOptionData {
  AssetOptionData(Map<String, Object> data) : super(data);
  String get src{
    return get<String>('src', null);
  }
  set src(String val) {
    set('src', val);
  }
  set color(Color val) {
    set('color', val);
  }
  Color get color {
    return CommonUtil.getColor(get('color', 0));
  }

  set boxFit(BoxFit val) {
    set('boxFit', val);
  }
  BoxFit get boxFit{
    return CommonUtil.getBoxFit(get('boxFit', null));
  }

  // set size(Size val) {
  //   set('size', val);
  // }
  // Size get size{
  //   return CommonUtil.getSize(get('size', null));
  // }

  set assetType(AssetType val) {
    set('assetType', val);
  }
  AssetType get assetType{
    return CommonUtil.getAssetType(get('assetType', null));
  }
}