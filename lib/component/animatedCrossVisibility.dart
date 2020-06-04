import 'package:flutter/widgets.dart';

enum CrossStateRule{
  forward, reverse,
}

class AnimatedCrossVisibility extends StatefulWidget {
  final Duration duration;
  final bool visible, autoIgnorePointer;
  final Widget firstChild;
  final Widget secondChild;
  final CrossStateRule crossStateRule;
  AnimatedCrossVisibility({Key key, @required this.firstChild, @required this.secondChild, @required this.visible, this.crossStateRule = CrossStateRule.forward, this.autoIgnorePointer, this.duration}): super(key: key);
  @override
  _AnimatedCrossFadeState createState() => _AnimatedCrossFadeState();
}

class _AnimatedCrossFadeState extends State<AnimatedCrossVisibility> {
  Duration get duration{
    return widget.duration??Duration(milliseconds: 200);
  }
  bool get visible{
    return widget.visible??false;
  }
  bool get autoIgnorePointer{
    return widget.autoIgnorePointer??true;
  }
  CrossFadeState get crossFadeState{
    CrossFadeState visibleState = widget.crossStateRule == CrossStateRule.forward ? CrossFadeState.showSecond : CrossFadeState.showFirst;
    CrossFadeState hiddenState = widget.crossStateRule == CrossStateRule.forward ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    return visible ? visibleState : hiddenState;
  }
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: autoIgnorePointer ? !visible : false,  
      child: AnimatedCrossFade(
        duration: duration,
        crossFadeState: crossFadeState,
        firstChild: widget.firstChild,
        secondChild: widget.secondChild,
      )
    );
  }
}