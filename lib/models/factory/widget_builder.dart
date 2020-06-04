

import 'package:course/models/remote/components/background_data.dart';
import 'package:course/models/remote/components/button_data.dart';
import 'package:course/models/remote/components/dialog_dart.dart';
import 'package:course/models/remote/components/flare_data.dart';
import 'package:course/models/remote/components/image_data.dart';
import 'package:course/models/remote/components/record_button_data.dart';
import 'package:course/models/remote/components/report_data.dart';
import 'package:course/models/remote/components/screen_data.dart';
import 'package:course/models/remote/components/text_data.dart';
import 'package:course/models/remote/components/video_data.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:flutter/foundation.dart';

enum WidgetType{
  screen,
  image,
  text,
  viewGroup,
  title,
  questionType,
  button,
  flare,
  video,
  dialog,
  recordButton,
  question,
  report
}

class WidgetBuilder{
  static WidgetType getType({int index, String name}) {
    WidgetType result;
    if (name != null && name.length > 0) {
      for (WidgetType item in WidgetType.values) {
        result = name == describeEnum(item) ? item : null;
        if (result != null) break;
      }
    }
    int t = index;
    if (t != null && t >= 0 && t < WidgetType.values.length) {
      result = WidgetType.values[t];
    }
    return result;
  }
  static WidgetData build(Map<String, dynamic> data) {
    var typeName = CollectionUtil.get(data, key: 'type');
    WidgetType type = typeName is String ? getType(name: typeName,) : getType(index: typeName);
    return type != null && _map.containsKey(type) ? _map[type](data) : null;
  }
  static Map<WidgetType, WidgetData Function(Map data)> _map = {
    WidgetType.screen: (Map data) => ScreenData(data),
    WidgetType.image: (Map data) => ImageData(data),
    WidgetType.text: (Map data) => TextData(data),
    WidgetType.viewGroup: (Map data) => ViewGroupData(data),
    WidgetType.button: (Map data) => ButtonData(data),
    WidgetType.flare: (Map data) => FlareData(data),
    WidgetType.video: (Map data) => VideoData(data),
    WidgetType.dialog: (Map data) => DialogData(data),
    WidgetType.question: (Map data) => TextData(data),
    WidgetType.questionType: (Map data) => TextData(data),
    WidgetType.recordButton: (Map data) => RecordButtonData(data),
    WidgetType.report: (Map data) => ReportData(data),
  };
}