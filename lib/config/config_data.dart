import 'package:course/models/base_data.dart';

class ConfigData extends BaseData{
  ConfigData({id}): super(id: id);
  ConfigData.fromJson(Map<String, dynamic> source): super.fromJson(source);
  String get reportUrl{
    return get<String>('reportUrl', "https://pay.ziboot.com/#/report/course");
  }
  String get apiHost{
    return get<String>('apiHost', 'http://cloud.zhibankeji.com');
  }
  String get aiHost {
    return get<String>('aiHost', 'http://47.106.80.82:9005');
  }
  String get oms {
    return get<String>('oms', '$apiHost/api/v3');
  }
  String get mms {
    return get<String>('mms', '$apiHost/mms/v1');
  }
  String get course {
    return get<String>('course', '$apiHost/icourse/v1');
  }
  String get accessToken {
    return get<String>('accessToken');
  }
  String get appId {
    return get<String>('appId');
  }
  String get courseId {
    return get<String>('courseId');
  }
  String get deviceId {
    return get<String>('deviceId');
  }
  String get userId {
    return get<String>('userId');
  }
}
