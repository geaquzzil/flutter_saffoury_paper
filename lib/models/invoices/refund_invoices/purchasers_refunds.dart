import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import '../invoice_master.dart';
import '../invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'purchasers_refunds.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefund extends InvoiceMaster<PurchasesRefund> {
  // int? PurchasesID;

  Purchases? purchases;
  List<PurchasesRefundDetails>? purchases_refunds_purchases_details;
  int? purchases_refunds_purchases_details_count;

  PurchasesRefund() : super();
  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.customerRequestSizes;

  @override
  String? getTableNameApi() => "purchasers_refunds";

  @override
  List<String>? requireObjectsList() => ["purchases_refunds_purchases_details"];

  @override
  List<String> getMainFields() =>
      ["purchases", "cargo_transporters", "date", "billNo", "comments"];

  factory PurchasesRefund.fromJson(Map<String, dynamic> data) =>
      _$PurchasesRefundFromJson(data);

  Map<String, dynamic> toJson() => _$PurchasesRefundToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  PurchasesRefund fromJsonViewAbstract(Map<String, dynamic> json) =>
      PurchasesRefund.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefundDetails
    extends InvoiceMasterDetails<PurchasesRefundDetails> {
  // int? PurchaseID;
  // int? PurchaseRefundID;
  // int? PurchaseDetailsID;
  // int? WarehouseID;

  Purchases? purchases;
  PurchasesRefund? purchases_refunds;
  PurchasesDetails? purchases_details;

  PurchasesRefundDetails() : super();
  PurchasesRefundDetails setPurchases(Purchases purchases) {
    //TODO: implement this
    return this;
  }

  @override
  String? getTableNameApi() => "purchases_refunds_purchases_details";

  @override
  List<String> getMainFields() =>
      ["products", "warehouse", "quantity", "comments"];

  factory PurchasesRefundDetails.fromJson(Map<String, dynamic> data) =>
      _$PurchasesRefundDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$PurchasesRefundDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  PurchasesRefundDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      PurchasesRefundDetails.fromJson(json);
}
