import 'package:flutter/material.dart';
import 'package:flutter_saffoury_paper/models/converters.dart';
import 'package:flutter_saffoury_paper/models/products/products.dart';
import 'package:flutter_saffoury_paper/models/server/server_data_api.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/models/view_abstract_inputs_validaters.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

@JsonIntToString()
abstract class BaseWithNameString<T> extends ViewAbstract<T>
    implements WebCategoryGridableInterface<ViewAbstract> {
  @JsonKey(
    fromJson: intFromString,
  )
  String? name;

  BaseWithNameString() : super();
  @override
  T? getSelfNewInstanceFileImporter(
      {required BuildContext context, String? field, value}) {
    FilterableDataApi? filterData = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getLastFilterableData() as FilterableDataApi?;
    if (value == null) return null;
    if (filterData != null) {
      BaseWithNameString? getSearchedValue = filterData.searchForValue(
        this,
        value,
        (p0) =>
            p0.name == value.toString() || p0.iD.toString() == value.toString(),
      );
      if (getSearchedValue != null) {
        return getSearchedValue as T;
      }
    } else {
      name = value.toString();
    }
    return null;
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
  String getFieldToReduceSize() {
    return "name";
  }

  @override
  FormFieldControllerType getInputType(String field) {
    if ("name" == field) {
      return FormFieldControllerType.AUTO_COMPLETE_VIEW_ABSTRACT_RESPONSE;
    }
    return super.getInputType(field);
  }

  @override
  SortFieldValue? getSortByInitialType() =>
      SortFieldValue(field: "name", type: SortByType.DESC);

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
