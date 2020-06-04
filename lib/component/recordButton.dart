import 'package:course/component/baseComponent.dart';
import 'package:course/component/button.dart';
import 'package:course/config/config.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/common/answer_data.dart';
import 'package:course/models/remote/components/button_data.dart';
import 'package:course/models/remote/components/flare_data.dart';
import 'package:course/models/remote/components/record_button_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/countdownUtil.dart';
import 'package:course/utils/platformUtil.dart';
import 'package:course/utils/recorderUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecordButton extends StatefulWidget {
  final AlignmentGeometry alignment;
  final double width;
  final double height;
  final Duration duration;
  RecordButton({key, this.duration, this.alignment, this.width, this.height}): super(key: key);
  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  CountdownUtil countdown;
  FlareData microphoneData;
  bool selected;
  double countdownValue;
  
  Widget buildMicrophone() {
    return microphoneData.build(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    countdown?.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countdownValue = 100.0;
    selected = false;
    microphoneData = CommonUtil.getWidgetAssetTemplate('microphone_flare');
    countdown = new CountdownUtil(widget.duration, onData: onCountdownData, onDone: onCountdownDone);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment,
      width: widget.width,
      height: widget.height,
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Button(alignment: Alignment.bottomCenter, enabled: !selected, child: microphoneData.build(context), selected: selected, isSwitch: true, hint: CommonUtil.getButtonTween('simple'), onChanged: _onRecord,),
        buildPrceessBar(context),
      ],
    ));
  }

  Widget buildPrceessBar(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Container(height: 14,),
      secondChild: _ProgrssBar(percent: countdownValue, height: 14,),
      crossFadeState: selected??false ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
  onCountdownData(Duration d) {
    setState(() {
      countdownValue = d.inMilliseconds / widget.duration.inMilliseconds * 100;
    });
  }
  onCountdownDone() {
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      updateMicrophoneDataSelected(false);
      gameController.queryNext(Future.microtask(() async {
        AnswerData result;
        // if (Environment.env != Env.dev && platformUtil.platformData.platform == PlatformType.ANDROID) {
        //   await RecorderUtil.stop();
        //   result = gameController.getAnswerData()..answer = await RecorderUtil.getBase64();
        //   await RecorderUtil.delete();
        //   return result;
        // } else {
        //   result = gameController.getAnswerData();
        //   return result;
        // }
        await RecorderUtil.stop();
        result = gameController.getAnswerData()..answer = await RecorderUtil.getBase64();
        await RecorderUtil.delete();
        return result;
        // return gameController.getAnswerData()..answer = "模拟录音提交的Base64格式数据内容.(from 'component/recordButton.dart')";
      }));
    });
  }
  void _onRecord (bool selected) {
    // if (Environment.env != Env.dev && platformUtil.platformData.platform == PlatformType.ANDROID) {
    //   RecorderUtil.start();
    // }
    RecorderUtil.start();
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      selected ? countdown.start() : countdown.stop();
    });
    updateMicrophoneDataSelected(selected);
  }
  void updateMicrophoneDataSelected(bool selected) {
    // microphoneData?.option?.selected = selected;
    this.selected = selected;
    if (selected) {
      countdownValue = 100;
    }
    microphoneData.option.animation = selected ? 'processing' : 'idle';
    setState(() {});
  }
}

/**
 * 录音安排的倒计时进度bar
 */
class _ProgrssBar extends StatefulWidget {
  final double percent;
  final double height;

  _ProgrssBar({Key key, this.percent, this.height: 20}) : super(key: key);

  @override
  _ProgrssBarState createState() => _ProgrssBarState();
}

class _ProgrssBarState extends State<_ProgrssBar> {
  double _borderRadiusValue = 20;
  double width;
  // double height;
  double progress;
  AlignmentGeometry aligment = AlignmentDirectional.center;

  get borderRadius {
    return BorderRadius.circular(_borderRadiusValue);
  }

  get borderColor {
    return null;
  }

  get backgroundColor {
    return Colors.blueGrey;
  }

  get progressColor {
    return Colors.lightBlue;
  }

  get containerPadding {
    return EdgeInsets.all(0);
  }

  get duration {
    return Duration(milliseconds: 50);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        width = constraint.maxWidth;
        progress = width * widget.percent / 100;
        return Container(
          padding: containerPadding,
          decoration: BoxDecoration(borderRadius: borderRadius, color: borderColor ),
          child: Column(children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: widget.height),
              decoration: BoxDecoration(borderRadius: borderRadius, color: backgroundColor ),
              child: Row(
                mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: aligment,
                    children: <Widget>[
                    AnimatedContainer(duration: duration, width: progress, decoration: BoxDecoration(borderRadius: borderRadius, color: progressColor),),
                  ],),
                )
              ],)             
            )],
          )
        );
      },
    );
  }
}

class RecordButtonWrapper extends StatefulBaseComponent<RecordButtonData> {
  RecordButtonWrapper({Key key, RecordButtonData data, }): super(key: key, data: data);
  @override
  State<StatefulWidget> createState() => RecordButtonWrapperState();
}

class RecordButtonWrapperState extends StatefulBaseComponentState<RecordButtonWrapper> {
  RecordButtonOptionData get option{
    return getOption();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RecordButton(
      duration: option?.duration??Duration(milliseconds: 6000),
      width: option?.size?.width,
      height: option?.size?.height,
      alignment: option?.alignment,
    );
  }
}
