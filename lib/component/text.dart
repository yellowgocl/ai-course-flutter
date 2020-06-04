import 'package:course/core/gameController.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/text_data.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:course/utils/themeUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:provider/provider.dart';

import 'baseComponent.dart';

class Text extends StatelessWidget {
  final TextOptionData data;
  Text({Key key, @required this.data}): super(key: key);
  Widget build(BuildContext context) {
    return Widgets.Text(
      data?.text??"", 
      style: data?.style??ThemeUtil.getTextStyle(name: 'caption'), 
      strutStyle: data?.strutStyle, 
      textAlign: data?.textAlign,
      textDirection: data?.textDirection,
      locale: data?.locale,
      overflow: data?.overflow,
      maxLines: data?.maxLines,
      semanticsLabel: data?.semanticsLabel,
      textScaleFactor: data?.textScaleFactor,
      textWidthBasis: data?.textWidthBasis,
      softWrap: data?.softWrap,
    );
  }
}

class TextWrapper extends StatelessBaseComponent<TextData>{
  TextWrapper({Key key, TextData data}): super(key: key, data: data);
  TextOptionData get option{
    return getOption();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: <Widget>[
        Container(
          alignment: option?.alignmentSelf,
          constraints: option?.constraints,
          decoration: option?.decoration?.build(),
          width: option?.size?.width,
          height: option?.size?.height,
          padding: option?.padding,
          child: Text(data: data?.option,),
        )
      ],
    );
    // return SizedBox(
    //   width: option?.size?.width,
    //   height: option?.size?.height,
    //   child: Padding(
    //     padding: option?.padding,
    //     child: Text(data: data?.option,),
    // ));
  }
}

class TitleWrapper extends StatefulWidget {
  final TextData data;
  TitleWrapper({Key key, this.data}): super(key: key);
  @override
  _TitleWrapperState createState() => _TitleWrapperState();
}

class _TitleWrapperState extends State<TitleWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (BuildContext context, GameController controller, _) {
        widget?.data?.option?.style = widget?.data?.option?.style ?? ThemeUtil.getTextStyle(name: 'subhead');
        widget?.data?.option?.text = controller?.currentBlock?.name??"";
        return TextWrapper(data: widget.data,);
    });
  }
}
class QuestionWrapper extends StatefulWidget {
  final TextData data;
  QuestionWrapper({Key key, this.data}): super(key: key);
  @override
  _QuestionWrapperState createState() => _QuestionWrapperState();
}

class _QuestionWrapperState extends State<QuestionWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (BuildContext context, GameController controller, _) {
        widget?.data?.option?.style = widget?.data?.option?.style ?? ThemeUtil.getTextStyle(name: 'subhead');
        widget?.data?.option?.text = controller?.currentBlock?.name??"";
        return TextWrapper(data: widget.data,);
    });
  }
}


class QuestionTypeWrapper extends StatefulWidget {
  final TextData data;
  QuestionTypeWrapper({Key key, this.data}): super(key: key);
  @override
  _QuestionTypeWrapperState createState() => _QuestionTypeWrapperState();
}

class _QuestionTypeWrapperState extends State<QuestionTypeWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (BuildContext context, GameController controller, _) {
        widget?.data?.option?.style = widget?.data?.option?.style ?? ThemeUtil.getTextStyle(name: 'body1');
        bool hasText = widget?.data?.option?.text != null && (widget?.data?.option?.text?.length??0) > 0;
        if (!hasText && controller?.currentBlock?.mode == QuestionType.answer) {
          widget?.data?.option?.text = '问答题';
        } else if (!hasText && controller?.currentBlock?.mode == QuestionType.speech) {
          widget?.data?.option?.text = '跟读题';
        }
        // widget?.data?.option?.size = Size(ScreenUtil.to(334), ScreenUtil.to(84));
        return TextWrapper(data: widget.data,);
    });
  }
}


// class Text extends StatefulBaseComponent<TextData> {
//   Text({Key key, TextData data, }): super(key: key, data: data);
//   @override
//   State<StatefulWidget> createState() => TextState(); 
// }

// class TextState extends StatefulBaseComponentState<Text> {

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _theme = option?.style??TextThemeType.caption;
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return null;
//   }

//   TextOptionData get option{
//     return getOption();
//   }

//   TextThemeType _theme;
//   TextStyle get style{
//     TextStyle result = CommonUtil.getTextStyle(_theme);
//     // result.color = 
//     return option?.style??result;
//   }
// }


// class TextStyle extends Widgets.TextStyle {
//   Widgets.Color color;
//   Widgets.FontWeight fontWeight;
//   double fontSize;
//   String fontFamily;

//   TextStyle({
//     @Widgets.required this.color,
//     this.fontWeight: Widgets.FontWeight.normal,
//     this.fontSize: 14,
//     this.fontFamily: 'Montserrat',
//   })  : assert(color != null && fontWeight != null),
//         super(
//           color: color,
//           fontWeight: fontWeight,
//           fontSize: fontSize,
//           fontFamily: fontFamily,
//         );

//   TextStyle.fromJson(Map<String, dynamic> json) {
//     this.color = CommonUtil.getColor(CollectionUtil.get(json, key: 'color', defaultValue: 0));
//     this.fontSize = CollectionUtil.get<double>(json, key: 'fontSize', defaultValue: 14.0);
//     this.fontFamily = CollectionUtil.get<String>(json, key: 'fontFamily', defaultValue: 'Montserrat');
//     this.fontWeight = CommonUtil.getFontWeight(CollectionUtil.get(json, key: 'fontWeight'));
//   }
//   TextStyle.fromStyle(Widgets.TextStyle style) {
//     TextStyle(color: style.color, fontFamily: style.fontFamily, fontSize: style.fontSize, fontWeight: style.fontWeight);
//   }
// }
