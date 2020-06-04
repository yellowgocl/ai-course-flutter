import 'package:course/models/event/base_event.dart';
import 'package:course/utils/audioPlayerUtil.dart';
import 'package:course/utils/commonUtil.dart';

class AudioEvent extends BaseEvent<AudioEventParams>{
  AudioEvent({id, event, AudioEventParams params}): super(id: id, event: event, params: params);
  AudioEvent.fromJson(Map<String, dynamic> json): super.fromJson(json);
  
  @override
  AudioEventParams buildParams(val) {
    // TODO: implement buildParams
    return val is Map ? AudioEventParams.fromJson(val) : AudioEventParams(id: event);
  }
}
class AudioEventParams extends BaseEventParams {
  AudioEventParams.fromJson(Map<String, dynamic> json, { id }): super.fromJson(json, id:id);
  AudioEventParams({id, Duration duration, String src, AudioPoolType poolType}): super(id: id) {
    this.duration = duration;
    this.src = src;
    this.poolType = poolType;
  }

  String get src{
    return get<String>('src', null);
  }
  set src(String src) {
    set('src', src);
  }
  Duration get duration{
    return CommonUtil.getDuration(get('duration', null));
  }
  set duration(Duration val) {
    set('duration', val);
  }
  AudioPoolType get poolType {
    var r = get('poolType', null);
    if (r is AudioPoolType) {
      return r;
    }
    AudioPoolType result;
    if (r is String && r == 'asset') {
      result = AudioPoolType.asset;
    } else if (r is String && r == 'voice') {
      result = AudioPoolType.voice;
    } else if (r is String && r == 'background') {
      result = AudioPoolType.background;
    } else if (r is String && r == 'effects') {
      result = AudioPoolType.effects;
    }
    return result;
  }
  set poolType (AudioPoolType val) {
    set('poolType', val);
  }
}