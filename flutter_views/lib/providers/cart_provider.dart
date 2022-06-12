//create product cart provider class

import 'package:flutter/material.dart';

import '../models/view_abstract.dart';

class CartProvider with ChangeNotifier {
  
  List<ViewAbstract> products = [];

  List<ViewAbstract> get getProducts => products;

  int get count => products.length;

  void addProduct(ViewAbstract product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(ViewAbstract product) {
    products.remove(product);
    notifyListeners();
  }
}
