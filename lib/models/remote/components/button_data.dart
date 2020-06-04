import 'package:course/component/button.dart';
import 'package:course/models/common/tween_data.dart';
import 'package:course/models/event/action_event.dart';
import 'package:course/models/factory/widget_builder.dart';
import 'package:course/models/factory/widget_builder.dart' as prefix0;
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class ButtonData extends ViewGroupData {
  ButtonData(Map<String, dynamic> data) : super(data);
  @override
  ButtonOptionData get option => super.option;
  
  @override
  ButtonOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? ButtonOptionData(option) : null;
  }
  @override
  Widget build([context]) {
    // TODO: implement build

    return ButtonWrapper(data: this..update(template),);
  }
}

class ButtonOptionData extends ViewGroupOptionData {
  ButtonOptionData(Map<String, Object> data) : super(data);
  TweenData get hint{
    return CommonUtil.getButtonTween(get('hint', null));
  }
  set hint(TweenData val) {
    set('hint', val);
  }

  bool get enabledHint{
    return get('hint', null) != null;
  }

  ActionEvent get action{
    return CommonUtil.getActionEvent(get('action', null));
  }
  String get sound {
    return get<String>('sound', null);
  }
  set sound (String val){
    set('sound', val);
  }
  bool get isSwitch{
    return get<bool>('isSwitch', false);
  }
  set isSwitch(bool val) {
    set('isSwitch', val);
  }
  bool get selected{
    return get<bool>('selected', false);
  }
  set selected(bool val) {
    set('selected', val);
  }
  WidgetData get selectedWidget {
    return CommonUtil.getWidget(get('selectedWidget'));
  }
}