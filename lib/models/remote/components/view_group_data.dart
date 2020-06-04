import 'package:course/component/viewGroup.dart';
import 'package:course/models/factory/widget_builder.dart' as Lib;
import 'package:course/models/remote/components/decoration_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/models/remote/components/widget_option_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

enum LayoutType{
  constraint, row, column, position
}

class ViewGroupData<O extends ViewGroupOptionData> extends WidgetData<O> {
  ViewGroupData(Map<String, dynamic> data) : super(data);

  @override
  O parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? ViewGroupOptionData(option) : null;
  }

  bool addChild(child) {
    bool result = false;
    if (child is Map) {
      var c = Lib.WidgetBuilder.build(child);
      if (c != null) 
        children.add(c);
      result = true;
    } else if (child is WidgetData) {
      children.add(child);
      result = true;
    }
    return result;
  }

  List<WidgetData> get children{
    List temp = get('children', []);
    List<WidgetData> r = [];
    if (temp.length > 0) {
      temp.forEach((child) {
        WidgetData widgetData = Lib.WidgetBuilder.build(child);
        if (widgetData != null )
          r.add(widgetData);
      });
    }
    return r;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return ViewGroup(data: this,);
  }

}

class ViewGroupOptionData extends WidgetOptionData {
  ViewGroupOptionData(Map<String, Object> data) : super.fromJson(data);
  ViewGroupOptionData.fromJson(Map<String, dynamic> data) : super.fromJson(data);

  AlignmentGeometry get alignmentSelf{
    return CommonUtil.getAlignment(get("alignmentSelf", null), false);
  }
  set alignmentSelf(AlignmentGeometry val) {
    set('alignmentSelf', val);
  }
  MainAxisAlignment get mainAxisAlignment{
    return CommonUtil.getMainAxisAlignment(get('mainAxisAlignment', null));
  }
  set mainAxisAlignment(MainAxisAlignment val) {
    set('mainAxisAlignment', val);
  }

  CrossAxisAlignment get crossAxisAlignment{
    return CommonUtil.getCrossAxisAlignment(get('crossAxisAlignment', null));
  }
  set crossAxisAlignment(CrossAxisAlignment val) {
    set('crossAxisAlignment', val);
  }

  set layout(LayoutType val) {
    set('layout', val);
  }
  LayoutType get layout{
    var r = get('layout', LayoutType.constraint);
    if (r is LayoutType) {
      return r;
    }
    LayoutType result = LayoutType.constraint;
    if (r is int && r >= 0 && r < LayoutType.values.length) {
      result = LayoutType.values[r];
    } else if (r is String) {
      if (r == 'row') result = LayoutType.row;
      else if (r == 'column') result = LayoutType.column;
      else if (r == 'position') result = LayoutType.position;
    }
    if (result is LayoutType)
      this.layout = result;
    return result;
  }

}