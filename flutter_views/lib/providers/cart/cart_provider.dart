//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';

import '../../models/view_abstract.dart';

class CartProvider with ChangeNotifier {
  List<CartableDetailItemInterface> list = [];

  List<CartableDetailItemInterface> get getList => list;

  int get getCount => list.length;

  double get getTotalPrice => list
      .map((item) => item.getCartItemPrice())
      .reduce((value, element) => value + element);

  double get getTotalQuantity => list
      .map((item) => item.getCartItemQuantity())
      .reduce((value, element) => value + element);

  void add(CartableDetailItemInterface product) {
    list.add(product);
    notifyListeners();
  }

  void remove(CartableDetailItemInterface product) {
    list.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(CartableDetailItemInterface product) async {
    return list.firstWhereOrNull((p0) => p0.isEqualsCartItem(product)) != null;
  }

  void clear() {
    list.clear();
    notifyListeners();
  }
}
