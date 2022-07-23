import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/purchases.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'purchasers_refunds.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefund extends InvoiceMaster<PurchasesRefund> {
  int? PurchasesID;

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

  @override
  PurchasesRefund fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesRefundDetails
    extends InvoiceMasterDetails<PurchasesRefundDetails> {
  int? PurchaseID;
  int? PurchaseRefundOD;
  int? PurchaseDetailsID;
  int? WarehouseID;

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

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  PurchasesRefundDetails fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
