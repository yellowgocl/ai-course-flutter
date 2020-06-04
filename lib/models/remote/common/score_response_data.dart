import 'package:course/models/remote/response_data.dart';
import 'package:course/utils/commonUtil.dart';

class ScoreResponseData extends ResponseData{
  ScoreResponseData.fromJson(Map<String, dynamic> json): super.fromJson(json);
  double get finalScore {
    double score = 0.0;
    if (status > 0) {
      switch (status) {
        case 20:
          score = 100.0;
          break;
        case 21:
          score = 70.0;
          break;
      }
    } else {
      score = CommonUtil.getDouble(data?.get("final_score"))??0.0;
    }
    return score;
  }
  String get transcript {
    return data?.get<String>("transcript", "");
  }
  String get audioId {
    return data?.get<String>("audioId", "");
  }
  String get mean {
    return data?.get<String>("mean", "");
  }
  int get status {
    return int.parse(data?.get<String>("status", "0"));
  }
}