//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

import '../../models/view_abstract.dart';

class CartProvider with ChangeNotifier {
  List<ViewAbstract> list = [];

  List<ViewAbstract> get getList => list;

  int get getCount => list.length;

  double get getTotalPrice => list
      .map((item) => item.getCartItemPrice())
      .reduce((value, element) => value + element);

  double get getTotalQuantity => list
      .map((item) => item.getCartItemQuantity())
      .reduce((value, element) => value + element);

  void add(ViewAbstract product) {
    list.add(product);
    notifyListeners();
  }

  void remove(ViewAbstract product) {
    list.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(ViewAbstract product) async {
    return list.firstWhereOrNull((p0) => p0.isEquals(product)) != null;
  }

  void clear() {
    list.clear();
    notifyListeners();
  }
}
