import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
part 'orders_refunds.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefund extends InvoiceMaster<OrderRefund> {
  // int? OrderID;

  Order? orders;

  List<OrderRefundDetails>? orders_refunds_order_details;
  int? orders_refunds_order_details_count;

  OrderRefund() : super() {
    orders_refunds_order_details = <OrderRefundDetails>[];
  }
  @override
  OrderRefund getSelfNewInstance() {
    return OrderRefund();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "orders_refunds_order_details": List<OrderRefundDetails>.empty(),
          "orders_refunds_order_details_count": 0
        });

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizes;

  @override
  String? getTableNameApi() => "orders_refunds";

  @override
  Map<ServerActions, List<String>>? isRequiredObjectsList() => {
        ServerActions.list: ["orders_refunds_order_details"],
      };

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["orders", "cargo_transporters", "date", "billNo", "comments"];

  factory OrderRefund.fromJson(Map<String, dynamic> data) =>
      _$OrderRefundFromJson(data);

  Map<String, dynamic> toJson() => _$OrderRefundToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  OrderRefund fromJsonViewAbstract(Map<String, dynamic> json) =>
      OrderRefund.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefundDetails extends InvoiceMasterDetails<OrderRefundDetails> {
  // int? OrderID;
  // int? OrderDetailsID;
  // int? OrderRefundID;
  // int? WarehouseID;

  OrderRefund? orders_refunds;
  Order? orders;
  OrderDetails? orders_details;

  OrderRefundDetails() : super();

  @override
  OrderRefundDetails getSelfNewInstance() {
    return OrderRefundDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "orders_refunds": OrderRefund(),
          "orders": Order(),
          "orders_details": OrderDetails()
        });
  OrderRefundDetails setOrder(Order orders) {
    //TODO: implement this
    return this;
  }

  @override
  String? getTableNameApi() => "orders_refunds_order_details";

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["products", "warehouse", "quantity", "comments"];

  factory OrderRefundDetails.fromJson(Map<String, dynamic> data) =>
      _$OrderRefundDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$OrderRefundDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  OrderRefundDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      OrderRefundDetails.fromJson(json);
}
