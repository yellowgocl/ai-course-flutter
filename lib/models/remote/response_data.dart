import 'package:course/models/base_data.dart';

class ResponseData extends BaseData{
  ResponseData({int code, String message, data}): super() {
    this.code = code;
    this.message = message;
    this.data = data;
  }
  ResponseData.fromJson(Map<String, dynamic> source): super.fromJson(source);

  bool get flag {
    bool r = get<bool>('flag', null);
    return r == null ? code == 200 : r;
  }

  set code(int val) {
    set("code", val);
  }
  int get code{
    return get<int>('code', 9527);
  }

  set message(String val) {
    set('message', val);
  }
  String get message{
    return get<String>('message', 'unknow message');
  }

  set data(BaseData val) {
    set('data', val);
  }
  BaseData get data{
    var r = get('data', null);
    if (r is BaseData) {
      return r;
    }
    return r is Map ? BaseData.fromJson(r) : null;
  }
}