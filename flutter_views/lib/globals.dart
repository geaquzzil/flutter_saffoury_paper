import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == "ar";
  }
}
