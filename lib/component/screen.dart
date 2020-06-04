import 'package:course/component/viewGroup.dart';
import 'package:course/models/remote/components/screen_data.dart';
import 'package:flutter/widgets.dart';

import 'baseComponent.dart';

class Screen extends StatefulBaseComponent<ScreenData> {
  Screen({Key key, ScreenData data, }): super(key: key, data: data);
  @override
  State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends StatefulBaseComponentState<Screen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewGroup(data: widget.data,);
  }
}
