import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'baseComponent.dart';

class ViewGroup extends StatefulBaseComponent<ViewGroupData> {
  ViewGroup({Key key, ViewGroupData data}): super(key: key, data: data);
  @override
  State<StatefulWidget> createState() => ViewGroupState();
  
}

class ViewGroupState extends StatefulBaseComponentState<ViewGroup> {
  ViewGroupOptionData get option{
    return getOption();
  }
  List<Widget> buildChildren(BuildContext context) {
    List<Widget> result = [];
    List<WidgetData> childrenData = widget.data.children;
    if (childrenData != null && childrenData.length > 0) {
      childrenData.forEach((WidgetData childData) {
        Widget child = wrapperChildren(context, childData.build(context), childData);
        if (child != null) {
          result.add(child);
        }
      });
    }
    return result;
  }
  Widget wrapperChildren(BuildContext context, Widget child, WidgetData data) {
    Widget result = child;
    if (option?.layout == LayoutType.constraint && child != null) {
      result = Align(
        alignment: data?.option?.alignment,
        child: child,
      );
    } else if (child != null && (option?.layout == LayoutType.column || option?.layout == LayoutType.row)) {
      if (data.option?.flex != null) {
        result = Expanded(
          child: child,
          flex: data.option?.flex??0,
        );
      }
    }
    return result;
  }
  Widget buildContainer(BuildContext context) {
    Widget result;
    if (option?.layout == LayoutType.row) {
      result = Row(
        mainAxisAlignment: option?.mainAxisAlignment,
        crossAxisAlignment: option?.crossAxisAlignment,       
        children: buildChildren(context),
        mainAxisSize: option?.size == null ? MainAxisSize.min : MainAxisSize.max,);
    } else if(option?.layout == LayoutType.column) {
      result = Column(
        mainAxisAlignment: option?.mainAxisAlignment,
        crossAxisAlignment: option?.crossAxisAlignment,
        children: buildChildren(context),
        mainAxisSize: option?.size == null ? MainAxisSize.min : MainAxisSize.max,
      );
    } else {
      Widget c = Stack(
        fit: StackFit.passthrough,
        children: buildChildren(context)
      );
      result = c;
      // result = (option?.size != null && (option?.size?.width??0.0) > 0.0 && (option?.size?.height??0.0) > 0.0) ? c : Wrap(children: <Widget>[c],);
      // result = option?.size == null ? Column( mainAxisSize: MainAxisSize.min, children: <Widget>[ Row( mainAxisSize: MainAxisSize.min, children: <Widget>[c,],)],) : c;
    }
    return result;
  }

  @override
  void didUpdateWidget(ViewGroup oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build    
    
    return Container(
          decoration: option?.decoration?.build(),
          width: option?.size?.width,
          height: option?.size?.height,
          padding: option?.padding,
          child: buildContainer(context),
      );
  }
  
}