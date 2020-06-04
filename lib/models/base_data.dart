import 'package:course/utils/collectionUtil.dart';

class BaseData {
  Map<String, dynamic> _originSource;
  Map<String, dynamic> _source;
  BaseData({id}) {
    _source = { "id": id };
    _originSource = _source;
  }
  BaseData.fromJson(Map<String, dynamic> source) {
    if (source != null && source.isNotEmpty) {
      _source = Map<String, dynamic>.from(source);
    } else {
      _source = {};
    }
    _originSource = source;
  }

  update(source) {
    if (source != null) {
      Map<String, dynamic> temp;
      if (source is Map) {
        temp = Map<String, dynamic>.from(source);
      } else if (source is BaseData) {
        temp = source.toJson();
      }
      if (temp != null && temp.isNotEmpty) {
        this.origin.addAll(temp);
        this.source.addAll(temp);
      }
    }
  }
  set id(val) {
    set("id", val);
  }
  get id{
    return get('id', null);
  }

  get origin{
    return _originSource;
  }

  @override
  String toString() {
    // TODO: implement toString
    String str = super.toString();
    if (_source != null && _source.isNotEmpty) {
      str = '$runtimeType(';
      _source.forEach((k, v) {
        str += '$k: $v, ';
      });
      str += ')';
    }
    return str;
  }

  Map<String, dynamic> toJson() {
    return origin;
  }

  Map<String, dynamic> get source {
    return _source;
  }
  T get<T>(key, [defaultValue]) {
    return CollectionUtil.get(source, key: key, defaultValue: defaultValue);
  }
  bool set<T>(key, value) {
    return CollectionUtil.set(source, key: key, value: value);
  }
}