import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/flare_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'baseComponent.dart';

class Flare extends StatefulWidget {
  final Size size;
  final String name;
  final String src, animation, artboard;
  final Function(String animation) callback;
  final AssetType assetType;
  final bool sizeFromArtboard, shouldClip, isPaused, snapToEnd;
  final AlignmentGeometry alignment;
  final BoxFit fit;
  Flare({@required this.src, this.name, @required this.animation, this.size, this.isPaused: false, this.snapToEnd: false, this.artboard, this.fit, this.alignment, this.callback, this.assetType, this.sizeFromArtboard: true, this.shouldClip: true});
  @override
  _FlareState createState() => _FlareState();
}

class _FlareState extends State<Flare> {

  FlareControls _controls;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controls = FlareControls();
    // _controls.play('idle');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didUpdateWidget(Flare oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // if (widget.animation.indexOf('star') >= 0) {
    //   print('cur: ${widget.animation}, old: ${oldWidget.animation}');
    // }
    // print('cur: ${widget.animation}, old: ${oldWidget.animation}');
    if (widget.animation != oldWidget.animation) {
      Future.delayed(Duration(milliseconds: 100), () {
        _controls?.play(widget.animation);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return FlareCacheBuilder(
      [AssetFlare(bundle: rootBundle, name: widget.src)],
      builder: (BuildContext context, bool isWarm) {
        return Container(
          width: widget.size?.width,
          height: widget.size?.height,
          child:
            !isWarm
          ? Center(child: SizedBox(width: ScreenUtil.to(60), height: ScreenUtil.to(60), child: CircularProgressIndicator()))
          : FlareActor(
              widget.src,
              fit: widget.fit,
              isPaused: widget.isPaused,
              snapToEnd: widget.snapToEnd,
              artboard: widget.artboard,
              sizeFromArtboard: widget.sizeFromArtboard,
              shouldClip: widget.shouldClip,
              alignment: widget.alignment??Alignment.center,
              animation: widget.animation,
              controller: _controls,
              callback: widget.callback)
          ,
        );
      },
    );
    // return Container(
    //       width: widget.size?.width,
    //       height: widget.size?.height,
    //       child: FlareActor(
    //           widget.src,
    //           fit: widget.fit,
    //           isPaused: widget.isPaused,
    //           snapToEnd: widget.snapToEnd,
    //           artboard: widget.artboard,
    //           sizeFromArtboard: widget.sizeFromArtboard,
    //           shouldClip: widget.shouldClip,
    //           alignment: widget.alignment,
    //           animation: widget.animation,
    //           controller: _controls,
    //           callback: widget.callback)
    //       ,
    //     );
  }
}

class FlareWrapper extends StatefulBaseComponent<FlareData> {
  FlareWrapper({Key key, FlareData data, }): super(key: key, data: data);
  @override
  State<StatefulWidget> createState() => FlareWrapperState();
}

class FlareWrapperState extends StatefulBaseComponentState<FlareWrapper> {
  FlareOptionData get option{
    return getOption();
  }
  @override
  void didUpdateWidget(FlareWrapper oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flare(
      size: option?.size,
      src: option?.src,
      name: widget?.data?.name,
      animation: option?.animation,
      snapToEnd: option?.snapToEnd,
      shouldClip: option?.shouldClip,
      artboard: option?.artboard,
      alignment: option?.alignment,
      isPaused: option?.isPaused,
      sizeFromArtboard: option?.sizeFormArtboard,
      fit: option?.boxFit,
      callback: _onCallback,
    );
  }
  _onCallback(String animation) {
    debugPrint('flare callback: $animation');
  }
}
