import 'package:course/models/common/tween_data.dart';
import 'package:flutter/widgets.dart';

class SimpleTween{
  TweenData _data;
  Animation<double> _animation;
  Tween<double> _tween;
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Function(SimpleTween tween) onUpdate;
  Function(AnimationStatus status, SimpleTween tween)onStatusUpdate;

  var vsync;

  SimpleTween({@required TweenData data, this.onUpdate, this.onStatusUpdate, this.vsync}) {
    _data = data;
    this.initialize();
  }

  TweenData get data{
    return _data;
  }
  AnimationController get controller{
    return _controller;
  }
  CurvedAnimation get curvedAnimation{
    return _curvedAnimation;
  }
  Animation<double> get animation{
    return _animation;
  }

  void initialize() {
    _tween= Tween<double>(begin: data.begin, end: data?.end);
    _controller= AnimationController(vsync: vsync, duration: data?.duration);
    _curvedAnimation = CurvedAnimation(curve: data?.curve, reverseCurve: data?.reverseCurve, parent: _controller);
    _animation = _tween.animate(_curvedAnimation);
    _animation.addListener(_onUpdate);
    _animation.addStatusListener(_onStatusUpdate);
  }

  void forward() {
    controller?.forward();
  }
  void reverse() {
    controller?.reverse();
  }

  double get value{
    return animation?.value;
  }

  bool get isCompleted {
    return controller?.isCompleted;
  }
  bool get isAnimating {
    return controller?.isAnimating;
  }
  bool get isDismissed {
    return controller?.isDismissed;
  }

  void dispose() {
    animation?.removeListener(_onUpdate);
    animation?.removeStatusListener(_onStatusUpdate);
    controller?.removeListener(_onUpdate);
    controller?.removeStatusListener(_onStatusUpdate);
    curvedAnimation?.removeListener(_onUpdate);
    curvedAnimation?.removeStatusListener(_onStatusUpdate);
    controller?.dispose();
  }
  void _onUpdate() {
    if (onUpdate != null) {
      onUpdate(this);
    }
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (onStatusUpdate != null) {
      onStatusUpdate(status, this);
    }
  }
}

class TweenUtil{

  static SimpleTween createTween({ TweenData data, vsync, Curve curve, Curve reverseCurve, Function(SimpleTween tween) onUpdate, Function(AnimationStatus status, SimpleTween tween) onStatusUpdate  }) {
    return SimpleTween(data: data, onStatusUpdate: onStatusUpdate,onUpdate: onUpdate, vsync: vsync);
  }
  static SimpleTween createOpactiyTween({bool fadeIn: true, vsync, Curve curve, Curve reverseCurve, Function(SimpleTween tween) onUpdate, Function(AnimationStatus status, SimpleTween tween) onStatusUpdate }) {
    return SimpleTween(data: TweenData(curve: curve, reverseCurve: reverseCurve, begin: fadeIn ? 0 : 1, end: fadeIn ? 1 : 0), vsync: vsync, onUpdate: onUpdate, onStatusUpdate: onStatusUpdate);
  }
  static SimpleTween createSimpleTween({ double begin: 1, double end: 0.9, vsync, Curve curve, Curve reverseCurve, Function(SimpleTween tween) onUpdate, Function(AnimationStatus status, SimpleTween tween) onStatusUpdate }) {
    return SimpleTween(data: TweenData(curve: curve, reverseCurve: reverseCurve, begin: begin, end: end), vsync: vsync, onUpdate: onUpdate, onStatusUpdate: onStatusUpdate);
  }

  static Curve getCurve(val) {
    if (val is Curve) {
      return val;
    }
    Curve result = Curves.linear;
    if (val is String) {
      if (val == 'bounceIn') {
        result = Curves.bounceIn;
      } else if (val == 'bounceOut') {
        result = Curves.bounceOut;
      } else if (val == 'bounceOut') {
        result = Curves.bounceOut;
      } else if (val == 'bounceInOut') {
        result = Curves.bounceInOut;
      } else if (val == 'decelerate') {
        result = Curves.decelerate;
      } else if (val == 'ease') {
        result = Curves.ease;
      } else if (val == 'easeIn') {
        result = Curves.easeIn;
      } else if (val == 'easeInBack') {
        result = Curves.easeInBack;
      } else if (val == 'easeInCirc') {
        result = Curves.easeInCirc;
      } else if (val == 'easeInCubic') {
        result = Curves.easeInCubic;
      } else if (val == 'easeInExpo') {
        result = Curves.easeInExpo;
      } else if (val == 'easeInOut') {
        result = Curves.easeInOut;
      } else if (val == 'easeInOutBack') {
        result = Curves.easeInOutBack;
      } else if (val == 'easeInOutCirc') {
        result = Curves.easeInOutCirc;
      } else if (val == 'easeInOutCubic') {
        result = Curves.easeInOutCubic;
      } else if (val == 'easeInOutExpo') {
        result = Curves.easeInOutExpo;
      } else if (val == 'easeInOutQuad') {
        result = Curves.easeInOutQuad;
      } else if (val == 'easeInOutQuart') {
        result = Curves.easeInOutQuart;
      } else if (val == 'easeInOutSine') {
        result = Curves.easeInOutSine;
      } else if (val == 'easeInQuad') {
        result = Curves.easeInQuad;
      } else if (val == 'easeInQuart') {
        result = Curves.easeInQuart;
      } else if (val == 'easeInQuint') {
        result = Curves.easeInQuint;
      } else if (val == 'easeInSine') {
        result = Curves.easeInSine;
      } else if (val == 'easeInToLinear') {
        result = Curves.easeInToLinear;
      } else if (val == 'easeOut') {
        result = Curves.easeOut;
      } else if (val == 'easeOutBack') {
        result = Curves.easeOutBack;
      } else if (val == 'easeOutCirc') {
        result = Curves.easeOutCirc;
      } else if (val == 'easeOutCubic') {
        result = Curves.easeOutCubic;
      } else if (val == 'easeOutExpo') {
        result = Curves.easeOutExpo;
      } else if (val == 'easeOutQuad') {
        result = Curves.easeOutQuad;
      } else if (val == 'easeOutQuart') {
        result = Curves.easeOutQuart;
      } else if (val == 'easeOutQuint') {
        result = Curves.easeOutQuint;
      } else if (val == 'easeOutSine') {
        result = Curves.easeOutSine;
      } else if (val == 'elasticIn') {
        result = Curves.elasticIn;
      } else if (val == 'elasticInOut') {
        result = Curves.elasticInOut;
      } else if (val == 'elasticOut') {
        result = Curves.elasticOut;
      } else if (val == 'fastLinearToSlowEaseIn') {
        result = Curves.fastLinearToSlowEaseIn;
      } else if (val == 'fastOutSlowIn') {
        result = Curves.fastOutSlowIn;
      } else if (val == 'linearToEaseOut') {
        result = Curves.linearToEaseOut;
      } else if (val == 'slowMiddle') {
        result = Curves.slowMiddle;
      } else if (val == 'linear') {
        result = Curves.linear;
      }
    }
    return result;
  }
}