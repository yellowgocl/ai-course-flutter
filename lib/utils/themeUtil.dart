
import 'package:flutter/material.dart';

enum TextThemeType{
  title, subtitle, subhead, body1, body2, caption, button, display1, dialog_title, question
}

class ThemeUtil{


static final ThemeData theme = ThemeData(
  primaryColor: Colors.lightBlue,
  accentColor: Colors.lightBlueAccent.shade400,
  textTheme: normalText
);
static final  TextTheme normalText = TextTheme(
  body1: TextStyle(color: Colors.white70, fontSize: (16), fontWeight: FontWeight.bold),
  body2: TextStyle(color: Colors.white70, fontSize: (16)),
  title: TextStyle(color: Colors.white70, fontSize: (24), fontWeight: FontWeight.bold),
  subhead: TextStyle(color: Colors.white70, fontSize: (20)),
  subtitle: TextStyle(color: Colors.white60, fontSize: (20)),
  caption: TextStyle(color: Colors.white70, fontSize: (12)),
  button: TextStyle(color: Colors.black54, fontSize: (20), fontWeight: FontWeight.bold),
  display1: TextStyle(color: Colors.black54, fontSize: (16), fontWeight: FontWeight.bold),
  display2: TextStyle(color: Colors.black54, fontSize: (18)),
);

static TextStyle getTextStyle({String name, TextThemeType type}) {
  TextTheme currentTheme = theme.textTheme;
  if (name == 'body1' || type == TextThemeType.body1) {
    return currentTheme.body1;
  } else if (name == 'body2' || type == TextThemeType.body2) {
    return currentTheme.body2;
  } else if (name == 'title' || type == TextThemeType.title) {
    return currentTheme.title;
  } else if (name == 'subhead' || type == TextThemeType.subhead) {
    return currentTheme.subhead;
  } else if (name == 'subtitle' || type == TextThemeType.subtitle) {
    return currentTheme.subtitle;
  } else if (name == 'caption' || type == TextThemeType.caption) {
    return currentTheme.caption;
  } else if (name == 'button' || type == TextThemeType.button) {
    return currentTheme.button;
  } else if (name == 'display1' || name == 'dialog_title' || type == TextThemeType.display1 || type == TextThemeType.dialog_title) {
    return currentTheme.display1;
  } else if (name == 'question' || type == TextThemeType.question) {
    return currentTheme.display2.copyWith(color: Color(0xFF19262E), fontWeight: FontWeight.normal);
  }
  return null;
}
}