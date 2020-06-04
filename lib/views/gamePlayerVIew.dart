
import 'package:course/component/videoPlayer.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/core/video_player_state.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/block_data.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GamePlayerView extends StatefulWidget {
  final String src;
  final BlockData blockData;
  final Function(BlockData blockData) onInterrupt;
  GamePlayerView({key, this.src, this.blockData, this.onInterrupt}): super(key: key);
  @override
  _GamePlayerViewState createState() => _GamePlayerViewState();
}

class _GamePlayerViewState extends State<GamePlayerView> {
  // bool flag = false;
  @override
  void didUpdateWidget(GamePlayerView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.blockData != oldWidget.blockData) {

      Future.microtask(() {
        Provider.of<VideoPlayerState>(context, listen: false).isPaused = false;
        // setState(() {});
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerState>(
      builder: (BuildContext context, VideoPlayerState videoState, _) {
        return  Center(
          child: VideoPlayer(
          src: widget?.src, 
          onProgress: onProgress,
          position: gameController.currentStartPoint,
          paused: videoState.isPaused,
          assetType: AssetType.network,)
        );
      }
    );
  }
  String get src{
    return widget?.src;
  }
  int get marker{
    return widget.blockData?.start?.inMilliseconds;
  }
  
  onProgress(Duration progress) {
    int progressValue = progress.inMilliseconds;
    if (!Provider.of<VideoPlayerState>(context, listen: false).isPaused && progressValue >= marker) {
      if (widget.onInterrupt != null) {
        widget?.onInterrupt(widget.blockData);
      }
      Provider.of<VideoPlayerState>(context, listen: false).isPaused = true;
      Provider.of<GameController>(context, listen: false).state = GameState.interrupting;
      setState(() {});
    }
    // if (widget.onProgress != null) {
    //   widget?.onProgress(player, progress);
    // }
  }
}