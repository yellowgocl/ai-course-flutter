import 'package:course/models/base_data.dart';

abstract class BuilderData<T> extends BaseData{
  T build([context]);
  BuilderData({id}): super(id: id);
  BuilderData.fromJson(Map<String, dynamic> source): super.fromJson(source);
}