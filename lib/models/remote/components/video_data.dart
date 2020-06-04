import 'package:course/component/videoPlayer.dart';
import 'package:course/models/remote/components/asset_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class VideoData extends AssetData<VideoOptionData> {
  VideoData(Map<String, dynamic> data) : super(data);

  @override
  VideoOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? VideoOptionData(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build
    return VideoPlayerWrapper(data: this,);
  }
}

class VideoOptionData extends AssetOptionData {
  VideoOptionData(Map<String, Object> data) : super(data);

  bool get autoplay{
    return get<bool>('autoplay', true);
  }
  set autoplay(bool val) {
    set('autoplay', val);
  }
  Duration get position{
    return CommonUtil.getDuration(get('position', null));
  }
  set position(Duration val) {
    set('position', val);
  }
  bool get paused{
    return get<bool>('paused', false);
  }
  set paused(bool val) {
    set('paused', val);
  }
}