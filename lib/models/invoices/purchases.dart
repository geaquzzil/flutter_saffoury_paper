import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/invoices/refund_invoices/purchasers_refunds.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';

part 'purchases.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Purchases extends InvoiceMaster<Purchases> {
  List<PurchasesDetails>? purchases_details;
  int? purchases_details_count;

  List<PurchasesRefund>? purchases_refunds;
  int? purchases_refunds_count;

  Purchases() : super() {
    purchases_details = <PurchasesDetails>[];
  }
  @override
  Purchases getSelfNewInstance() {
    return Purchases();
  }

  @override
  String? getTableNameApi() => "purchases";
  @override
  String getForeignKeyName() {
    return "PurchaseID";
  }

  @override
  Map<ServerActions, List<String>>? canGetObjectWithoutApiCheckerList() => {
        ServerActions.add: ["purchases_details"],
        ServerActions.edit: ["purchases_details"],
        ServerActions.view: ["purchases_details"],
      };

  @override
  bool canGetObjectWithoutApiChecker(ServerActions action) {
    return purchases_details?.length == purchases_details_count;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.purchases;

  factory Purchases.fromJson(Map<String, dynamic> data) =>
      _$PurchasesFromJson(data);

  Map<String, dynamic> toJson() => _$PurchasesToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Purchases fromJsonViewAbstract(Map<String, dynamic> json) =>
      Purchases.fromJson(json);

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "purchases_details": List<PurchasesDetails>.empty(),
          "purchases_details_count": 0,
          "purchases_refunds": List<PurchasesRefund>.empty(),
          "purchases_refunds_count": 0,
        });

  // @override
  // PrintableInvoiceInterface getModifiablePrintablePdfSetting(
  //     BuildContext context) {
  //   Purchases o = Purchases();
  //   debugPrint("getModifiablePrintablePdfSetting ${o.runtimeType}");
  //   (o).customers = Customer()..name = "Customer name";
  //   o.customers?.address = "Damascus - Syria";
  //   o.customers?.phone = "099999999";
  //   o.cargo_transporters = CargoTransporter();
  //   o.cargo_transporters?.governorates = Governorate()..name = "Damascus";
  //   o.cargo_transporters?.name = "Driver name";
  //   o.cargo_transporters?.carNumber = "Driver car number";
  //   o.employees = Employee()..name = "Employee name";
  //   o.purchases_details ??= [];
  //   o.purchases_details?.add(PurchasesDetails());
  //   debugPrint("getModifiablePrintablePdfSetting $o");
  //   return o;
  // }
}

@JsonSerializable(explicitToJson: true)
@reflector
class PurchasesDetails extends InvoiceMasterDetails<PurchasesDetails> {
  // int? PurchaseID;

  Purchases? purchases;
  PurchasesDetails() : super();

  @override
  String getForeignKeyName() {
    return "PurchaseRefundID";
  }

  @override
  PurchasesDetails getSelfNewInstance() {
    return PurchasesDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "purchases": Purchases(),
        });

  @override
  String? getTableNameApi() => "purchases_details";

  factory PurchasesDetails.fromJson(Map<String, dynamic> data) =>
      _$PurchasesDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$PurchasesDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  PurchasesDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      PurchasesDetails.fromJson(json);
}
