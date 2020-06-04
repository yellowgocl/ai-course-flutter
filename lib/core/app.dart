import 'package:course/api/api.dart';
import 'package:course/component/flare.dart';
import 'package:course/core/stage.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/common/course_response_data.dart';
import 'package:course/models/remote/course_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:provider/provider.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/core/gameController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool inited;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inited = false;
    Future.microtask(() =>
      gameController.initialized(context: context).then((v) {
        if (v) {
          setState(() {
            gameController.state = GameState.playing;
            inited = true;
          });
        }
      })
    );
    
  }
  
  @override
  Widget build(BuildContext context) {
    // print('inited::$inited');
    return Consumer<GameController>(
      builder: (BuildContext context, GameController gameController, _) {
        return inited ? buildStage() : buildSplash();
      }
    );
    // return inited ? Stage() : Container(child: Center(child: SizedBox(width: 80, height: 80, child: CircularProgressIndicator(),),));
  }

  Widget buildStage() {
    return Stage();
  }
  Widget buildSplash() {
    return Container(
      color: Color(0xFF67B9E9),
      child: Center(child: Flare(
        src: 'assets/res/course_loading.flr',
        size: Size(188, 188),
        animation: 'idle',
        assetType: AssetType.assets,
        sizeFromArtboard: false,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      )
    ));
  }
}