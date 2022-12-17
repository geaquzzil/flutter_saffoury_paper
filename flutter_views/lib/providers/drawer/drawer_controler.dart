import 'package:flutter/material.dart';

class DrawerMenuControllerProvider with ChangeNotifier {
  final GlobalKey<ScaffoldState> _startDrawerKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get getStartDrawableKey => _startDrawerKey;

  void controlStartDrawerMenu() {
    if (!_startDrawerKey.currentState!.isDrawerOpen) {
      _startDrawerKey.currentState!.openDrawer();
    } else {
      _startDrawerKey.currentState!.closeDrawer();
    }
  }

  void controlEndDrawerMenu() {
    if (!_startDrawerKey.currentState!.isEndDrawerOpen) {
      _startDrawerKey.currentState!.openEndDrawer();
    }
    // notifyListeners();
  }
}
