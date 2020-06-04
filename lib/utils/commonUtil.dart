import 'dart:convert';
import 'dart:io';

import 'package:course/core/gameController.dart';
import 'package:course/models/base_data.dart';
import 'package:course/models/common/tween_data.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/event/action_event.dart';
import 'package:course/models/factory/widget_builder.dart' as prefix0;
import 'package:course/models/remote/components/decoration_data.dart';
import 'package:course/models/remote/components/decoration_image_option_data.dart';
import 'package:course/models/remote/components/image_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:course/utils/screenUtil.dart';
import 'package:course/utils/themeUtil.dart';
import 'package:course/utils/tweenUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/**
 * 公共通用的工具
 */
class CommonUtil {
  static Future<String> loadAssetsString(String key) async {
    return await rootBundle.loadString(key);
  }
  static Future<Map<String,Object>> loadAssetsJson(String key) async {
    String args = await loadAssetsString(key);
    return jsonDecode(args);
  } 
  static Future<ByteData> loadAssetsByte(String key) async {
    return await rootBundle.load(key);
  }

  static int toHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static Color getColor(c, { Color defaultValue }) {
    if (c is Color) {
      return c;
    }
    Color result = defaultValue;
    if (c is String) {
      result = Color(CommonUtil.toHex(c));
    } else if(c is int) {
      result = Colors.transparent;
    } else if (c is Map) {
      if (c.containsKey('a')) {
        result = Color.fromARGB(
          CollectionUtil.get(c, key: 'a', defaultValue: 0), 
          CollectionUtil.get(c, key: 'r', defaultValue: 0),
          CollectionUtil.get(c, key: 'g', defaultValue: 0),
          CollectionUtil.get(c, key: 'b', defaultValue: 0),);
      } else if (c.containsKey('o')) {
        result = Color.fromRGBO(
          CollectionUtil.get(c, key: 'r', defaultValue: 0), 
          CollectionUtil.get(c, key: 'g', defaultValue: 0),
          CollectionUtil.get(c, key: 'b', defaultValue: 0),
          CollectionUtil.get(c, key: 'o', defaultValue: 0),);
      }
    }
    return result;
  }

  static double getDouble(val) {
    if (val is int || val is double) {
      return (val is int) ? val.toDouble() : val;
    }
    double result;
    if (val is String) {
      switch(val) {
        case 'match_parent':
          result = double.maxFinite;
          break;
        case 'wrap_content':
          result = double.minPositive;
          break;
        default:
          result = double.tryParse(val);
          break;
      }
    }
    return result;
  }

  static Duration getDuration(val) {
    if (val is Duration) {
      return val;
    }
    if (val is int) {
      val = Duration(seconds: val);
    } else if (val is Map) {
      val = Duration(
        days: CollectionUtil.get(val, key: 'days', defaultValue: 0),
        minutes: CollectionUtil.get(val, key: 'minutes', defaultValue: 0),
        milliseconds: CollectionUtil.get(val, key: 'milliseconds', defaultValue: 0),
        microseconds: CollectionUtil.get(val, key: 'microseconds', defaultValue: 0));
    }
    return val;
  }

  static double getPercent(val) {
    if (val is double) {
      return val;
    }
    if (val is String && val.lastIndexOf('%') == val.length - 1) {
      val = val.replaceAll('%', "");
      val = int.tryParse(val);
      if (val != null) {
        return val / 100;
      }
    }
    return null;
  }

  static TransformConversionType getTransformConversionType(val) {
    if (val is TransformConversionType) {
      return val;
    }
    TransformConversionType result = TransformConversionType.viewport;
    if (val is String) {
      if (val == 'absolute') {
        result = TransformConversionType.absolute;
      } else if (val == 'relative') {
        result = TransformConversionType.relative;
      }
    }
    return result;
  }

  static Size getSize(val) {
    if (val is Size) {
      return val;
    }
    Size result;
    if (val is int || val is double || val is String) {
      double s = (val is int) ? val.toDouble() : ScreenUtil.vw(percentage: getPercent(val)??val);
      result = Size(s, s);
    } else if (val is Map) {
      var tw = CollectionUtil.get(val, key: 'width');
      var th = CollectionUtil.get(val, key: 'height');
      var w = getDouble(tw)??ScreenUtil.vw(percentage: getPercent(tw));
      var h = getDouble(th)??ScreenUtil.vh(percentage: getPercent(th));
      if (w != null || h != null) {
        result = Size(w, h);
      }
      // result = Size(w, h);
    }
    return result;
  }

  static BoxFit getBoxFit(val) {
    if (val is BoxFit) {
      return val;
    }
    BoxFit result = BoxFit.none;
    if (val is int && val >= 0 && val < BoxFit.values.length) {
      result = BoxFit.values[val];
    } else if (val is String) {
      switch(val) {
        case "contain":
          result = BoxFit.contain;
          break;
        case 'cover':
          result = BoxFit.cover;
          break;
        case 'fill':
          result = BoxFit.fill;
          break;
        case 'fillHeight':
          result = BoxFit.fitHeight;
          break;
        case 'fillWidth':
          result = BoxFit.fitWidth;
          break;
        case 'scaleDown':
          result = BoxFit.scaleDown;
          break;
      }
    }

    return result;
  }

  static FontWeight getFontWeight(val) {
    if (val is FontWeight) {
      return val;
    }
    FontWeight result = FontWeight.normal;
    if (val is int) {
      val = 'w' + val;
    }
    if (val is String) {
      switch(val) {
        case 'bold':
          result = FontWeight.bold;
          break;
        case 'w100':
          result =  FontWeight.w100;
          break;
        case 'w200':
          result =  FontWeight.w200;
          break;
        case 'w300':
          result =  FontWeight.w300;
          break;
        case 'w400':
          result =  FontWeight.w400;
          break;
        case 'w500':
          result =  FontWeight.w500;
          break;
        case 'w600':
          result =  FontWeight.w600;
          break;
        case 'w700':
          result =  FontWeight.w700;
          break;
        case 'w800':
          result =  FontWeight.w800;
          break;
        case 'w900':
          result =  FontWeight.w900;
          break;
      }
    }
    return result;
  }
  static AssetType getAssetType(val) {
    if (val is AssetType) {
      return val;
    }
    AssetType result = AssetType.assets;
    if (val is int && val >= 0 && val < BoxFit.values.length) {
      result = AssetType.values[val];
    } else if (val is String) {
      switch(val) {
        case "network":
          result = AssetType.network;
          break;
        case 'file':
          result = AssetType.file;
          break;
        case 'assets':
          result = AssetType.assets;
          break;
        case 'memory':
          result = AssetType.memory;
          break;
      }
    }
    return result;
  }

  static TextAlign getTextAlign(val) {
    if (val is TextAlign) {
      return val;
    }
    TextAlign result = TextAlign.start;
    if (val == 'center') {
      result = TextAlign.center;
    } else if (val == 'justify') {
      result = TextAlign.justify;
    } else if (val == 'end') {
      result = TextAlign.end;
    } else if (val == 'left') {
      result = TextAlign.left;
    } else if (val == 'right') {
      result = TextAlign.right;
    } 
    return result;
  }

  static TextDirection getTextDirection(val) {
    if (val is TextDirection) {
      return val;
    }
    TextDirection result = TextDirection.ltr;
    if (val == 'rtl') {
      result = TextDirection.rtl;
    }
    return result;
  }

  static EdgeInsets getPadding(val) {
    if (val is EdgeInsets) {
      return val;
    }
    EdgeInsets result = EdgeInsets.all(0);
    if (val == null || val is double || val is int) {
      val = (val is int) ? double.parse(val.toString()) : val;
      result = EdgeInsets.all(val??0);
    } else if (val is Map) {
      result = EdgeInsets.only(
        left: CollectionUtil.get(val, key: 'left', defaultValue:0)?.toDouble(),
        right: CollectionUtil.get(val, key: 'right', defaultValue:0)?.toDouble(),
        top: CollectionUtil.get(val, key: 'top', defaultValue:0)?.toDouble(),
        bottom: CollectionUtil.get(val, key: 'bottom', defaultValue:0)?.toDouble());
    }
    return result;
  }

  static MainAxisAlignment getMainAxisAlignment(val) {
    if (val is MainAxisAlignment) {
      return val;
    }
    MainAxisAlignment result = MainAxisAlignment.center;
    if (val is String) {
      if (val == 'start') {
        result = MainAxisAlignment.start;
      } else if (val == 'end') {
        result = MainAxisAlignment.end;
      } else if (val == 'spaceAround') {
        result = MainAxisAlignment.spaceAround;
      } else if (val == 'spaceBetween') {
        result = MainAxisAlignment.spaceBetween;
      } else if (val == 'spaceEvenly') {
        result = MainAxisAlignment.spaceEvenly;
      }
    }
    return result;
  }
  static CrossAxisAlignment getCrossAxisAlignment(val) {
    if (val is CrossAxisAlignment) {
      return val;
    }
    CrossAxisAlignment result = CrossAxisAlignment.center;
    if (val is String) {
      if (val == 'baseline') { 
        result = CrossAxisAlignment.baseline;
      } else if (val == 'end') { 
        result = CrossAxisAlignment.end;
      } else if (val == 'stretch') { 
        result = CrossAxisAlignment.stretch;
      } else if (val == 'start') { 
        result = CrossAxisAlignment.start;
      }
    }
    return result;
  }
 /**
   *  约束布局内的位置约束定义
   *   8    1    2
   *    \   |   /
   * 
   *   7——  9  ——3
   * 
   *    /   |   \
   *   6    5    4
   */
  static AlignmentGeometry getAlignment(r, [bool isSetDefault = true]) {
    if (r is AlignmentGeometry) {
      return r;
    }
    AlignmentGeometry result = isSetDefault ? Alignment.center : null;
    if (r is int) {
      switch (r) {
        case 9:
          result = Alignment.center;
          break;
        case 8:
          result = Alignment.topLeft;
          break;
        case 7:
          result = Alignment.centerLeft;
          break;
        case 6:
          result = Alignment.bottomLeft;
          break;
        case 5:
          result = Alignment.bottomCenter;
          break;
        case 4:
          result = Alignment.bottomRight;
          break;
        case 3:
          result = Alignment.centerRight;
          break;
        case 2:
          result = Alignment.topRight;
          break;
        case 1:
          result = Alignment.topCenter;
          break;
      }
    }
    return result;
  }
  static TextWidthBasis getTextWidthBasis(val) {
    if (val is TextWidthBasis) {
      return val;
    }
    TextWidthBasis result = TextWidthBasis.parent;
    if (val is String && val == 'longestLine') {
      result = TextWidthBasis.longestLine;   
    }
    return result;
  }
  static TextOverflow getTextOverflow(val) {
    if (val is TextOverflow) {
      return val;
    }
    TextOverflow result = TextOverflow.visible;
    if (val is String && val  == 'clip') {
      result = TextOverflow.clip;
    } else if (val is String && val  == 'ellipsis') {
      result = TextOverflow.ellipsis;
    } else if (val is String && val  == 'fade') {
      result = TextOverflow.fade;
    }
    return result;
  }
  static StrutStyle getStrutStyle(val) {
    if (val is StrutStyle) {
      return val;
    }
    StrutStyle result;
    if (val is TextStyle) {
      result = StrutStyle.fromTextStyle(val);
    } else if (val is Map) {
      TextStyle temp = getTextStyle(val);
      if (temp != null) 
        result = StrutStyle.fromTextStyle(getTextStyle(val));
    }
    return result;
  }
  static Locale getLocale(val) {
    if (val is Locale) {
      return val;
    }
    Locale result;
    if (val is String) {
      result = Locale(val);
    }
    return result;
  }
  static FontStyle getFontStyle(val) {
    if (val is FontStyle) {
      return val;
    }
    FontStyle result = FontStyle.normal;
    if (val is String) {
      if (val == 'italic')
        result = FontStyle.italic;
    }
    return result;
  }
  static TextBaseline getTextBaseline(val) {
    if (val is TextBaseline) {
      return val;
    }
    TextBaseline result;
    if (val == 'ideographic') {
      result = TextBaseline.ideographic;
    } else if (val == 'alphabetic') {
      result = TextBaseline.alphabetic;
    }
    return result;
  }

  static TextStyle getTextStyle(val) {
    if (val is TextStyle) {
      return val;
    }
    TextStyle result;
    if (val is String) {
      result = ThemeUtil.getTextStyle(name: val);
    } else if (val is TextThemeType) {
      result = ThemeUtil.getTextStyle(type: val);
    } else if (val is Map) {
      result = ThemeUtil.getTextStyle(name: 'caption');
      result = result.copyWith(
        color: getColor(CollectionUtil.get(val, key: 'color'))??Colors.white70,
        backgroundColor: getColor(CollectionUtil.get(val, key: 'backgroundColor')),
        fontWeight: getFontWeight(CollectionUtil.get(val, key: 'fontWeight')),
        fontFamily: CollectionUtil.get<String>(val, key: 'fontFamily'),
        fontSize: getDouble(CollectionUtil.get(val, key: 'fontSize')),
        fontStyle: getFontStyle(CollectionUtil.get(val, key: 'fontStyle')),
        letterSpacing: getDouble(CollectionUtil.get(val, key: 'letterSpacing')),
        wordSpacing: getDouble(CollectionUtil.get(val, key: 'wordSpacing')),
        textBaseline: getTextBaseline(CollectionUtil.get(val, key: 'textBaseline')),
        locale: getLocale(CollectionUtil.get(val, key: 'locale')),
        height: getDouble(CollectionUtil.get(val, key: 'height')),
        debugLabel: CollectionUtil.get<String>(val, key: 'debugLabel')
      );
    }
    return result;
  }

  static getButtonTween(val) {
    if (val is TweenData) {
      return val;
    }
    TweenData result;
    if (val is Map) {
      result = TweenData.fromJson(result as Map<String, dynamic>);
    } else if (val is String) {
      if (val == 'simple') {
        result = TweenData(begin: 1, end: 0.95, duration: Duration(milliseconds: 50));
      }
    }
    return result;
  }
  static getActionEvent(val){
    if (val is ActionEvent) {
      return val;
    }
    ActionEvent result;
    if (val is Map) {
      result = ActionEvent.fromJson(val as Map<String, dynamic>);
    } else if (val is String) {
      result = ActionEvent(event: val);
    }
    return result;
  }
  static WidgetData getWidget(val) {
    if (val is WidgetData) {
      return val;
    }
    WidgetData result;
    if (val is Map) {
      result = prefix0.WidgetBuilder.build(val);
    }
    return result;
  }
  static WidgetData getWidgetAssetTemplate(String template) {
    return gameController.getAssetsTemplate(template);
  }

  static QuestionType getQuestionType(val) {
    var temp = val;
    if (temp is QuestionType) {
      return temp;
    }
    QuestionType result;
    if (temp is String) {
      for (QuestionType item in QuestionType.values) {
        result = temp == describeEnum(item) ? item : null;
        if (result != null) break;
      }
    } else if (
      temp is int 
      && temp >= 0 
      && temp < QuestionType.values.length) {
      result = QuestionType.values[temp];
    }
    return result;
  }

  static getRect(val) {
    if (val is Rect) {
      return val;
    }
    Rect result;
    if (getDouble(val) != null) {
      double d = getDouble(val);
      result = Rect.fromCircle(center: Offset(0.0, 0.0), radius: d);
    } else if (val is Map) {
      RectBuildType rb = _getRectBuildType(CollectionUtil.get(val, key: 'type', defaultValue: 'ltrb'));
      if (rb == RectBuildType.ltrb) {
        double left = CommonUtil.getDouble(CollectionUtil.get(val, key: 'left', defaultValue: 0));
        double right = CommonUtil.getDouble(CollectionUtil.get(val, key: 'right', defaultValue: 0));
        double top = CommonUtil.getDouble(CollectionUtil.get(val, key: 'top', defaultValue: 0));
        double bottom = CommonUtil.getDouble(CollectionUtil.get(val, key: 'bottom', defaultValue: 0));
        result = Rect.fromLTRB(left, right, top, bottom);
      } else if (rb == RectBuildType.ltwh) {
        double left = CommonUtil.getDouble(CollectionUtil.get(val, key: 'left', defaultValue: 0));
        double right = CommonUtil.getDouble(CollectionUtil.get(val, key: 'right', defaultValue: 0));
        double width = CommonUtil.getDouble(CollectionUtil.get(val, key: 'width', defaultValue: 0));
        double height = CommonUtil.getDouble(CollectionUtil.get(val, key: 'height', defaultValue: 0));
        result = Rect.fromLTWH(left, right, width, height);
      } else if (rb == RectBuildType.center) {
        Offset center = getOffset(CollectionUtil.get(val, key: 'center'));
        double width = CommonUtil.getDouble(CollectionUtil.get(val, key: 'width', defaultValue: 0));
        double height = CommonUtil.getDouble(CollectionUtil.get(val, key: 'height', defaultValue: 0));
        result = Rect.fromCenter(center: center, width: width, height: height);
      } else if (rb == RectBuildType.circle) {
        Offset center = getOffset(CollectionUtil.get(val, key: 'center'));
        double radius = CommonUtil.getDouble(CollectionUtil.get(val, key: 'radius', defaultValue: 1.0));
        result = Rect.fromCircle(center: center, radius: radius);
      }
    }
    return result;
  }

  static Offset getOffset(val) {
    if (val is Offset) {
      return val;
    }
    Offset result;
    if (val is int || val is double) {
      double v = getDouble(val)??0.0;
      result = Offset(v, v);
    } else if (val is Map) {
      double dx = CommonUtil.getDouble(CollectionUtil.get(val, key: 'dx', defaultValue: 0.0));
      double dy = CommonUtil.getDouble(CollectionUtil.get(val, key: 'dy', defaultValue: 0.0));
      result = Offset(dx, dy);
    }
    return result;
  }

  static RectBuildType _getRectBuildType(val) {
    const List<RectBuildType> _rectBuildType = RectBuildType.values;
    RectBuildType result;
    if (val is int && val >= 0 && val < _rectBuildType.length) {
      result =  _rectBuildType[val];
    } else if (val is String) {
      if (val == 'center') result = RectBuildType.center;
      else if (val  == 'circle') result = RectBuildType.circle;
      else if (val  == 'ltrb') result = RectBuildType.ltrb;
      else if (val  == 'ltwh') result = RectBuildType.ltwh;
    }
    return result;
  }

  static DecorationData getDecorationData(val) {
    if (val is DecorationData) {
      return val;
    }
    DecorationData result;
    if (val is Map) {
      result = DecorationData(val);
    }
    return result;
  }

  static BoxConstraints getConstraints(val, [TransformConversionType transformConversionType]) {
    if (val is BoxConstraints) {
      return val;
    }
    BoxConstraints result;
    if (val is Map) {
      BaseData s = BaseData.fromJson(val);
      transformConversionType = s.get('transformConversionType') != null ? getTransformConversionType(s.get('transformConversionType')) : transformConversionType;
      double maxWidth = getDouble(s.get('maxWidth'))??double.infinity;
      double maxHeight = getDouble(s.get('maxHeight'))??double.infinity;
      double minWidth = getDouble(s.get('minWidth'))??0.0;
      double minHeight = getDouble(s.get('minHeight'))??0.0;
      if (transformConversionType == TransformConversionType.viewport) {
        maxWidth = ScreenUtil.to(maxWidth);
        maxHeight = ScreenUtil.to(maxHeight);
        minWidth = ScreenUtil.to(minWidth);
        minHeight = ScreenUtil.to(minHeight);
      }
      result = BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth, minHeight: minHeight, minWidth: minWidth);
    }
    return result;
  }

  static DecorationImage getDecorationImage(val) {
    if (val is DecorationImage) {
      return val;
    }
    DecorationImage result;
    if (val is Map) {
      val = DecorationImageData(val);
    } else if (val is String) {
      val  = DecorationImageData(Map<String, dynamic>.from({"src": val}));
    }
    if (val is DecorationImageData) {
      ImageProvider imgp;
      switch(val?.assetType) {
        case AssetType.assets:
          assert(val?.src is String);
          imgp = ExactAssetImage(val?.src);
          break;
        case AssetType.file:
          File f = File(val?.src);
          imgp = FileImage(f);
          break;
        case AssetType.network:
          assert(val?.src is String);
          imgp = NetworkImage(val?.src,);
          break;
        case AssetType.memory:
          throw new ArgumentError("未实现AssetType.memory.");
          break;
        default:
          throw new ArgumentError("不合法的AssetType, value = ${val?.assetType}.");
          break;
      }
      if (imgp != null) {
        result = DecorationImage(image: imgp, fit: val?.boxFit, alignment: val?.alignment, centerSlice: val?.centerSlice );
      }
    }
    return result;
  }
}