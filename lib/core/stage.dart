import 'dart:async';
// import 'package:course/components/videoPlayer.dart';
import 'package:course/component/dialog.dart' as Lib;
import 'package:course/component/flare.dart';
import 'package:course/component/recordButton.dart';
import 'package:course/component/webView.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/dialog_dart.dart';
import 'package:course/utils/audioPlayerUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:course/views/gameBlockView.dart';
import 'package:course/views/gameLoadingView.dart';
import 'package:course/views/gamePlayerView.dart';
import 'package:course/views/videoControlsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Stage extends StatefulWidget {
  @override
  _StageState createState() => _StageState();
}

class _StageState extends State<Stage> {
  bool paused = false;
  Duration position;
  DialogData videoControls;
  StreamSubscription videoControlsSubscription;
  String url ='https://www.baidu.com';

  // bool showControls;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // showControls = false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          buildVideoPlayer(context),
          buildVideoControls(context),
          buildBlock(context, gameController.state == GameState.interrupting),
          buildRatingDialog(),
          buildLoadingDialog(gameController.showLoading)
          // WebView(url: url, javascriptMode: prefix1.JavascriptMode.unrestricted,),
          // FlatButton(child: Text('sdfadf'), onPressed: () => setState(() {url = 'http://dev.www.zhibankeji.com/about/introduce';}),)
        ]
      )
    );
  }
  
  _onTap() {
    setState(() {
      // showControls = true;
      gameController.showControls = true;
    });
  }
  Widget buildLoadingDialog(bool visible) {
    return GameLoadingView(visible: visible,);
  }
  Widget buildRatingDialog() {
    String animation = gameController?.score?.playId ?? 'idle';
    // if (gameController?.score?.id == 1) {
    //   animation = 'tail';
    // }else if (gameController?.score?.id == 2) {
    //   animation = 'full';
    // }
    // print('${gameController.score}, star-${gameController?.score?.id??0}');
    Widget content = gameController.score != null ? Flare(
          src: gameController?.currentBlock?.feedback,
          size: Size(ScreenUtil.screenWidth, ScreenUtil.screenHeight), 
          fit: BoxFit.cover,
          alignment: Alignment.center,
          animation: animation
        ) : Container();
    return Lib.CustomDialog(
      visible: gameController.score != null,
      cancelable: false,
      child: Center(
        child: content
      ), // ,)),
      onChanged: (bool visibled) {
        Provider.of<GameController>(context, listen: false).score = null;
      },
    );
  }
  Widget buildBlock(BuildContext context, bool visible) {
    return Lib.CustomDialog(
      cancelable: false,
      slideTransition: true,
      visible: gameController.state == GameState.interrupting,
      child: GameBlockView(data: gameController?.currentBlock, isVisible: gameController.state == GameState.interrupting,)
    );
  }
  Widget buildVideoControls(BuildContext context) {
    return VideoControlsView(visible: gameController.showControls,);
  }
  Widget buildVideoPlayer(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        color: Colors.black87,
        child: GamePlayerView(
          src: gameController?.course?.media?.src , 
          blockData: gameController.currentBlock,),
      ),
    );
  }

  
  Widget build1(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Align(heightFactor: 1, widthFactor: 1, 
            child: gameController.getAssetsTemplate('button_positive')?.build(context),
          ),
          // Container(
          //   alignment: Alignment.center,
          //   child: VideoPlayer(assetType: AssetType.assets, src: "assets/media/praise0.mp4", paused: paused, position: position,)
          // ),
          Container(
            alignment: Alignment.center,
            child: RaisedButton(
            onPressed: () {
              // Api.fetchToken().then((TokenData data) {
              //   print(data.token);
              // });
              // paused = !paused;
              // position = Duration(seconds: 40) ;
              // setState(() {
                
              // });
              DialogData dialogData = DialogData(gameController.getAssetsTemplate('nodata').toJson());
              //dialogData.show(context);
              dialogData.show(context).then((onValue) {
                // print(onValue);
              });
              // Toast.show(context, ToastData(text: "teest toast"));
            },
            child: Text('show toast'),)
          )
        ],
      )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    videoControlsSubscription?.cancel();
    super.dispose();
  }
}