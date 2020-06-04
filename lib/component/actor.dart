import 'package:course/component/button.dart';
import 'package:course/component/flare.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/widgets.dart';

class Actor extends StatefulWidget {
  final String animation;
  Actor({Key key, this.animation}): super(key: key);
  @override
  _ActorState createState() => _ActorState();
}

class _ActorState extends State<Actor> {
  String animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = widget.animation ?? 'idle';
  }

  @override
  Widget build(BuildContext context) {
    return Button(   
      alignment: Alignment.bottomRight, 
      sound: gameController?.currentBlock?.audio,
      isLocalSound: false,
      child: Flare(        
        src: "assets/res/course_actor.flr",
        assetType: AssetType.assets,
        animation: animation,
        size: Size(ScreenUtil.to(200), ScreenUtil.to(200)),
        fit: BoxFit.contain,
      )
    );
  }
}