import 'package:course/component/dialog.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/material.dart' as Lib;
import 'package:flutter/widgets.dart';

class DialogData extends ViewGroupData<DialogOptionData> {
  Dialog _cache;
  bool isActived = false;
  DialogData(Map<String, dynamic> data) : super(data){
    isActived = false;
  }

  @override
  DialogOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? DialogOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    Future delayed;
    if (option?.duration != null && option?.cancelable != 2) {
      delayed = Future.delayed(option?.duration);
    }
    DialogWrapper result = DialogWrapper(data:  this, delayedFuture: delayed,);
    return result;
  }
  Future<bool>show(Lib.BuildContext context, [bool isCancel = true]) async {
    if (isActived) {
      if (isCancel) {
        Navigator.of(context).pop(false);
      } else {
        return Future.value(isActived);
      }
    } else {
      isActived = true;
    }
    Future<bool> result = Lib.showDialog<bool>(
      barrierDismissible: (option?.cancelable??0) == 0,
      context: context, 
      builder: (Lib.BuildContext context) => build(context)
    ).then((v) {
      isActived = false;
      return isActived;
    });
    return result;
  }
  dismiss([context]) {
    if (isActived) 
      Navigator.of(context).pop(false);
  }
}

class DialogOptionData extends ViewGroupOptionData {
  DialogOptionData(Map<String, Object> data) : super(data){
    if (size == null)
      size = Size(ScreenUtil.vw(), ScreenUtil.vh());
  }
  int get cancelable{
    return get('cancelable', 0);
  }
  
  Duration get duration{
    return CommonUtil.getDuration(get('duration'));
  }
  set duration(Duration val) {
    set('duration', val);
  }
}