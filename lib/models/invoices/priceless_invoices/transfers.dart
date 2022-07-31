import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
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
  factory Transfers.fromJson(Map<String, dynamic> data) =>
      _$TransfersFromJson(data);

  Map<String, dynamic> toJson() => _$TransfersToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  Transfers fromJsonViewAbstract(Map<String, dynamic> json) =>
      Transfers.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
@reflector
class TransfersDetails extends InvoiceMasterDetails<TransfersDetails> {
  // int? TransferID;
  Transfers? transfers;
  TransfersDetails() : super();

  @override
  String? getTableNameApi() => "transfers_details";

  @override
  List<String> getMainFields() => ["products", "quantity", "comments"];

  factory TransfersDetails.fromJson(Map<String, dynamic> data) =>
      _$TransfersDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$TransfersDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  TransfersDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      TransfersDetails.fromJson(json);
}
