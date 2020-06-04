import 'package:course/models/remote/components/image_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:flutter/src/widgets/framework.dart';

class BackgroundData extends WidgetData<BackgroundOptionData> {
  BackgroundData(Map<String, dynamic> data) : super(data);

  @override
  BackgroundOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? BackgroundOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return null;
  }
}

class BackgroundOptionData extends ImageOptionData {
  BackgroundOptionData(Map<String, Object> data) : super(data);
}