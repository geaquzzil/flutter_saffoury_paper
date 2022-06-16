import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_types.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductType extends ViewAbstract<ProductType> {
  factory ProductType.fromJson(Map<String, dynamic> data) =>
      _$ProductTypeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);

  String? date;
  String? image;
  String? name;
  String? comments;

  ProductType() : super();

  @override
  String getHeaderTextOnly(BuildContext context) {
    // TODO: implement getHeaderTextOnly
    return name ?? "";
  }

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    return ProductType.fromJson(json);
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    // TODO: implement getFieldLabel
    return label;
  }

  @override
  List<String> getFields() {
    // TODO: implement getFields
    return [];
  }

  @override
  IconData getIconData() {
    // TODO: implement getIconData
    return Icons.type_specimen_outlined;
  }

  @override
  IconData getFieldIconData(String label) {
  switch (label) {
      case "id":
        return Icons.account_balance_wallet_sharp;
      case "sizes":
        return Icons.sanitizer;
      case "comments":
        return Icons.comment;
    }
    return Icons.account_balance_wallet_sharp;
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    return "products_types";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    return toJson();
  }
}
