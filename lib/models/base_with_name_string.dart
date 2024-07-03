import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/converters.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonIntToString()
abstract class BaseWithNameString<T> extends ViewAbstract<T>
    implements WebCategoryGridableInterface<ViewAbstract> {
  @JsonKey(
    fromJson: intFromString,
  )
  String? name;

  BaseWithNameString() : super();
  @override
  T getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    if (value == null) {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)} cant convert empty value for the field => name");
    } else if (value.toString().isEmpty) {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)} cant convert empty value for the field => name");
    } else if (value.toString() == "null") {
      throw Exception(
          "${getMainHeaderLabelTextOnly(context)} cant convert empty value for the field => name");
    } else {
      name = value.toString();
    }
    return this as T;
  }

  @override
  Map<String, dynamic> getMirrorFieldsMapNewInstance() => {
        "name": "",
      };

  @override
  // Map<String, dynamic> getMirrorFieldsMapNewInstance() => {"name": ""};

  @override
  List<String> getMainFields({BuildContext? context}) => ["name"];

  @override
  String getMainHeaderTextOnly(BuildContext context) =>
      name ?? "not found for $T";

  @override
  String? getSortByFieldName() => "name";
  @override
  String getFieldToReduceSize() {
    return "name";
  }

  @override
  SortByType getSortByType() => SortByType.DESC;

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
  Map<String, TextInputType?> getTextInputTypeMap() =>
      {"name": TextInputType.text};

  @override
  Map<String, bool> isFieldCanBeNullableMap() => {};

  @override
  Map<String, bool> isFieldRequiredMap() => {"name": true};

  @override
  Map<String, IconData> getFieldIconDataMap() => {"name": getMainIconData()};

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) =>
      {"name": getMainHeaderLabelTextOnly(context)};
  static String? intFromString(dynamic number) => number?.toString();

  @override
  String getWebCategoryGridableTitle(BuildContext context) {
    return getMainHeaderTextOnly(context);
  }

  @override
  String? getWebCategoryGridableDescription(BuildContext context) => null;

  @override
  ViewAbstract? getWebCategoryGridableIsMasterToList(BuildContext context) =>
      Product()..setCustomMap({"<${getForeignKeyName()}>": getIDString()});

  @override
  BaseWithNameString getWebCategoryGridableInterface(BuildContext context) {
    return this;
  }
}
