import 'package:course/models/event/base_event.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/eventUtil.dart';

class ActionEvent extends BaseEvent<ActionEventParams> {
  ActionEvent({event, params}): super(event: event, params: params);
  ActionEvent.fromJson(Map<String, dynamic> json): super.fromJson(json);

  @override
  ActionEventParams buildParams(val) {
    // TODO: implement buildParams
    return val is Map ? ActionEventParams.fromJson(val) : ActionEventParams(id: event);
  }
}
class ActionEventParams extends BaseEventParams {
  ActionEventParams.fromJson(Map<String, dynamic> json, { id }): super.fromJson(json, id:id);
  ActionEventParams({id}): super(id: id);
}