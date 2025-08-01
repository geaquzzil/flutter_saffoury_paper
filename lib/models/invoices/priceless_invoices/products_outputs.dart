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

part 'products_outputs.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutput extends InvoiceMaster<ProductOutput> {
  // int? WarehouseID;

  List<ProductOutputDetails>? products_outputs_details;
  int? products_outputs_details_count;

  Warehouse? warehouse;

  ProductOutput() : super() {
    products_outputs_details = <ProductOutputDetails>[];
  }

  @override
  ProductOutput getSelfNewInstance() {
    return ProductOutput();
  }

  @override
  String getForeignKeyName() {
    return "ProductOutputID";
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "products_outputs_details": List<ProductOutputDetails>.empty(),
          "products_outputs_details_count": 0,
          "warehouse": Warehouse()
        });

  @override
  String? getTableNameApi() => "products_outputs";

  @override
  List<String> getMainFields({BuildContext? context}) {
    List<String> list = super.getMainFields(context: context);
    list.add("warehouse");
    return list;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.productsOutput;

  factory ProductOutput.fromJson(Map<String, dynamic> data) =>
      _$ProductOutputFromJson(data);

  Map<String, dynamic> toJson() => _$ProductOutputToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductOutput fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductOutput.fromJson(json);

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    return ["products_outputs_details"];
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutputDetails extends InvoiceMasterDetails<ProductOutputDetails> {
  // int? ProductOutputID;

  ProductOutput? products_outputs;

  ProductOutputDetails() : super();

  @override
  ProductOutputDetails getSelfNewInstance() {
    return ProductOutputDetails();
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({"products_outputs": ProductOutput()});

  @override
  String? getTableNameApi() => "products_outputs";

  @override
  List<String> getMainFields({BuildContext? context}) =>
      ["products", "quantity", "comments"];

  factory ProductOutputDetails.fromJson(Map<String, dynamic> data) =>
      _$ProductOutputDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$ProductOutputDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductOutputDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductOutputDetails.fromJson(json);
}
