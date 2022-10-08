import 'package:flutter/material.dart';

class TherdScreenProvider with ChangeNotifier {
  Widget? _therdWidget;

  Widget? get getWidgt => _therdWidget;

  void change(Widget? widget) {
    this._therdWidget = widget;
    notifyListeners();
  }
}
