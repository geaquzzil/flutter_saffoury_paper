import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import 'invoice_master.dart';
import 'invoice_master_details.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'products_inputs.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductInput extends InvoiceMaster<ProductInput> {
  int? WarehouseID;

  List<ProductInputDetails>? products_inputs_details;
  int? products_inputs_details_count;

  Warehouse? warehouse;

  ProductInput() : super();

  @override
  String? getTableNameApi() => "products_inputs";

  @override
  List<String>? requireObjectsList() => ["products_inputs_details"];

  @override
  List<String> getMainFields() {
    List<String> list = super.getMainFields();
    list.add("warehouse");
    return list;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) =>
      AppLocalizations.of(context)!.productsInput;

  @override
  ProductInput fromJsonViewAbstract(Map<String, dynamic> json) {
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
class ProductInputDetails extends InvoiceMasterDetails<ProductInputDetails> {
  ProductInput? products_input;

  ProductInputDetails() : super();

  @override
  List<String> getMainFields() => ["products", "quantity", "comments"];
  @override
  String? getTableNameApi() => "products_inputs_details";

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  ProductInputDetails fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }
}
