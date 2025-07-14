import 'package:flutter/material.dart';

import '../new_screens/cart/base_home_cart_screen.dart';

class EndDrawerProvider with ChangeNotifier {
  Widget _drawerWidget = const BaseHomeCartPage();

  Widget get getWidgt => _drawerWidget;

  void change(Widget widget) {
    _drawerWidget = widget;
    notifyListeners();
  }

}
