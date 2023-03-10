import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class TextFieldTheming {
  InputBorder? inputBorder;
  bool? filled;
  IconData? icon;
  String? hintText;
  String? lableText;
  String? suffix;
  String? prefix;
  TextFieldTheming(
      {this.inputBorder,
      this.filled,
      this.icon,
      this.hintText,
      this.lableText,
      this.suffix,
      this.prefix});
}

final defaultLightColorScheme = ColorScheme.fromSwatch(
    backgroundColor: Colors.grey.shade50,
    primarySwatch: Colors.blueGrey,
    accentColor: kAccentColor);

final defaultDarkColorScheme = ColorScheme.fromSwatch(
    // backgroundColor: Colors.grey.shade50,
    backgroundColor: Colors.grey.shade900,
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    accentColor: kAccentColor);
