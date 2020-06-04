import 'package:course/config/config_data.dart';

const Map<String, dynamic> dev = {
  "apiHost": "http://dev.cloud.zhibankeji.com",
  "aiHost": "http://47.106.80.82:9005",
  "oms": "http://dev.cloud.zhibankeji.com/api/v3",
  "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJqd3QiLCJpYXQiOjE1ODE2ODc3MzEsInN1YiI6IntcInVpZFwiOlwiMjcxNDVhNDE3NzVmN2NjMzQzZGNmNTE0ZWI1MjczOTBcIixcInBob25lTnVtXCI6XCIxODkyMjc0MTI1MlwiLFwiaWRcIjoxNDg5OTI3fSIsImV4cCI6MTU4MjU1MTczMX0.KEgVpAHzna6c16-kXNhv5-mahF3PJ5phwoOIkBIEaY8",
  "appId": "10000",
  "courseId": "1",
  "userId": "234",
  "deviceId": "0896E1BA-944C-4A6F-B72B-6EDC68A85FAD",
  "reportUrl": "http://dev.web.payment.zhibankeji.com/index.html#/report/course/"
};

const Map<String, dynamic> prod = {
  "apiHost": "http://cloud.zhibankeji.com",
  "aiHost": "http://47.106.80.82:9005",
  "oms": "http://cloud.zhibankeji.com/api/v3",
  "reportUrl": "https://pay.ziboot.com/#/report/course"
};

enum Env {
  prod,
  dev,
}

class Environment {
  static Env env = Env.prod;
  static ConfigData _configData;


  static ConfigData get config {
    if (_configData != null) {
      return _configData;
    }
    ConfigData result;
    switch (env) {
      case Env.prod:
        result = ConfigData.fromJson(prod);
        break;
      case Env.dev:
        result = ConfigData.fromJson(dev);
        break;
      default:
        result = ConfigData.fromJson(prod);
    }
    if (_configData == null) {
      _configData = result;
    }
    return result;
  }
}