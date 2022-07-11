import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/product_types.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

import 'sizes.dart';

// @reflector
part 'products.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
@reflector
class Product extends ViewAbstract<Product> {
  ProductType? products_types;

  Size? sizes;
  String? date;

  String? comments;
  String? barcode;

  Product() : super();

  @override
  bool getTextInputTypeIsAutoComplete(String field) {
    // TODO: implement getTextInputTypeIsAutoComplete
    return field == "barcode";
  }

  @override
  void onCardDismissedView(BuildContext context, DismissDirection direction) {
    if (direction == DismissDirection.endToStart) {
      context.read<CartProvider>().add(this);
    }
  }

  @override
  Text getSubtitleHeaderText(BuildContext context) {
    return Text("pending_reservation_invoice ");
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
  String getLabelTextOnly(BuildContext context) {
    // TODO: implement getLabelTextOnly
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
  bool isFieldCanBeNullable(BuildContext context, String field) {
    return field == "sizes";
  }

  @override
  List<String> getFields() {
    // TODO: implement getFields
    return [
      "iD",
      "sizes",
      "products_types",
      "date",
      "comments",
      "barcode",
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
      case "date":
        return Icons.date_range;
    }
    return Icons.account_balance_wallet_sharp;
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
}
