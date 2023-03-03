import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/products/grades.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/test_var.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
part 'products_types.g.dart';

@JsonSerializable(explicitToJson: true)
@reflector
class ProductType extends ViewAbstract<ProductType>
    implements WebCategoryGridableInterface<ProductType> {
  // int? GradeID;

  String? name;
  ProductTypeUnit? unit;

  double? purchasePrice;
  double? sellPrice;

  String? image;
  String? comments;
  double? availability;

  Grades? grades;

  List<Product>? products;
  int? products_count;

  bool requestAvailablity = false;
  ProductType() : super();
  @override
  ProductType getSelfNewInstance() {
    return ProductType();
  }

  ProductType.init(bool requestAvailablity) {
    this.requestAvailablity = requestAvailablity;
  }

  @override
  ProductType getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    debugPrint("getSelfNewInstanceFileImporter $runtimeType value=>$value");
    if (value is int) {
      iD = value;
      return this;
    }
    int? gs = int.tryParse("$value");
    if (gs != null) {
      iD = gs;
      return this;
    } else {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)}: Cannot convert value of iD to => $value to a number");
    }
  }

  // @override
  // Future<List<ProductType>?> listCall(
  //     {int? count, int? page, OnResponseCallback? onResponse}) async {
  //   try {
  //     Iterable l = jsonDecode(jsonEncode(availabilityType));
  //     return List<ProductType>.from(
  //         l.map((model) => fromJsonViewAbstract(model)));
  //   } catch (e) {
  //     debugPrint("listCallFake ${e.toString()}");
  //   }
  //   return null;
  // }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "name": "",
        "unit": ProductTypeUnit.KG,
        "purchasePrice": 0,
        "sellPrice": 0,
        "image": "",
        "comments": "",
        "availability": 0,
        "grades": Grades(),
        "products": List<Product>.empty(),
        "products_count": 0
      };

  @override
  String getForeignKeyName() {
    return "ProductTypeID";
  }

  @override
  String? getCustomAction() {
    if (requestAvailablity) {
      return "available_product_type";
    }
    return null;
  }

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
  List<String> getMainFields({BuildContext? context}) {
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
  Map<String, dynamic> toJsonViewAbstract() => toJson();

  @override
  ProductType fromJsonViewAbstract(Map<String, dynamic> json) =>
      ProductType.fromJson(json);
  @override
  String getSortByFieldName() {
    return "name";
  }

  @override
  SortByType getSortByType() {
    return SortByType.ASC;
  }

  String getUnit(BuildContext context) {
    if (unit == null) return "-";
    return unit!.getFieldLabelString(context, unit!);
  }

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) {
    return Product()..setCustomMap({"<${getForeignKeyName()}>": getIDString()});
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) {
    return availability?.toCurrencyFormat();
  }

  @override
  ProductType getWebCategoryGridableInterface(BuildContext context) {
    return ProductType.init(true);
  }

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }
}

// enum ProductTypeUnit {
//   @JsonValue("KG")
//   KG,
//   @JsonValue("Sheet")
//   Sheet,
//   @JsonValue("Ream")
//   Ream
// }
enum ProductTypeUnit implements ViewAbstractEnum<ProductTypeUnit> {
  KG,
  Sheet,
  Ream;

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
      case Ream:
        return AppLocalizations.of(context)!.reams;
    }
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, ProductTypeUnit field) {
    switch (field) {
      case KG:
        return Icons.scale;
      case Sheet:
        return Icons.line_weight_rounded;
      case Ream:
        return Icons.table_rows_rounded;
    }
  }

  @override
  List<ProductTypeUnit> getValues() {
    return ProductTypeUnit.values;
  }
}
