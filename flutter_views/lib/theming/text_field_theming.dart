import 'package:flutter/material.dart';

class TextFieldTheming {
  InputBorder? inputBorder;
  bool? filled;
  IconData? icon;
  String? hintText;
  String? lableText;
  String? suffix;
  String? prefix;
  TextFieldTheming({this.inputBorder, this.filled, this.icon, this.hintText, this.lableText, this.suffix, this.prefix});
}
final defaultLightColorScheme =
    ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey);

final defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey, brightness: Brightness.dark);