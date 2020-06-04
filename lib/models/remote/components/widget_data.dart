import 'package:course/models/builder_data.dart';
import 'package:course/models/factory/widget_builder.dart' as Lib;
import 'package:course/models/remote/components/widget_option_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';
abstract class WidgetData<O extends WidgetOptionData> extends BuilderData<Widget> {
  WidgetData(Map<String, dynamic> data): super.fromJson(data);
  set parentId(val) {
    set('parentId', val);
  }
  get parentId{
    return get('parentId', null);
  }

  set order(int val) {
    set('order', val);
  }
  int get order {
    return get<int>('order', 0);
  }
  
  set name(String val) {
    set('name', val);
  }
  String get name{
    return get<String>('name', 'unknow widget');
  }
  
  set type(Lib.WidgetType val) {
    set('type', val);
  }
  Lib.WidgetType get type{
    var r = get('type', null);
    if (r is int) {
      r = Lib.WidgetBuilder.getType(index: r);
      this.type = r;
    } else if (r is String) {
      r = Lib.WidgetBuilder.getType(name: r);
      this.type = r;
    }
    return r is Lib.WidgetType ? r : null;
  }

  WidgetData get template{
    return CommonUtil.getWidgetAssetTemplate(get('template', null));
  }

  O parseOption(option);

  O get option{
    var r = get('option', Map<String, dynamic>.from({}));
    if (!(r is O)) {
      r = parseOption(r);
      this.option = r;
    }
    return r;
  }
  set option(O val) {
    set('option', val);
  }
}