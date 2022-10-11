import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/edit/base_edit_screen.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/screens/action_screens/edit_details_page.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:provider/provider.dart';
import 'invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'orders.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Order extends InvoiceMaster<Order>
    implements CartableInvoiceMasterObjectInterface {
  List<OrderDetails>? orders_details;
  int? orders_details_count;

  List<OrderRefund>? orders_refunds;
  int? orders_refunds_count;

  Order() : super() {
    orders_details = <OrderDetails>[];
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "order_details": List<OrderDetails>.empty(),
          "orders_details_count": 0,
          "orders_refunds": List<OrderRefund>.empty(),
          "orders_refunds_count": 0
        });

  @override
  String? getTableNameApi() => "orders";

  @override
  List<String>? requireObjectsList() => ["orders_details"];

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.orders;

  factory Order.fromJson(Map<String, dynamic> data) => _$OrderFromJson(data);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  List<TabControllerHelper> getCustomTabList(BuildContext context) {
    return [
      TabControllerHelper(
        AppLocalizations.of(context)!.findSimilar,
        getMainIconData(),
        autoRest: AutoRest<Order>(
            obj: Order()..setCustomMap({"<CustomerID>": "${customers?.iD}"}),
            key: "CustomerByOrder$iD"),
      )
    ];
  }

  @override
  Order fromJsonViewAbstract(Map<String, dynamic> json) => Order.fromJson(json);

  @override
  List<InvoiceTotalTitleAndDescriptionInfo> getCartableInvoiceSummary(
      BuildContext context) {
    double? totalPrice = getTotalPriceFromList();
    double? totalDiscount = getTotalDiscountFromList();
    double? totalQuantity = getTotalQuantityFromList();
    double? totalNetPrice = (totalPrice ?? 0) - (totalDiscount ?? 0);

    return [
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.subTotal.toUpperCase(),
          description: totalPrice?.toStringAsFixed(2) ?? "0"),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.discount.toUpperCase(),
          description: totalDiscount?.toStringAsFixed(2) ?? "0"),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.quantity.toUpperCase(),
          description: totalQuantity?.toStringAsFixed(2) ?? "0"),
      InvoiceTotalTitleAndDescriptionInfo(
          title: AppLocalizations.of(context)!.grandTotal.toUpperCase(),
          description: totalNetPrice.toStringAsFixed(2),
          hexColor: getPrintableInvoicePrimaryColor()),
    ];
  }

  double? getTotalDiscountFromList() {
    try {
      return orders_details
          ?.map((e) => e.discount)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  double? getTotalPriceFromList() {
    try {
      return orders_details
          ?.map((e) => e.price)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  double? getTotalQuantityFromList() {
    try {
      return orders_details
          ?.map((e) => e.quantity)
          .reduce((value, element) => (value ?? 0) + (element ?? 0));
    } catch (e) {
      return 0;
    }
  }

  @override
  List<CartableInvoiceDetailsInterface> getDetailList(BuildContext context) {
    return orders_details ?? [];
  }

  @override
  Widget onCartCheckout(
      BuildContext context, List<CartableProductItemInterface> details) {
    return BaseEditPage(parent: this);
  }

  @override
  void onCartItemChanged(
      BuildContext context, int index, CartableInvoiceDetailsInterface cii) {
    orders_details![index] = cii as OrderDetails;
  }

  @override
  void onCartItemRemoved(
      BuildContext context, int index, CartableProductItemInterface cii) {
    orders_details?.removeAt(index);
  }

  @override
  void onCartItemAdded(
      BuildContext context, int index, CartableProductItemInterface cii,
      {double? quantiy}) {
    orders_details
        ?.add(OrderDetails()..setProduct(cii as Product, quantity: quantity));
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderDetails extends InvoiceMasterDetails<OrderDetails>
    implements CartableInvoiceDetailsInterface {
  // int? OrderID;
  Order? orders;
  OrderDetails() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "orders": Order(),
        });
  @override
  String? getTableNameApi() => "orders_details";

  factory OrderDetails.fromJson(Map<String, dynamic> data) =>
      _$OrderDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  OrderDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      OrderDetails.fromJson(json);

  @override
  Map<String, DataTableContent> getCartInvoiceTableHeaderAndContent(
          BuildContext context) =>
      {
        "description": DataTableContent(
            title: AppLocalizations.of(context)!.description,
            value: products?.getMainHeaderTextOnly(context) ?? "",
            canEdit: false),
        "gsm": DataTableContent(
            title: AppLocalizations.of(context)!.gsm,
            value: products?.gsms?.gsm ?? 0,
            canEdit: false),
        "quantity": DataTableContent(
            title: AppLocalizations.of(context)!.quantity,
            value: quantity ?? 0,
            canEdit: true),
        "unitPrice": DataTableContent(
            title: AppLocalizations.of(context)!.unit_price,
            value: unitPrice ?? 0,
            canEdit: true),
        "discount": DataTableContent(
            title: AppLocalizations.of(context)!.discount,
            value: discount ?? 0,
            canEdit: true),
        "price": DataTableContent(
            title: AppLocalizations.of(context)!.total_price,
            value: price ?? 0,
            canEdit: true),
      };

  @override
  bool isCartEquals(CartableInvoiceDetailsInterface other) {
    return products?.iD == (other as Product).iD;
  }

  @override
  void getCartableEditableOnChange(
      BuildContext context, int idx, String field, value) {
    debugPrint("getCartableEditableOnChange field=> $field value => $value");
    setFieldValue(field, double.tryParse(value));
    if (field == "quantity") {
      price = quantity.toNonNullable() * unitPrice.toNonNullable();
    }
    if (field == "price") {
      unitPrice = price.toNonNullable() / quantity.toNonNullable();
    }
    if (field == "unitPrice") {
      price = unitPrice.toNonNullable() * quantity.toNonNullable();
    }
    context.read<CartProvider>().onCartItemChanged(context, idx, this);
  }

  @override
  String? Function(dynamic) getCartableEditableValidateItemCell(
      BuildContext context, String field) {
    double? maxValue = getTextInputValidatorMaxValue(field);
    double? minValue = getTextInputValidatorMinValue(field);
    return FormBuilderValidators.compose([
      if (isFieldRequired(field)) FormBuilderValidators.required(),
      if (maxValue != null) FormBuilderValidators.max(maxValue),
      if (minValue != null) FormBuilderValidators.min(minValue),
    ]);
  }
}
