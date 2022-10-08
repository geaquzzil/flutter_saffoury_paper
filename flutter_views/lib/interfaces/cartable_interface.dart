import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable_interface.dart';

abstract class CartableInvoiceMasterObjectInterface {
  List<List<InvoiceHeaderTitleAndDescriptionInfo>> getCartableInvoiceSummary(
      BuildContext context);

  void onCartItemChanged(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii);
  void onCartItemAdded(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii);
  void onCartItemRemoved(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii);

  List<CartableInvoiceDetailsInterface> getDetailList(BuildContext context);

  Widget onCartCheckout(
      BuildContext context, List<CartableItemInterface> items);
}

abstract class CartableInvoiceDetailsInterface {
  Map<String, dynamic> getCartInvoiceTableHeaderAndContent(
      BuildContext context);
  bool onGenerateEditTextFieldCanEdit(String field);
  bool isEqualsCartItem(CartableInvoiceDetailsInterface other);
}

abstract class CartableItemInterface {
  double cartPrice = 0;
  double cartUnitPrice = 0;
  double cartQuantity = 0;

  Widget? getCartItemLeading(BuildContext context);
  String getCartItemDescription(BuildContext context);
  String getCartItemSubtitle(BuildContext context);
  double getCartItemPrice();
  double getCartItemUnitPrice();
  double getCartItemQuantity();

  void onCartItemChanged(BuildContext context);
  void onCartItemAdded(BuildContext context);
  void onCartItemRemoved(BuildContext context);

  Widget onCartCheckout(
      BuildContext context, List<CartableItemInterface> items);

  bool isEqualsCartItem(CartableItemInterface other);
}
