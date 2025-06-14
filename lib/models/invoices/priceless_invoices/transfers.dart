import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_permissions.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';

part 'transfers.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Transfers extends InvoiceMaster<Transfers> {
  Warehouse? fromWarehouse;
  Warehouse? toWarehouse;

  List<TransfersDetails>? transfers_details;
  int? trasfers_details_count;

  Transfers() : super() {
    transfers_details = <TransfersDetails>[];
  }
  @override
  Transfers getSelfNewInstance() {
    return Transfers();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "fromWarehouse": Warehouse(),
          "toWarehouse": Warehouse(),
          "transfers_details": List<TransfersDetails>.empty(),
          "trasfers_details_count": 0
        });

  @override
  String? getTableNameApi() => "transfers";

  @override
  Map<ServerActions, List<String>>? canGetObjectWithoutApiCheckerList() => {
        ServerActions.list: ["transfers_details"],
      };
  @override
  List<String> getMainFields({BuildContext? context}) {
    List<String> list = super.getMainFields(context: context);
    list.add("fromWarehouse");
    list.add("toWarehouse");
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

  @override
  bool isListableIsImagable() {
    return false;
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class TransfersDetails extends InvoiceMasterDetails<TransfersDetails> {
  // int? TransferID;
  Transfers? transfers;
  TransfersDetails() : super();
  @override
  TransfersDetails getSelfNewInstance() {
    return TransfersDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "transfers": Transfers(),
        });

  @override
  String? getTableNameApi() => "transfers_details";

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["products", "quantity", "comments"];

  factory TransfersDetails.fromJson(Map<String, dynamic> data) =>
      _$TransfersDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$TransfersDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  TransfersDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      TransfersDetails.fromJson(json);
}
