import 'package:course/component/flare.dart';
import 'package:course/models/remote/components/asset_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class FlareData extends AssetData<FlareOptionData> {
  FlareData(Map<String, dynamic> data) : super(data);

  @override
  FlareOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? FlareOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return FlareWrapper(data: this,);
  }
}

class FlareOptionData extends AssetOptionData {
  FlareOptionData(Map<String, Object> data) : super(data);
  bool get isPaused{
    return get<bool>('isPaused', false);
  }
  bool get snapToEnd{
    return get<bool>('snapToEnd', false);
  }
  bool get sizeFormArtboard{
    return get<bool>('sizeFormArtboard', false);
  }
  bool get shouldClip{
    return get<bool>('shouldClip', false);
  }
  String get animation{
    return get<String>('animation', null);
  }
  set animation(String val) {
    set('animation', val);
  }
  String get artboard{
    return get<String>('artboard', null);
  }
  set artboard(String val) {
    set('artboard', val);
  }
}