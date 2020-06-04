import 'package:course/component/dialog.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:flutter/widgets.dart';

class GameLoadingView extends StatefulWidget {
  final bool visible;
  GameLoadingView({Key key, this.visible = true}): super(key: key);
  @override
  _GameLoadingViewState createState() => _GameLoadingViewState();
}

class _GameLoadingViewState extends State<GameLoadingView> {
  WidgetData widgetData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetData = gameController.getAssetsTemplate("loading_view");
  }
  @override
  Widget build(BuildContext context) {
    
    return CustomDialog(
      cancelable: false,
      visible: widget.visible,
      child: Container(width: 200, height: 200,child:widgetData.build(context)),
    );
  }
}