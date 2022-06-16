import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/product_types.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:json_annotation/json_annotation.dart';

import 'sizes.dart';

// @reflector
part 'products.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class Product extends ViewAbstract<Product> {
  ProductType? products_types;
  String? thisIsATest;

  Size? sizes;

  String? comments;
  String? barcode;
  String? products_count;

  double? pending_reservation_invoice;
  double? cut_request_quantity;

  Product() : super();


  @override
  Text getSubtitleHeaderText(BuildContext context) {
    return Text("pending_reservation_invoice    $pending_reservation_invoice");
  }

  @override
  String getHeaderTextOnly(BuildContext context) {
    String? productType = products_types?.getHeaderTextOnly(context);
    String? size = sizes?.getHeaderTextOnly(context);
    return "$productType $size";
  }

  @override
  String? getImageUrl(BuildContext context) {
    return "https://${products_types?.image}";
  }

  @override
  Product fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    return Product.fromJson(json);
  }

  @override
  String? getTableNameApi() {
    // TODO: implement getTableNameApi
    return "products";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  factory Product.fromJson(Map<String, dynamic> data) =>
      _$ProductFromJson(data);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String getFieldLabel(String label, BuildContext context) {
    // TODO: implement getFieldLabel
    return label;
  }

  @override
  List<String> getFields() {
    // TODO: implement getFields
    return [
      "iD",
      "sizes",
      "products_types",
      "comments",
      "barcode",
      "products_count",
      "pending_reservation_invoice",
      "cut_request_quantity"
    ];
  }

  @override
  IconData getIconData() {
    return Icons.account_balance_wallet_sharp;
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
}
