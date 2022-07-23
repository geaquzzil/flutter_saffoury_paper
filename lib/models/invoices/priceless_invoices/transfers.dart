import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'transfers.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Transfers extends InvoiceMaster<Transfers> {
  Warehouse? fromWarehouse;
  Warehouse? toWarehouse;

  List<TransfersDetails>? transfers_details;
  int? trasfers_details_count;

  Transfers() : super();

  @override
  String? getTableNameApi() => "transfers";

  @override
  List<String>? requireObjectsList() => ["transfers_details"];

  @override
  List<String> getMainFields() {
    List<String> list = super.getMainFields();
    list.add("fromWarehouse");
    list.add("toWarehouse");
    list.remove("status");
    return list;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.transfers;
}

@JsonSerializable(explicitToJson: true)
@reflector
class TransfersDetails extends InvoiceMasterDetails<TransfersDetails> {
  int? TransferID;
  Transfers? transfers;
  TransfersDetails() : super();

  @override
  String? getTableNameApi() => "transfers_details";

  @override
  List<String> getMainFields() => ["products", "quantity", "comments"];

  @override
  TransfersDetails fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }
}
