
import 'package:course/component/animatedCrossVisibility.dart';
import 'package:course/component/baseComponent.dart';
import 'package:course/component/viewGroup.dart';
import 'package:course/models/remote/components/dialog_dart.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:flutter/material.dart';

class DialogWrapper extends StatefulBaseComponent<DialogData> {
  final Future<void> delayedFuture;
  DialogWrapper({WidgetData data, this.delayedFuture}): super(data: data);
  @override
  State<StatefulWidget> createState() => DialogWrapperState();
}
class DialogWrapperState extends StatefulBaseComponentState<DialogWrapper> with SingleTickerProviderStateMixin {
  
  
  DialogOptionData get option{
    return getOption();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      delayedFuture: widget.delayedFuture,
      cancelable: option?.cancelable == 0,
      child: Stack(
        fit: StackFit.loose,
        alignment: option?.alignment,
          children: <Widget>[
            ViewGroup(data: widget.data),
          ],
        )
    );
  }
}

class Dialog extends StatefulWidget {
  final Widget child;
  final Future<void> delayedFuture;
  final bool cancelable;
  Dialog({Key key, this.delayedFuture, this.cancelable, @required this.child}): super(key: key);
  @override
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> with WidgetsBindingObserver {
  bool foreground = true;
  bool complete = false;
  void _close() {
    if (mounted && foreground && complete) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.delayedFuture?.whenComplete(() {
      complete = true;
      _close();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    // super.didChangeAppLifecycleState(state);
    foreground = (state == AppLifecycleState.resumed);
    if (foreground && complete) {
      _close();
    }
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CustomDialog extends StatefulWidget {
  final bool visible;
  final bool cancelable;
  final bool slideTransition;
  final Widget child;
  final ValueChanged<bool> onChanged;
  final Function onDissmiss;
  final Function onShown;
  final AlignmentGeometry alignment;
  CustomDialog({Key key, @required this.visible, @required this.child, this.slideTransition = false, this.cancelable, this.alignment, this.onChanged, this.onShown, this.onDissmiss}): super(key: key);
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> with SingleTickerProviderStateMixin {
  bool _visible;
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  bool get cancelable{
    return widget.cancelable ?? true;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _animationController?.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _visible = widget?.visible??false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400)
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.slideTransition ? const Offset(0.0, 0.5) : Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));
  }
  @override
  void didUpdateWidget(CustomDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {_visible = widget.visible??false;});
    !_visible ? _animationController.forward() : _animationController.reverse();
    if (widget.visible != oldWidget.visible) {
      if (_visible && widget.onShown != null) {
        widget.onShown();
      } else if (!_visible && widget.onDissmiss != null) {
        widget.onDissmiss();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onCancel,
      child: AnimatedCrossVisibility(
        visible: _visible,
        firstChild: Container(),
        secondChild: GestureDetector(
          onTap: onTap,
          child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            constraints: BoxConstraints(
              minWidth: ScreenUtil.screenWidth,
              minHeight: ScreenUtil.screenHeight
            ),
            color: Color.fromRGBO(0, 0, 0, 0.4),
            child: widget.child))
        ),
      )
    );
  }
  Future<bool> onCancel() {
    bool result = _visible;
    if (cancelable) {
      setState(() {_visible = false;});
    }
    result = cancelable ? !result : cancelable;
    // print(result);
    return Future.value(result);
  }
  onTap() async{
    if (!cancelable) {
      return false;
    }
    setState(() {_visible = false;});
    if (widget.onChanged != null) {
      widget.onChanged(_visible);
    }
    if (widget.onDissmiss != null) {
      widget.onDissmiss();
    }
  }
}