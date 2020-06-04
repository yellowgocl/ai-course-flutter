import 'package:course/models/base_data.dart';

class ScoreData extends BaseData {
  ScoreData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  ScoreData({id, String score, bool pass : false, String playId}): super(id: id) {
    this.pass = pass;
    this.playId = playId;
    this.score = score;
  }
  
  String get score{
    var r = get('score');
    return r is String ? r : r.toString();
  }
  set score(String val) {
    set('score', val);
  }
  bool get pass{
    var r = get<bool>('pass');
    return r;
  }
  set pass(bool val) {
    set('pass', val);
  }
  set playId(String val){
    set("playId", val);
  }
  String get playId{
    var r = get('playId');
    return r is String ? r : r.toString();
  }
}



