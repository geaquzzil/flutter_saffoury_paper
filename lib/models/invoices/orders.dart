import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/orders_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'orders.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Order extends InvoiceMaster<Order> {
  List<OrderDetails>? orders_details;
  int? orders_details_count;

  List<OrderRefund>? orders_refunds;
  int? orders_refunds_count;

  Order() : super();

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

  
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderDetails extends InvoiceMasterDetails<OrderDetails> {
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
}
