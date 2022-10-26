//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';

class CartProvider with ChangeNotifier {
  late CartableInvoiceMasterObjectInterface _cartObject;

  CartableInvoiceMasterObjectInterface get getCartableInvoice => _cartObject;

  CartProvider.init(CartableInvoiceMasterObjectInterface cartObject) {
    _cartObject = cartObject;
  }
  List<CartableProductItemInterface> list = [];
  Widget? _checkoutWidget;

  List<CartableProductItemInterface> get getList => list;

  int get getCount => list.length;

  CartProcessType _cartType = CartProcessType.PROCESS;

  CartProcessType get getProcessType => _cartType;

  Widget? get getCheckoutWidget => _checkoutWidget;

  void checkout(BuildContext context) {
    if (getList.isEmpty) return;
    _cartType = CartProcessType.CHECKOUT;
    // _checkoutWidget = list[0].onCartCheckout(context, list);
    notifyListeners();
  }
  void onCartItemAdded(BuildContext context,int idx,   CartableProductItemInterface detail,double qu) {
    _cartObject.onCartItemAdded(context, idx, detail,quantiy: qu);
      notifyListeners();
  }
  void onCartItemChanged(BuildContext context,int idx,   CartableInvoiceDetailsInterface detail) {
    _cartObject.onCartItemChanged(context, idx, detail);
      notifyListeners();
  }

  void add(BuildContext context, CartableProductItemInterface product) {
    list.add(product);
    _cartObject.onCartItemAdded(
        context, _cartObject.getDetailList(context).length - 1, product);
    notifyListeners();
  }

  void remove(CartableProductItemInterface product) {
    list.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(CartableProductItemInterface product) async {
    // return list.firstWhereOrNull((p0) => p0.isEqualsCartItem(product)) != null;
    return false;
  }

  void clear() {
    list.clear();
    notifyListeners();
  }
}

enum CartProcessType { CHECKOUT, PROCESS }
