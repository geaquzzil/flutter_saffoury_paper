import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ViewAbstractFilterable<T> extends ViewAbstractLists<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? searchByAutoCompleteTextInput;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, FilterableProviderHelper>? _lastFilterableMap;

  String? getSortByFieldName();
  SortByType getSortByType();

  String getForeignKeyName() {
    return getTableNameApi() ?? " no_foreign_key";
  }

  String getFieldToReduceSize() {
    return "iD";
  }

  bool isSortAvailable() => getSortByFieldName() != null;

  List<String> getFilterableFields() => getMainFields();

  List<CustomFilterableField> getCustomFilterableFields(BuildContext context) =>
      [
        CustomFilterableField(
            this as ViewAbstract,
            AppLocalizations.of(context)!.date,
            Icons.date_range,
            "date",
            "date",
            "",
            type: TextInputType.datetime)
      ];
  String getSortByFieldNameApi() {
    return getSortByFieldName() ?? "";
  }

  String getFilterableFieldNameApi(String field) {
    return "<$field>";
  }

  bool hasPermssionFilterable(BuildContext context, ViewAbstract viewAbstract) {
    return hasPermissionList(context, viewAbstract: viewAbstract);
  }

  bool hasPermssionFilterableField(BuildContext context, String field) {
    return true;
  }

  String getListableKeyWithoutCustomMap() {
    return "${getTableNameApi()}listAPI$_lastFilterableMap";
  }

  String getListableKey() {
    return "${getTableNameApi()}listAPI$_lastFilterableMap$getCustomMap";
  }

  void setFilterableMap(Map<String, FilterableProviderHelper> map) {
    _lastFilterableMap = map;
    debugPrint("setFilterableMap=> $map");
    Map<String, String> bodyMap = {};
    map.forEach((key, value) {
      if (key == FilterableProvider.SORTKEY) {
        bodyMap[map[key]!.fieldNameApi] = map[key]!.getValue();
      } else {
        bodyMap["<${map[key]!.fieldNameApi}>"] = map[key]!.getValue();
      }
    });
    debugPrint("setFilterableMap bodyMap $bodyMap");
    setCustomMap(bodyMap);
  }
}

// enum SortByType {
//   @JsonValue("ASC")
//   ASC,
//   @JsonValue("DESC")
//   DESC }

enum SortByType implements ViewAbstractEnum<SortByType> {
  ASC,
  DESC;

  @override
  IconData getMainIconData() => Icons.sort;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.sortBy;

  @override
  String getFieldLabelString(BuildContext context, SortByType field) {
    switch (field) {
      case ASC:
        return AppLocalizations.of(context)!.ascSorting;
      case DESC:
        return AppLocalizations.of(context)!.descSorting;
    }
    return " ";
  }

  @override
  IconData getFieldLabelIconData(BuildContext context, SortByType field) {
    switch (field) {
      case ASC:
        return Icons.text_rotate_up;
      case DESC:
        return Icons.text_rotate_vertical;
    }
  }

  @override
  List<SortByType> getValues() {
    return SortByType.values;
  }
}

class CustomFilterableField {
  ViewAbstract parent;
  String title;
  IconData icon;
  String field;
  String fieldNameApi;
  TextFieldTheming theme;
  dynamic object;
  TextInputType? type;
  bool? singleChoiceIfList;
  CustomFilterableField(this.parent, this.title, this.icon, this.field,
      this.fieldNameApi, this.object,
      {this.type, this.singleChoiceIfList})
      : theme = TextFieldTheming(lableText: title, icon: icon);
}
// class FilterableProviderHelperListItem {
//   //The field Label
//   String labelText;
// //wich contains the field text
//   String valueLabelText;
//   //witch contains the iD
//   Object? valueApi;

// //   FilterableProviderHelperListItem(
// //       this.labelText, this.valueLabelText, this.valueApi);
// // }
