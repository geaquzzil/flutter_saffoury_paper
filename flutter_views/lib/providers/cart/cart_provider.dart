//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';

class CartProvider with ChangeNotifier {
  late CartableInvoiceMasterObjectInterface _cartObject;

  CartableInvoiceMasterObjectInterface get getCartableInvoice => _cartObject;

  CartProvider.init(CartableInvoiceMasterObjectInterface cartObject) {
    _cartObject = cartObject;
  }
  // List<CartableProductItemInterface> list = [];
  Widget? _checkoutWidget;

  List<CartableInvoiceDetailsInterface> get getList =>
      _cartObject.getDetailList();

  int get getCount => getList.length;

  CartProcessType _cartType = CartProcessType.PROCESS;

  CartProcessType get getProcessType => _cartType;

  Widget? get getCheckoutWidget => _checkoutWidget;

  void checkout(BuildContext context) {
    if (getList.isEmpty) return;
    _cartType = CartProcessType.CHECKOUT;
    // _checkoutWidget = list[0].onCartCheckout(context, list);
    notifyListeners();
  }

  void onCartItemAdded(BuildContext context, int idx,
      CartableProductItemInterface detail, double? qu) {
    _cartObject.onCartItemAdded(context, idx, detail, quantiy: qu);
    notifyListeners();
  }

  void onCartItemChanged(
      BuildContext context, int idx, CartableInvoiceDetailsInterface detail) {
    _cartObject.onCartItemChanged(context, idx, detail);
    notifyListeners();
  }

  void onCartItemRemoved(
      BuildContext context, CartableInvoiceDetailsInterface detail) {
    _cartObject.onCartItemRemoved(context, -1, detail);
    notifyListeners();
  }

  Future<bool> hasItem(CartableProductItemInterface product) async {
    // return list.firstWhereOrNull((p0) => p0.isEqualsCartItem(product)) != null;
    return false;
  }

  void clear() {
    _cartObject.onCartClear();
    notifyListeners();
  }
}

enum CartProcessType { CHECKOUT, PROCESS }
