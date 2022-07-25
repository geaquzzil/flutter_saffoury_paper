import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_saffoury_paper/models/products/warehouse.dart';
import 'package:flutter_view_controller/models/va_mirrors.dart';
import 'package:json_annotation/json_annotation.dart';

import '../invoice_master.dart';
import '../invoice_master_details.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'products_outputs.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutput extends InvoiceMaster<ProductOutput> {
  // int? WarehouseID;

  List<ProductOutputDetails>? products_outputs_details;
  int? products_outputs_details_count;

  Warehouse? warehouse;

  ProductOutput() : super();

  @override
  String? getTableNameApi() => "products_outputs";

  @override
  List<String>? requireObjectsList() => ["products_outputs_details"];

  @override
  List<String> getMainFields() {
    List<String> list = super.getMainFields();
    list.remove("status");
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
}

@JsonSerializable(explicitToJson: true)
@reflector
class ProductOutputDetails extends InvoiceMasterDetails<ProductOutputDetails> {
  // int? ProductOutputID;

  ProductOutput? products_outputs;

  ProductOutputDetails() : super();

  @override
  String? getTableNameApi() => "products_outputs";

  @override
  List<String> getMainFields() => ["products", "quantity", "comments"];

  factory ProductOutputDetails.fromJson(Map<String, dynamic> data) =>
      _$ProductOutputDetailsFromJson(data);

  Map<String, dynamic> toJson() => _$ProductOutputDetailsToJson(this);

  @override
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductOutputDetails fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductOutputDetails.fromJson(json);
}