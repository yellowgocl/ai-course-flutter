import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/common/answer_data.dart';
import 'package:course/models/remote/components/screen_data.dart';
import 'package:course/models/base_data.dart';
import 'package:course/utils/commonUtil.dart';

class BlockData extends BaseData {
  BlockData(Map<String, dynamic> source): super.fromJson(source);
  
  get mode{
    return CommonUtil.getQuestionType(get('type'));
  }
  set mode(QuestionType val) {
    set('type', val);
  }
  int get skip{
    return get<int>('skip', 3);
  }
  set skip(int val) {
    set('skip', val);
  }
  int get index{
    return get<int>('index', -1);
  }
  set index(int val) {
    set('index', val);
  }
  String get description{
    return get<String>('text', null);
  }
  set description(String val) {
    set('text', val);
  }
  String get name{
    return get<String>('text', null);
  }
  set name(String val) {
    set('text', val);
  }
  String get thumb{
    return get<String>('thumb', null);
  }
  set thumb(String val) {
    set('thumb', val);
  }
  get audio{
    return get<String>('audio', null);
  }
  set audio(String val) {
    set('audio', val);
  }
  get video{
    return get<String>('video', null);
  }
  set video(String val) {
    set('video', val);
  }
  set duration(Duration val) {
    set('duration', val);
  }
  Duration get duration {
    return CommonUtil.getDuration(get('duration', null));
  }
  set start(Duration val) {
    set('beginTime', val);
  }
  Duration get start {
    return CommonUtil.getDuration(get('beginTime', null));
  }

  ScreenData get screen{
    var r = get('data', null);
    if (r is ScreenData) {
      return r;
    }
    if (r is Map<String, dynamic>) {
      r = ScreenData(r);
    }
    return r;
  }

  bool get isQuestion {
    return (
      mode == QuestionType.answer ||
      mode == QuestionType.speech || 
      mode == QuestionType.radio || 
      mode == QuestionType.checkbox
    );
  }

  String get feedback{
    String def = 'assets/res/course_answer_rating.flr';
    if ((mode == QuestionType.speech)) {
      def = 'assets/res/course_speech_rating.flr';
    }
    return get('feedback', def);
  }

  List<ConditionsData> get conditions {
    var r = get('conditions', []);
    if (r is List<ConditionsData>) {
      return r;
    }
    
    List<ConditionsData> result = [];
    if (r != null && r.length > 0) {
      r.forEach((b) {
        if (b is Map) {
          result.add(ConditionsData(b));
        }
      }); 
    }
    set('conditionos', result);
    return result;
  }
  List<AnswerData> get answers{
    List<AnswerData> result = [];
    List r = get('answers', []);
    if (r.length > 0) {
      r?.forEach((item) {
        if (item is Map)
          result.add(AnswerData.fromJson(item));
      });
    }else{
      result.add(AnswerData.fromJson(get('answer', null)));
    }
    return result;
  }
  @override
  // TODO: implement id
  get id => super.id??index;
}

class ConditionsData extends BaseData {
  ConditionsData(Map<String, dynamic> source): super.fromJson(source);

  get express {
    return get("express", 0);
  }

  get contextId {
    return get("contextId", 0);
  }

  int get skipValue {
    return get<int>("skipValue", 0);
  }
}