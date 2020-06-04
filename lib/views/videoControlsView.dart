import 'dart:async';
import 'package:course/component/button.dart';
import 'package:course/component/dialog.dart';
import 'package:course/config/config.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/core/video_player_state.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/event/action_event.dart';
import 'package:course/models/event/native_event.dart';
import 'package:course/models/event/video_event.dart';
import 'package:course/models/remote/components/button_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:course/utils/platformUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class VideoControlsView extends StatefulWidget {
  final bool visible;
  VideoControlsView({Key key, this.visible:false}): super(key: key);
  @override
  _VideoControlsViewState createState() => _VideoControlsViewState();
}

class _VideoControlsViewState extends State<VideoControlsView> {
  // SimpleTween tween;
  StreamSubscription actionSubscription;
  ButtonData _playAndPauseButton;
  ButtonData _replayButton;
  ButtonData _quitButton;
  bool _visible;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _visible = widget.visible;
    actionSubscription = EventUtil.listen<ActionEvent>(_onReceiveAction);
    _playAndPauseButton = CommonUtil.getWidgetAssetTemplate('button_video_play');
    _replayButton = CommonUtil.getWidgetAssetTemplate('button_video_replay');
    _quitButton = CommonUtil.getWidgetAssetTemplate('button_video_quit');
  }
  
  @override
  void didUpdateWidget(VideoControlsView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState((){_visible = widget.visible;});
  }
  _onQuit(TapUpDetails details) {
    Provider.of<VideoPlayerState>(context, listen: false).isPaused = true;
    NativeEvent event = NativeEvent(event: Events.CALL_GO_BACK);
    platformUtil.invokeMethod(event);
  }
  _onReplay(TapUpDetails details) {
    // VideoEvent event = VideoEvent(event: Events.VIDEO_REPLAY);
    // EventUtil.fire(event);
    if (Environment.env == Env.dev) {
      Provider.of<VideoPlayerState>(context, listen: false).isPaused = true;
      Provider.of<GameController>(context, listen: false).state = GameState.interrupting;
      Provider.of<GameController>(context, listen: false).currentStartPoint = gameController.currentBlock?.start;
    }
  }
  _onPlayAndPause(bool selected) {
    Provider.of<VideoPlayerState>(context, listen: false).isPaused = selected;
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, GameController gameController, _) {
    _playAndPauseButton.option.selected = gameController.state != GameState.playing && gameController.state != GameState.complete;
    return CustomDialog(
      visible: _visible,
      onChanged: (bool val) {
        _visible = val;
        Provider.of<GameController>(context, listen: false).showControls = val;
      },
      child: Container(
        color: Color.fromRGBO(0, 0, 0, .5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: ButtonWrapper(data: _quitButton, onTapUp: _onQuit,)
            ),
            Expanded(
              flex: 0,
              child: ButtonWrapper(data: _replayButton, onTapUp: _onReplay,)
            ),
            Expanded(
              flex: 0,
              child: ButtonWrapper(data: _playAndPauseButton, onChanged: _onPlayAndPause,)
            ),
          ],
        )
      ),
    );},);
  }
  _onReceiveAction(ActionEvent action) {
    print(action);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}