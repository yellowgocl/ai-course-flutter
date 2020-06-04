import 'package:flutter/foundation.dart';

/**
 * 操作集合的基础方法封装
 */
class CollectionUtil {
  static T get <T> (Map source, { key, T defaultValue }) {
    if (!isVaild(source) || key == null) {
      return defaultValue;
    }
    return source.containsKey(key) ? source[key]?? defaultValue : defaultValue;
  }

  static bool set<T> (Map source, { key, T value }) {
    if (!isVaild(source) || key == null) {
      return false;
    }
    source[key] = value;
  }

  static bool isVaild(Map source) {
    return source != null;
  }
}