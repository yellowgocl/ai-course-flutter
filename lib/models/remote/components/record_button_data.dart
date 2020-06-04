import 'package:course/component/recordButton.dart';
import 'package:course/models/remote/components/asset_data.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class RecordButtonData extends AssetData<RecordButtonOptionData>{
  RecordButtonData(Map<String, dynamic> data) : super(data);

  @override
  RecordButtonOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? RecordButtonOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return RecordButtonWrapper(data: this);
  }
}

class RecordButtonOptionData extends AssetOptionData {
  RecordButtonOptionData(Map<String, Object> data) : super(data);
  Duration get duration{
    return CommonUtil.getDuration(get('duration'));
  }
}