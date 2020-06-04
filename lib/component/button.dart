import 'package:course/component/viewGroup.dart';
import 'package:course/models/common/tween_data.dart';
import 'package:course/models/event/action_event.dart';
import 'package:course/models/remote/components/button_data.dart';
import 'package:course/utils/audioPlayerUtil.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:course/utils/tweenUtil.dart';
import 'package:flutter/widgets.dart';

import 'baseComponent.dart';
class Button extends StatefulWidget {
  final Function onTapDown;
  final Function onTapUp;
  final ValueChanged<bool> onChanged;
  final bool selected;
  final bool enabled;
  final bool autoHint;
  final bool autoDisable;
  final TweenData hint;
  final Widget child;
  final AlignmentGeometry alignment;
  final Widget selectedChild;
  final Widget pressedChild;
  final Widget enabledChild;
  final String sound;
  final bool isLocalSound;
  // final Duration duration;
  final bool isSwitch;

  Button({Key key, @required this.child, this.hint, this.isLocalSound=true, this.sound, this.pressedChild, this.selectedChild, this.enabledChild, this.alignment, this.onChanged, this.onTapDown, this.onTapUp, this.autoHint = true, this.autoDisable = false, this.enabled = true, this.selected = false, this.isSwitch = false}): super(key: key);
  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button>  with TickerProviderStateMixin {
  bool selected;
  bool isTapDown;
  SimpleTween tween;
  SimpleTween colorFiltersTween;

  bool get enabledPressEeffect{
    return widget?.autoHint;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    tween?.dispose();
    colorFiltersTween?.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(Button oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      selected = widget.selected;
    }
    if (widget.enabled != oldWidget.enabled) {
      _setEnabledState();
    }
  }
  void _setEnabledState() {
    if (colorFiltersTween != null)
      widget.enabled ? colorFiltersTween.reverse() : colorFiltersTween.forward();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selected;
    isTapDown = false;
    if (enabledPressEeffect) {
      tween = widget.hint == null ? 
        TweenUtil.createSimpleTween(vsync: this, onUpdate: _onTweenUpdate) :
        TweenUtil.createTween(vsync: this, data: widget.hint, onUpdate: _onTweenUpdate);
    }
    if (widget.autoDisable)
      colorFiltersTween = TweenUtil.createSimpleTween(begin: 0, end: 0.3, vsync: this, onUpdate: _onTweenUpdate);
    _setEnabledState();
  }
  void _onTweenUpdate(SimpleTween tween){
    setState(() {});
  }
  Widget buildContent(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[Transform.scale(
        alignment: widget.alignment,
        scale: tween?.value??1,
        child: AnimatedCrossFade(
        duration: Duration(milliseconds: 50),
        firstChild: buildFirstChild(context),
        secondChild: buildSelectedChild(context)??buildFirstChild(context),
        crossFadeState: (widget.isSwitch && selected) ? CrossFadeState.showSecond : CrossFadeState.showFirst,)
      )],
    );
  }
  Widget buildSelectedChild(BuildContext context) {
    return widget.selectedChild;
  }
  Widget buildPressedChild(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 100),
      opacity: isTapDown ? 1 : 0,
      child: widget.pressedChild,
    );
  }

  Widget buildFirstChild(BuildContext context) {
    List<Widget> children = <Widget>[widget.child];
    if (widget.pressedChild != null) {
      children.add(buildPressedChild(context));
    }
    Widget content = Stack(
        children: children,
      );
    return widget.autoDisable ?  ColorFiltered(
      colorFilter: ColorFilter.mode(Color.fromRGBO(0, 0, 0, colorFiltersTween?.value), BlendMode.srcATop),
      child: content
    ) : content;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return GestureDetector(
      onTapUp: onTapUp,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      child: buildContent(context)
    );
  }
  void _changePressedStatus() {
    tween?.reverse();
  }
  onTapUp(TapUpDetails details) {
    if (!widget.enabled) {
      return;
    }
    _changePressedStatus();
    bool tempSelected = selected;
    setState(() {
      if (widget.isSwitch)
        selected = !selected;
    });
    if (widget.onTapUp != null) widget.onTapUp(details);
    if (widget.onChanged != null && tempSelected != selected) {
      widget.onChanged(selected);
    }
  }

  onTapCancel() {
    _changePressedStatus();
  }
  onTapDown(TapDownDetails details) {
    if (!widget.enabled) {
      return;
    }
    if (widget.sound != null) {
      AudioPool.play(poolType: AudioPoolType.effects, url: widget.sound, isLocal: widget.isLocalSound);
    }
    tween?.forward();
    if (widget.onTapDown != null) widget.onTapDown(details);
  }
}


class ButtonWrapper extends StatefulBaseComponent<ButtonData> {
  final Function onTapDown;
  final Function onTapUp;
  final ValueChanged<bool> onChanged;
  // final bool selected;
  final bool enabled;
  // final Widget selectedChild;
  // final Widget pressedChild;
  // final Widget enabledChild;
  // final Duration duration;
  // final bool isSwitch;

  ButtonWrapper({Key key, ButtonData data, this.onChanged, this.onTapDown, this.onTapUp, this.enabled = true,}): super(key: key, data: data);
  @override
  State<StatefulWidget> createState() => ButtonWrapperState();
}

class ButtonWrapperState extends StatefulBaseComponentState<ButtonWrapper> with SingleTickerProviderStateMixin {
  ButtonOptionData get option{
    return getOption();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Button(
      selected: option?.selected,
      alignment: option?.alignmentSelf,
      hint: option?.hint,
      onChanged: _onChanged,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      sound: option?.sound,
      isSwitch: option?.isSwitch,
      selectedChild: option?.selectedWidget?.build(context),
      child: ViewGroup(data: widget.data,));
    // return FlatButton(onPressed: (){}, color: Colors.amber, textColor: Colors.black87, child: Text('sfa'),);
  }

  _onTapUp(TapUpDetails details) {
    if (widget.onTapUp != null) {
      widget.onTapUp(details);
    }
    // if (option.action != null) {
    //   EventUtil.fire(option.action);
    // }
    // EventUtil.fire(ActionEvent(event: "ACTION_RECORD", params: { "duration": 1000 }));
  }
  _onTapDown(TapDownDetails details) {
    if (widget.onTapDown != null) {
      widget.onTapDown(details);
    }
  }
  _onChanged(bool isSelected) {
    if (widget.onChanged != null) {
        widget.onChanged(isSelected);
    }
  }
}

// class ButtonState extends StatefulBaseComponentState<Button> with SingleTickerProviderStateMixin {

//   bool selected;
//   SimpleTween tween;
//   ButtonOptionData get option{
//     return getOption();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     tween?.dispose();
//     super.dispose();
//   }
//   @override
//   void didUpdateWidget(Button oldWidget) {
//     // TODO: implement didUpdateWidget
//     super.didUpdateWidget(oldWidget);
//     if (widget.selected != oldWidget.selected) {
//       selected = widget.selected;
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     selected = widget.selected;
//     if (option.enabledPressEeffect) {
//       tween = option.hint == null ? 
//         TweenUtil.createSimpleButtonTween(vsync: this, onUpdate: _onTweenUpdate) :
//         TweenUtil.createTween(vsync: this, data: option.pressEffect, onUpdate: _onTweenUpdate);
//     }
//   }
//   void _onTweenUpdate(SimpleTween tween){
//     setState(() {});
//   }
//   Widget buildContent(BuildContext context) {
//     return Transform.scale(
//       alignment: option.alignmentSelf,
//       scale: tween?.value??1,
//       child: ViewGroup(data: widget.data,),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
    
//     return GestureDetector(
//       onTapUp: onTapUp,
//       onTapDown: onTapDown,
//       onTapCancel: onTapCancel,
//       child: buildContent(context)
//     );
//   }
//   void _changePressedStatus() {
//     tween?.reverse();
//   }
//   onTapUp(TapUpDetails details) {
//     if (!widget.enabled) {
//       return;
//     }
//     _changePressedStatus();
//     setState(() {
//      selected = !selected; 
//     });
//     if (widget.onTapUp != null) widget.onTapUp(details);
//     if (widget.onChanged != null) widget.onChanged(selected);
//   }

//   onTapCancel() {
//     _changePressedStatus();
//   }
//   onTapDown(TapDownDetails details) {
//     if (!widget.enabled) {
//       return;
//     }
//     tween?.forward();
//     if (widget.onTapDown != null) widget.onTapDown(details);
//   }
// }
