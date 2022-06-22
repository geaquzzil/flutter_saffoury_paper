import 'package:flutter/material.dart';

class DrawerMenuSelectedItemController with ChangeNotifier {
  int _idx = 0;
  int get getIndex => _idx;

  void change(int idx) {
    _idx = idx;
    notifyListeners();
  }
}
