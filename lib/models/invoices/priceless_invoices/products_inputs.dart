import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/interfaces/listable_interface.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_saffoury_paper/models/invoices/cargo_transporters.dart';
import 'package:flutter_saffoury_paper/models/users/customers.dart';
import 'package:flutter_saffoury_paper/models/users/employees.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'products_inputs.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInput extends InvoiceMaster<ProductInput>
    implements ListableInterface<ProductInputDetails> {
  // int? WarehouseID;

  List<ProductInputDetails>? products_inputs_details;
  int? products_inputs_details_count;

  Warehouse? warehouse;

  ProductInput() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "products_inputs_details": List<ProductInputDetails>.empty(),
          "products_inputs_details_count": 0,
          "warehouse": Warehouse()
        });

  @override
  String? getTableNameApi() => "products_inputs";

  @override
  List<String>? isRequiredObjectsList() => ["products_inputs_details"];

  @override
  List<String> getMainFields() {
    List<String> list = super.getMainFields();
    list.remove("status");
    list.add("warehouse");
    return list;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.productsInput;

  factory ProductInput.fromJson(Map<String, dynamic> data) =>
      _$ProductInputFromJson(data);

  Map<String, dynamic> toJson() => _$ProductInputToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductInput fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductInput.fromJson(json);

  @override
  List<ProductInputDetails> getListableList(BuildContext context) {
    return products_inputs_details ?? [];
  }
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInputDetails extends InvoiceMasterDetails<ProductInputDetails> {
  // int? ProductInputID;
  ProductInput? products_inputs;

  ProductInputDetails() : super();

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() =>
      super.getMirrorFieldsMapNewInstance()
        ..addAll({
          "products_inputs": ProductInput(),
        });

  @override
  List<String> getMainFields() => ["products", "quantity", "comments"];
  @override
  String? getTableNameApi() => "products_inputs_details";

  factory ProductInputDetails.fromJson(Map<String, dynamic> data) =>
      _$ProductInputDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$ProductInputDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductInputDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductInputDetails.fromJson(json);
}
