import 'dart:ui';

import 'package:course/utils/collectionUtil.dart';
import 'package:flutter/material.dart';

/**
 * Screen 尺寸和布局小工具
 */
class ScreenUtil {
  static const DEFAULT_WIDTH = 1134;
  static MediaQueryData mediaData = MediaQueryData.fromWindow(window);
  static double screenWidth = mediaData.size.width;
  static double screenHeight = mediaData.size.height;
  static double dpr = mediaData.devicePixelRatio;
  static var _radio;


  static final Map<int, Alignment> _alignMap = {
    1: Alignment.topCenter,
    2: Alignment.topRight,
    3: Alignment.centerRight,
    4: Alignment.bottomRight,
    5: Alignment.bottomCenter,
    6: Alignment.bottomLeft,
    7: Alignment.centerLeft,
    8: Alignment.topLeft,
    9: Alignment.center,
  };

  static getOrientation(BuildContext context) {
    // Orientation.landscape;
    return MediaQuery.of(context).orientation;
  }
  static isLandscape(BuildContext context) {
    return getOrientation(context) == Orientation.landscape;
  }
  static init(int width, { BuildContext context }) {
    if (width == null) {
      width = DEFAULT_WIDTH;
    }
    _radio = screenWidth / width;
    screenWidth = context == null ? mediaData.size.width : MediaQuery.of(context).size.width;
    screenHeight = context == null ? mediaData.size.height : MediaQuery.of(context).size.height;
    dpr = mediaData.devicePixelRatio;
    // print('init::::radio=$_radio, height=$screenHeight, width=$screenWidth, dpr=$dpr');
  }

  /**
   * 根据实际尺寸换算设计稿真实尺寸
   */
  static double to(double value){
    if (!(_radio is int || _radio is double)) {
      init(DEFAULT_WIDTH);
    }
    // print('to:::radio=$_radio, height=$screenHeight, width=$screenWidth, dpr=$dpr');
    return value * _radio;
  }

  /**
   * 不同屏幕的1像素
   */
  static double one() {
    return 1 / dpr;
  }

  /**
   * view width
   */
  static vw({ double percentage: 1 }) {
    if (percentage == null) {
      return null;
    }
    return screenWidth * percentage;
  }

  /**
   * view height
   */
  static vh({ double percentage: 1 }) {
    if (percentage == null) {
      return null;
    }
    return screenHeight * percentage;
  }

  /**
   * 组件布局规则
   * int layout
   *  
   *    1    2    3
   *     \   |   /
   *    8    9    4
   *     /   |   \
   *    7    6    5
   * 
   */
  static Alignment align(int layout) {
    return CollectionUtil.get(_alignMap, key: layout, defaultValue: Alignment.topLeft);
  }
}