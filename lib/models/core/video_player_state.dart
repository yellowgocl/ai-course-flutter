import 'package:course/models/base_data.dart';
import 'package:flutter/widgets.dart';

class VideoPlayerState extends BaseData with ChangeNotifier {
  VideoPlayerState({id, bool isPaused:false}): super(id: id) {
    this.isPaused = isPaused;
  }
  VideoPlayerState.fromJson(Map<String, dynamic> json)
    :assert(json != null), super.fromJson(json);

  bool get isPaused{
    return get<bool>('isPaused', false);
  }
  set isPaused(bool val) {
    set('isPaused', val);
    notifyListeners();
  }
}