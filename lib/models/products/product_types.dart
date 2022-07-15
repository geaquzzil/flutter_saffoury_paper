import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_api.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'product_types.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductType extends ViewAbstract<ProductType> {
  String? name;
  Grades? grades;
  ProductTypeUnit? unit;

  double? purchasePrice;
  double? sellPrice;

  String? image;

  String? comments;
  double? availability;

  ProductType() : super();
  @override
  String? getMainDrawerGroupName(BuildContext context) {
    return AppLocalizations.of(context)!.product;
  }

  @override
  IconData getMainIconData() {
    return Icons.type_specimen_outlined;
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    return name ?? "";
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    return AppLocalizations.of(context)!.products_type;
  }

  @override
  List<String> getMainFields() {
    return [
      'name',
      'grades',
      'purchasePrice',
      "sellPrice",
      "image",
      "comments",
      "unit"
    ];
  }

  @override
  Map<String, bool> isFieldRequiredMap() =>
      {"name": true, "sellPrice": true, "purchasePrice": true};

  @override
  Map<String, TextInputType?> getTextInputTypeMap() => {
        "name": TextInputType.text,
        "sellPrice": TextInputType.number,
        "purchasePrice": TextInputType.number,
        "comments": TextInputType.multiline,
      };
  @override
  Map<String, int> getTextInputMaxLengthMap() =>
      {"name": 50, "sellPrice": 8, "purchasePrice": 8};
  @override
  bool hasImageLoadButton() {
    return true;
  }

  @override
  String? getImageUrl(BuildContext context) {
    if (image == null) return null;
    if (image?.isEmpty ?? true) return null;
    return "https://$image";
  }

  @override
  String? getTableNameApi() {
    return "products_types";
  }

  @override
  Map<String, IconData> getFieldIconDataMap() => {
        "name": Icons.text_fields,
        "sellPrice": Icons.price_change,
        "purchasePrice": Icons.price_change,
        "image": Icons.image,
        "comments": Icons.notes,
      };

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) => {
        "name": AppLocalizations.of(context)!.name,
        "sellPrice": AppLocalizations.of(context)!.sellPrice,
        "purchasePrice": AppLocalizations.of(context)!.purchases_price,
        "image": AppLocalizations.of(context)!.loadImage,
        "comments": AppLocalizations.of(context)!.comments,
      };

  @override
  Map<String, bool> getTextInputIsAutoCompleteMap() => {};

  @override
  Map<String, bool> getTextInputIsAutoCompleteViewAbstractMap() =>
      {"name": true};

  @override
  Map<String, double> getTextInputMaxValidateMap() => {};

  @override
  Map<String, double> getTextInputMinValidateMap() => {};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {"grades": true};

  factory ProductType.fromJson(Map<String, dynamic> data) =>
      _$ProductTypeFromJson(data);

  Map<String, dynamic> toJson() => _$ProductTypeToJson(this);

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) {
    return ProductType.fromJson(json);
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    return toJson();
  }
}

// enum ProductTypeUnit { KG, Sheet }
enum ProductTypeUnit implements ViewAbstractEnum<ProductTypeUnit>  {
  KG,
  Sheet;

  @override
  IconData getMainIconData() => Icons.stacked_line_chart_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;

  @override
  String getFieldLabelString(BuildContext context, ProductTypeUnit field) {
    switch (field) {
      case KG:
        return AppLocalizations.of(context)!.kg;
      case Sheet:
        return AppLocalizations.of(context)!.sheets;
    }
    return " ";
  }


  @override
  List<ProductTypeUnit> getValues() {
    return ProductTypeUnit.values;
  }
}
