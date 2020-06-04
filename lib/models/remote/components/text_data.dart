import 'package:course/component/text.dart' as Lib;
import 'package:course/core/gameController.dart';
import 'package:course/models/factory/widget_builder.dart';
import 'package:course/models/remote/components/view_group_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/models/remote/components/widget_option_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/themeUtil.dart';
import 'package:flutter/widgets.dart';

class TextData extends WidgetData<TextOptionData> {
  TextData(Map<String, dynamic> data) : super(data);

  @override
  TextOptionData parseOption(option) {
    // TODO: implement parseOption
    return option is Map ? TextOptionData.fromJson(option) : null;
  }

  @override
  Widget build([context]) {
    // TODO: implement build    
    Widget result = Lib.TextWrapper(data: this,);
    if (type == WidgetType.title) {
      result = Lib.TitleWrapper(data: this);
    } else if (type == WidgetType.question) {
      result = Lib.QuestionWrapper(data: this);
    } else if (type == WidgetType.questionType) {
      result = Lib.QuestionTypeWrapper(data: this,);
    }
    return result;
  }
}

class TextOptionData extends ViewGroupOptionData {
  TextOptionData(String text, { 
    Color textColor,
    String textThemeType, 
    String fontWeight, 
    String fontFamily, 
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    StrutStyle strutStyle,
    TextWidthBasis textWidthBasis,
    bool softWrap,
    double textScaleFactor,
    String semanticsLabel,
    int maxLines,
    TextOverflow overflow,
    TextStyle style }): super(null) {
      this.text = text;
      this.textThemeType = textThemeType;
      this.fontFamily = fontFamily;
      this.fontWeight = fontWeight;
      this.textAlign = textAlign;
      this.textDirection = textDirection;
      this.locale = locale;
      this.strutStyle = strutStyle;
      this.textWidthBasis = textWidthBasis;
      this.softWrap = softWrap;
      this.textScaleFactor = textScaleFactor;
      this.semanticsLabel = semanticsLabel;
      this.maxLines = maxLines;
      this.overflow = overflow;
      this.style = style;
      
  }
  TextOptionData.fromJson(Map<String, dynamic> data) : super.fromJson(data);
  set text(String val) {
    set('text', val);
  }
  String get text{
    return get<String>('text', null);
  }
  String get textThemeType{
    return get<String>('textThemeType', null);
  }
  set textThemeType(String val) {
    set('textThemeType', val);
  }
  Color get textColor{
    return CommonUtil.getColor(get('textColor', null));
  }
  set textColor(Color val) {
    set('textColor', val);
  }
  String get fontWeight{
    return get<String>('fontWeight', null);
  }
  set fontWeight(String val) {
    set('fontWeight', val);
  }
  String get fontFamily{
    return get<String>('fontFamily', null);
  }
  set fontFamily(String val) {
    set('fontFamily', val);
  }

  TextAlign get textAlign{
    return CommonUtil.getTextAlign(get('textAlign', null));
  }
  set textAlign(TextAlign val) {
    set('textAlign', val);
  }

  set textDirection(TextDirection val) {
    set('textDirection', val);
  }
  TextDirection get textDirection{
    return CommonUtil.getTextDirection(get('textDirection', null));
  }

  Locale get locale{
    return null;
  }
  set locale(Locale val) {
    set('locale', val);
  }

  set strutStyle(StrutStyle val) {
    set('strutStyle', val);
  }
  StrutStyle get strutStyle{
    var r = get('strutStyle', null);
    if (r is StrutStyle) {
      return r;
    }
    r = CommonUtil.getStrutStyle(r);
    if (r != null) {
      this.strutStyle = r;
    }
    return r;
  }

  set textWidthBasis(TextWidthBasis val) {
    set('textWidthBasis', val);
  }
  TextWidthBasis get textWidthBasis{
    return CommonUtil.getTextWidthBasis(get('textWidthBasis', null));
  }
  bool get softWrap{
    return get<bool>('softWrap', null);
  }
  set softWrap(bool val) {
    set('softWrap', val);
  }

  double get textScaleFactor{
    return CommonUtil.getDouble(get('textScaleFactor', null));
  }
  set textScaleFactor(double val) {
    set('textScaleFactor', val);
  }

  set semanticsLabel(String val) {
    set('semanticsLabel', val);
  }
  String get semanticsLabel{
    return get<String>('semanticsLabel', null);
  }

  int get maxLines{
    return get<int>('maxLines', null);
  }
  set maxLines(int val) {
    set('maxLines', val);
  }

  TextOverflow get overflow{
    return CommonUtil.getTextOverflow(get<int>('overflow', null));
  }
  set overflow(TextOverflow val) {
    set('overflow', val);
  }
  TextStyle get style{
    var r = get('style', null);
    if (r is TextStyle) {
      return r;
    } else if (r is String) {
      return ThemeUtil.getTextStyle(name: r);
    } else if (r is Map<String, dynamic>) {
      return CommonUtil.getTextStyle(r);
    }
    return null;
  }
  set style(TextStyle val) {
    set('style', val);
  }
}