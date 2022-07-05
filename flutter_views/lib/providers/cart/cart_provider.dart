//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

import '../../models/view_abstract.dart';

class CartProvider with ChangeNotifier {
  List<ViewAbstract> products = [];

  List<ViewAbstract> get getProducts => products;

  int get count => products.length;

  double get getTotalPrice => products
      .map((item) => item.getCartItemPrice())
      .reduce((value, element) => value + element);

  double get getTotalQuantity => products
      .map((item) => item.getCartItemQuantity())
      .reduce((value, element) => value + element);

  void addProduct(ViewAbstract product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(ViewAbstract product) {
    products.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(ViewAbstract product) async{
    return products.firstWhereOrNull((p0) => p0.isEquals(product))!=null;
  }

  void removeAll() {
    products.clear();
    notifyListeners();
  }
}
