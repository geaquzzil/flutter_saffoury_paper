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
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.add_card_rounded);
  }

  @override
  Text getSubtitleHeaderText(BuildContext context) {
    return Text("pending_reservation_invoice    $pending_reservation_invoice");
  }

  @override
  Text? getHeaderText(BuildContext context) {
    return Text("${sizes?.width?.toString()}");
  }

  @override
  Text? getLabelText(BuildContext context) {
    return Text(iD.toString());
  }

  @override
  String? getImageUrl(BuildContext context) {
    return products_type?.image;
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
    // TODO: implement toJsonViewAbstract
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
      "id",
      "sizes",
      "product_types",
      "comments",
      "barcode",
      "products_count",
      "pending_reservation_invoice",
      "cut_request_quantity"
    ];
  }

  @override
  IconData getIconData(BuildContext context) {
    // TODO: implement getIconData
    return Icons.account_balance_wallet_sharp;
  }

  @override
  IconData getIconDataField(String label, BuildContext context) {
    // TODO: implement getIconDataField
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
