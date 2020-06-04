import 'package:course/component/image.dart' as Lib;
import 'package:course/models/factory/widget_builder.dart';
import 'package:course/models/remote/components/asset_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class ImageData extends AssetData<ImageOptionData> {
  ImageData(Map<String, dynamic> data) : super(data);

  @override
  ImageOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? ImageOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return template?.type == WidgetType.image ? template?.build(context) : Lib.ImageWrapper(data: this,);
  }
}

class ImageOptionData extends AssetOptionData {
  ImageOptionData(Map<String, Object> data) : super(data);

  Rect get centerSlice{
    return CommonUtil.getRect(get('centerSlice'));
  }
  set centerSlice(Rect val) {
    set('centerSlice', val);
  }
}