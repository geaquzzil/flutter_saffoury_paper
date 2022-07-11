import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_types.g.dart';

@JsonSerializable()
@reflector
class ProductType extends ViewAbstract<ProductType> {
  factory ProductType.fromJson(Map<String, dynamic> data) =>
      _$ProductTypeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);

  String? date;
  String? image;
  String? name;
  String? comments;
  double purchasePrice = 0;
  // double? sellPrice;

  ProductType() : super();

  @override
  String getSubtitleHeaderTextOnly(BuildContext context) {
    return super.getSubtitleHeaderTextOnly(context);
  }

  @override
  String getHeaderTextOnly(BuildContext context) {
    return name ?? "";
  }

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductType.fromJson(json);
  }

  @override
  String getFieldLabel(String label, BuildContext context) {
    return label;
  }

  @override
  bool getTextInputTypeIsAutoCompleteViewAbstract(String field) {
    // TODO: implement getTextInputTypeIsAutoCompleteViewAbstract
    return field == "name";
  }

  @override
  Map<String, TextInputType?> getMap() => {
        "id": TextInputType.number,
        "sizes": TextInputType.number,
        "date": TextInputType.datetime,
        "products_types": TextInputType.number,
        "comments": TextInputType.multiline,
        "barcode": TextInputType.text,
        "products_count": TextInputType.number,
        "pending_reservation_invoice": TextInputType.phone,
        "cut_request_quantity": TextInputType.number,
      };
  @override
  List<String> getFields() {
    // TODO: implement getFields
    return ['name', 'date', "comments", "sellPrice", "purchasePrice"];
  }

  @override
  String? getImageUrl(BuildContext context) {
    return "https://$image";
  }

  @override
  IconData getIconData() {
    // TODO: implement getIconData
    return Icons.type_specimen_outlined;
  }

  @override
  String getLabelTextOnly(BuildContext context) {
    // TODO: implement getLabelTextOnly
    return "products_types";
  }

  @override
  String? getDrawerGroupName() {
    // TODO: implement getDrawerGroupName
    return "products";
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
    return "products_types";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
}
