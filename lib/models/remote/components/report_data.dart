import 'package:course/component/report.dart';
import 'package:course/component/screen.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/widgets.dart';

class ReportData extends ViewGroupData {
  ReportData(Map<String, dynamic> data) : super(data);

  @override
  ReportOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? ReportOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return Report();
  }
}

class ReportOptionData extends ViewGroupOptionData {
  ReportOptionData(Map<String, Object> data) : super(data);
}