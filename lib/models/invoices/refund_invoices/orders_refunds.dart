import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master.dart';
import 'package:flutter_saffoury_paper/models/invoices/invoice_master_details.dart';
import 'package:flutter_saffoury_paper/models/invoices/orders.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'orders_refunds.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefund extends InvoiceMaster<OrderRefund> {
  int? OrderID;

  Order? orders;

  List<OrderRefundDetails>? orders_refunds_order_details;
  int? orders_refunds_order_details_count;

  OrderRefund() : super();

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizes;

  @override
  String? getTableNameApi() => "orders_refunds";

  @override
  List<String>? requireObjectsList() => ["orders_refunds_order_details"];

  @override
  List<String> getMainFields() =>
      ["orders", "cargo_transporters", "date", "billNo", "comments"];

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  OrderRefund fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class OrderRefundDetails extends InvoiceMasterDetails<OrderRefund> {
  int? OrderID;
  int? OrderDetailsID;
  int? OrderRefundID;
  int? WarehouseID;

  OrderRefund? orders_refunds;
  Order? orders;
  OrderDetails? orders_details;
  

  OrderRefundDetails() : super();
  OrderRefundDetails setOrder(Order orders) {
    //TODO: implement this
    return this;
  }

  @override
  String? getTableNameApi() => "orders_refunds_order_details";

  @override
  List<String> getMainFields() =>
      ["products", "warehouse", "quantity", "comments"];

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  OrderRefund fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
