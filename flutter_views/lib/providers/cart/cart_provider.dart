//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';

class CartProvider with ChangeNotifier {
  List<CartableItemInterface> list = [];
  Widget? _checkoutWidget;

  List<CartableItemInterface> get getList => list;

  int get getCount => list.length;

  CartProcessType _cartType = CartProcessType.PROCESS;

  CartProcessType get getProcessType => _cartType;

  Widget? get getCheckoutWidget => _checkoutWidget;

  void checkout(BuildContext context) {
    if (getList.isEmpty) return;
    _cartType = CartProcessType.CHECKOUT;
    _checkoutWidget = list[0].onCartCheckout(context, list);
    notifyListeners();
  }

  double get getTotalPrice {
    try {
      return list
          .map((item) => item.getCartItemPrice())
          .reduce((value, element) => value + element);
    } catch (e) {
      debugPrint("$e");
      return 0;
    }
  }

  double get getTotalQuantity => list
      .map((item) => item.getCartItemQuantity())
      .reduce((value, element) => value + element);

  void add(CartableItemInterface product) {
    list.add(product);
    notifyListeners();
  }

  void remove(CartableItemInterface product) {
    list.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(CartableItemInterface product) async {
    return list.firstWhereOrNull((p0) => p0.isEqualsCartItem(product)) != null;
  }

  void clear() {
    list.clear();
    notifyListeners();
  }
}

enum CartProcessType { CHECKOUT, PROCESS }
