import 'package:course/component/actor.dart';
import 'package:course/component/text.dart' as Lib;
import 'package:course/models/remote/block_data.dart';
import 'package:course/models/remote/components/text_data.dart';
import 'package:course/utils/audioPlayerUtil.dart';
import 'package:course/utils/themeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBlockView extends StatefulWidget {
  final BlockData data;
  final bool isVisible;
  GameBlockView({Key key, this.data, this.isVisible}): super(key: key);
  @override
  _GameBlockViewState createState() => _GameBlockViewState();
}

class _GameBlockViewState extends State<GameBlockView> {
  @override
  void didUpdateWidget (GameBlockView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible && !oldWidget.isVisible) {
      AudioPlayerUtil(widget.data.audio, isLocal: false)..play();
    }
    
  }
  Widget buildContent() {
    return widget.data?.screen?.build(context) ?? Center(child: Text("无数据."),);
  }
  Widget buildActor() {
    return Container(
      alignment: Alignment.bottomRight,
      child:Actor()
    );
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      buildContent(),
    ];
    if (widget?.data?.isQuestion??false) {
      children.add(buildActor());
    }
    return Stack(
      children: children,
    );
  }
}