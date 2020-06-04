import 'package:course/component/screen.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/widgets.dart';

class ScreenData extends ViewGroupData {
  ScreenData(Map<String, dynamic> data) : super(data);

  @override
  ScreenOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? ScreenOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return Screen(data: this);
  }
}

class ScreenOptionData extends ViewGroupOptionData {
  ScreenOptionData(Map<String, Object> data) : super(data){
    transformConversionType = TransformConversionType.absolute;
    size = Size(ScreenUtil.screenWidth, ScreenUtil.screenHeight );
  }
}