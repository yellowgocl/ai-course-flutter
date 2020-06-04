import 'package:course/models/event/base_event.dart';

class VideoEvent extends BaseEvent<VideoEventParams>{
  VideoEvent({event, VideoEventParams params}): super(event: event, params: params);
  VideoEvent.fromJson(Map<String, dynamic> json): super.fromJson(json);
  
  @override
  VideoEventParams buildParams(val) {
    // TODO: implement buildParams
    return val is Map ? VideoEventParams.fromJson(val) : VideoEventParams(id: event);
  }
}

class VideoEventParams extends BaseEventParams {
  VideoEventParams({id,}): super(id: id);
  VideoEventParams.fromJson(Map<String, dynamic> json): super.fromJson(json);
}