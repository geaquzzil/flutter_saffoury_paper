import 'package:flutter/material.dart';

class DrawerMenuSelectedItemController with ChangeNotifier {
  bool sideMenuOpen = false;
  int _idx = 0;
  int get getIndex => _idx;
  bool get getSideMenuIsOpen => sideMenuOpen;
  bool get getSideMenuIsClosed => !sideMenuOpen;

  void change(int idx) {
    _idx = idx;
    notifyListeners();
  }

  void toggleIsOpen() {
    sideMenuOpen = !sideMenuOpen;
    notifyListeners();
  }

  void setSideMenuIsClosed() {
    sideMenuOpen = false;
    notifyListeners();
  }

  void setSideMenuIsOpen() {
    sideMenuOpen = true;
    notifyListeners();
  }
}
