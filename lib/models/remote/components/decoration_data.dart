import 'package:course/component/image.dart' as Lib;
import 'package:course/models/builder_data.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/widgets.dart';

class DecorationData extends BuilderData<Decoration> {
  DecorationData(Map<String, dynamic> json): super.fromJson(json);
  @override
  Decoration build([context]) {
    // TODO: implement build
    return BoxDecoration(
      color: color, 
      image: image, 
      border: border, 
      borderRadius: borderRadius, 
      shape: shape,
      boxShadow: boxShadow,
      gradient: gradient,
      backgroundBlendMode: backgroundBlendMode);
  }
  BlendMode get backgroundBlendMode{
    return null;
  }
  Gradient get gradient {
    return null;
  }
  List<BoxShadow> get boxShadow {
    return null;
  }

  Color get color{
    return CommonUtil.getColor(get('color'),);
  }
  BoxShape get shape{
    return getDecorationShape(get('shape', 'rect'),);
  }
  BorderRadiusGeometry get borderRadius {
    return getBorderRadius(get('borderRadius'));
  }
  BoxBorder get border{
    return getBorder(get('border'));
  }
  DecorationImage get image{
    // return DecorationImage( image: NetworkImage());
    return CommonUtil.getDecorationImage(get('image'));
  }

  getBorder(val) {
    if (val is BoxBorder) {
      return val;
    }
    BoxBorder result;
    if (val is String) {
      val = CommonUtil.getColor(val);
      result = Border.all(color: val, width: 1);
    } else if (val is Map) {
      Color color = CommonUtil.getColor(CollectionUtil.get(val, key: 'color'));
      double width = CommonUtil.getDouble(CollectionUtil.get(val, key: 'width'))??1.0;
      result = Border.all(color: color, width: width);
    }
    return result;
  }
  getBorderRadius(val) {
    if (val is BorderRadiusGeometry) {
      return val;
    }
    BorderRadiusGeometry result;
    if (val is int || val is double) {
      val = CommonUtil.getDouble(val);
      result = BorderRadius.circular(val);
    } else if (val is Map) {
      double topLeft =  CommonUtil.getDouble(CollectionUtil.get(val, key: 'topLeft', ))??0.0;
      double topRight = CommonUtil.getDouble(CollectionUtil.get(val, key: 'topRight', ))??0.0;
      double bottomLeft = CommonUtil.getDouble(CollectionUtil.get(val, key: 'bottomLeft', ))??0.0;
      double bottomRight = CommonUtil.getDouble(CollectionUtil.get(val, key: 'bottomRight', ))??0.0;
      result = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft), 
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomRight: Radius.circular(bottomRight,));
    }
    return result;
  }
  getDecorationShape(val) {
    if (val is BoxShape) {
      return val;
    }
    BoxShape result;
    if (val is String) {
      if (val == 'rect' || val == 'rectangle') {
        result = BoxShape.rectangle;
      } else if (val == 'circle') {
        result = BoxShape.circle;
      }
    }
    return result;
  } 
}