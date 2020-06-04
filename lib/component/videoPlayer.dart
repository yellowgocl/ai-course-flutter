
import 'dart:async';
import 'dart:io';

import 'package:course/component/baseComponent.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/event/video_event.dart';
import 'package:course/models/remote/components/image_data.dart';
import 'package:course/models/remote/components/video_data.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart' as Lib;

class VideoPlayer extends StatefulWidget {
  final String src;
  final AssetType assetType;
  final bool autoplay;
  final double width;
  final double height;
  final bool paused;
  final Duration position;
  final Function(Duration progress) onProgress;
  final Function(Duration duration) onComplete;
  final Function(String errorDescription) onError;
  final Function onInit;
  VideoPlayer({Key key, this.src, this.paused, this.position, this.assetType, this.width, this.height, this.autoplay = true, this.onInit, this.onComplete, this.onError, this.onProgress}): super(key: key);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  StreamSubscription _subscription;
  Lib.VideoPlayerController _controller;
  Duration progress;
  Duration beforeProgress;
  Duration duration;
  bool isEnd = false;
  bool isError = false;  
  bool get inited{
    return _controller?.value?.initialized??false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _subscription = EventUtil.listen<VideoEvent>(_onReceiveHostEvent);
    load();
  }
  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.src != null && widget.src != oldWidget.src) {
      load();
    }
    if (widget.position != null && widget.position != oldWidget.position) {
      seekTo(widget.position);
    }
    widget.paused ? pause() : play();
  }
  void _onReceiveHostEvent(VideoEvent e) {
    if (e.event == Events.VIDEO_REPLAY) {
      seekTo(widget.position);
    }
  }

  Lib.VideoPlayerController _getController() {
    Lib.VideoPlayerController result;
    String src = widget?.src;
    if (src == null || src.length == 0) {
      throw new ArgumentError("不合法的src, value = $src.");
    }
    if (widget?.assetType == AssetType.network) {
      result = Lib.VideoPlayerController.network(src);
    } else if (widget?.assetType == AssetType.assets) {
      result = Lib.VideoPlayerController.asset(src);
    } else if (widget?.assetType == AssetType.file) {
      result = Lib.VideoPlayerController.file(File(src));
    } else {
      throw new ArgumentError("不合法的AssetType, value = ${widget.assetType}.");
    }
    return result;
  }
  void reset() {
    _controller?.dispose();
    beforeProgress = progress;
  }
  Future<void> play({Duration moment}) {
    return ((moment != null) ? seekTo(moment) : _controller?.play())??Future.value();
  }
  Future<void> seekTo(Duration moment) async {
    if (moment == null) {
      return ;
    }
    isEnd = false;
    return await _controller?.seekTo(moment);
  }
  Future<void> resume() {
    if (isEnd || isError || !inited) {
      return Future.value();
    }
    return play(moment: progress);
  }

  Future<void> pause() async {
    return await _controller?.pause();
  }
  
  Future<bool> load({bool force: false}) {
    Lib.VideoPlayerController _controller = _getController();
    if (_controller == null) {
      return Future.value(false);
    }
    reset();
    this._controller = _controller;
    _attachListeners();
    if (widget.autoplay) {
      play();
    }
    return _controller.initialize().then((_){
      seekTo(widget?.position);
      if(widget.onInit != null) {
        widget.onInit();
      }
      setState((){});
      return true;
    });
  }
  void _attachListeners() {
    Lib.VideoPlayerController controller = _controller;
    if (controller != null && !controller.hasListeners) {
      controller.addListener(() {
        setState(() {
          isError = controller.value.hasError;
          if (!isError) {
            progress = controller?.value?.position;
            duration = controller?.value?.duration;
          }
          isEnd = duration?.compareTo(progress) == 0 || duration?.compareTo(progress) == -1;
        });
        if (widget.onProgress != null){
          widget.onProgress(progress);
        }
        if (isEnd) {
          if (widget.onComplete != null) {
            widget.onComplete(duration);
          }
        }
        if (isError && widget.onError != null) {
          widget.onError(controller.value.errorDescription);
        }
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    _subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return inited && !isError ? buildVideoPlayer(context) : buildLoading(context);
  }

  Widget buildLoading(BuildContext context) {
    // return Container(child:Text('wait for player init...'));
    return SizedBox(width: 100, height: 100, child: Center(child: CircularProgressIndicator()));
  }

  Widget buildVideoPlayer(BuildContext context) {
    return Container(
      width: widget?.width,
      height: widget?.height,
      child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Container(            
            alignment: Alignment.center,
            child: Lib.VideoPlayer(_controller)
          ),
      )
    );
  }
}
class VideoPlayerWrapper extends StatefulBaseComponent<VideoData> {

  VideoPlayerWrapper({Key key, VideoData data}): super(key: key, data: data);

  @override
  State<StatefulWidget> createState() => VideoPlayerWrapperState();
}

class VideoPlayerWrapperState extends StatefulBaseComponentState<VideoPlayerWrapper> {
  VideoOptionData get option{
    return getOption();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VideoPlayer(
      src: option?.src, 
      autoplay: option?.autoplay,
      assetType: option?.assetType,
      paused: option?.paused,
      position: option?.position,
      width: option?.size?.width,
      height: option?.size?.height,);
  }
  
}