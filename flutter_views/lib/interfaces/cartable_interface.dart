import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';

abstract class CartableInvoiceMasterObjectInterface {
  List<InvoiceTotalTitleAndDescriptionInfo> getCartableInvoiceSummary(
      BuildContext context);

  void onCartItemChanged(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii);
  void onCartItemAdded(
      BuildContext context, int index, CartableProductItemInterface cii,
      {double? quantiy});
  void onCartItemRemoved(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii);

  void onCartClear();

  List<CartableInvoiceDetailsInterface> getDetailList();

  Widget onCartCheckout(
      BuildContext context, List<CartableProductItemInterface> items);
}

abstract class CartableInvoiceDetailsInterface {
  ///key is field
  ///value is CartInvoiceHeader that contains translated title and options
  Map<String, DataTableContent> getCartInvoiceTableHeaderAndContent(
      BuildContext context);
  bool isCartEquals(CartableInvoiceDetailsInterface other);

  String? Function(dynamic) getCartableEditableValidateItemCell(
      BuildContext context, String field);

  void getCartableEditableOnChange(
      BuildContext context, int rowIndex, String field, dynamic value);
}

class DataTableContent {
  String title;
  dynamic value;
  bool canEdit;
  DataTableContent(
      {required this.title, required this.value, required this.canEdit});
}

abstract class CartableProductItemInterface {
  double getCartableProductQuantity();
}
