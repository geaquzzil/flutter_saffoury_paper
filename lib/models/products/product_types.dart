import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
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
  Grades? grades;
  String? image;
  String? name;
  String? comments;
  double? purchasePrice;
  double? sellPrice;

  ProductType() : super();

  @override
  String getMainSubtitleTextOnly(BuildContext context) {
    return super.getMainSubtitleTextOnly(context);
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return name ?? "";
  }

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductType.fromJson(json);
  }

  @override
  bool getTextInputTypeIsAutoCompleteViewAbstract(String field) {
    // TODO: implement getTextInputTypeIsAutoCompleteViewAbstract
    return field == "name";
  }

  @override
  bool isFieldRequired(String field) {
    // TODO: implement isFieldRequired
    return field == "purchasePrice" || field == "sellPrice" || field == "name";
  }

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
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
  List<String> getMainFields() {
    // TODO: implement getFields
    return ['name', 'date', "comments", "sellPrice", "purchasePrice"];
  }

  @override
  String? getImageUrl(BuildContext context) {
    if (image == null) return null;
    if (image?.isEmpty ?? true) return null;
    return "https://$image";
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getIconData
    return Icons.type_specimen_outlined;
  }

  @override
  String getMainLabelTextOnly(BuildContext context) {
    // TODO: implement getLabelTextOnly
    return "products_types";
  }

  @override
  String? getMainDrawerGroupName() {
    // TODO: implement getDrawerGroupName
    return "products";
  }

  @override
  String? getTableNameApi() {
    return "products_types";
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String getMainLabelSubtitleTextOnly(BuildContext context) {
    // TODO: implement getMainLabelSubtitleTextOnly
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputHintMap(BuildContext context) {
    // TODO: implement getTextInputHintMap
    throw UnimplementedError();
  }

  @override
  Map<String, IconData> getTextInputIconMap() => {
        "id": Icons.account_balance_wallet_sharp,
        "sizes": Icons.sanitizer,
        "comments": Icons.comment
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() {
    // TODO: implement getTextInputIsAutoCompleteMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() {
    // TODO: implement getTextInputIsAutoCompleteViewAbstractMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getTextInputLabelMap(BuildContext context) {
    // TODO: implement getTextInputLabelMap
    throw UnimplementedError();
  }

  @override
  Map<String, int> getTextInputMaxLengthMap() {
    // TODO: implement getTextInputMaxLengthMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMaxValidateMap() {
    // TODO: implement getTextInputMaxValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, double> getTextInputMinValidateMap() {
    // TODO: implement getTextInputMinValidateMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldCanBeNullableMap() {
    // TODO: implement isFieldCanBeNullableMap
    throw UnimplementedError();
  }

  @override
  Map<String, bool> isFieldRequiredMap() {
    // TODO: implement isFieldRequiredMap
    throw UnimplementedError();
  }
}
