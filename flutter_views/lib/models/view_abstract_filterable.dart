// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/new_components/lists/headers/sort_icon.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:json_annotation/json_annotation.dart';

class SortFieldValue {
  String field;
  SortByType type;

  SortFieldValue({
    required this.field,
    required this.type,
  });

  @override
  String toString() => getMap().toString();
  Map<String, String> getMap() {
    return {type.name: field};
  }

  DropdownStringListItem? getDropdownStringListItem(
      BuildContext context, ViewAbstract parent) {
    return DropdownStringListItem(
        label: parent.getFieldLabel(context, field),
        icon: parent.getFieldIconData(field),
        value: field);
  }
}

abstract class ViewAbstractFilterable<T> extends ViewAbstractLists<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? searchByAutoCompleteTextInput;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, FilterableProviderHelper>? _lastFilterableMap;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? _lastFilterableFieldName;

  @JsonKey(includeFromJson: false, includeToJson: false)
  SortByType? _lastFilterableSortType;

  SortFieldValue? getSortByInitialType();

  @JsonKey(includeFromJson: false, includeToJson: false)
  SortFieldValue? _sortFieldValue;

  //set initial value  if
  SortFieldValue? get getSortFieldValue =>
      this._sortFieldValue ?? getSortByInitialType();

  set setSortFieldValue(SortFieldValue? value) => this._sortFieldValue = value;

  String getForeignKeyName() {
    return getTableNameApi() ?? " no_foreign_key";
  }

  String getFieldToReduceSize() {
    return "iD";
  }

  bool isSortAvailable() => getSortFieldValue != null;

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
    return getSortFieldValue?.field ?? "";
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

  Map<String, String> getFilterableMap(
      Map<String, FilterableProviderHelper>? map) {
    if (map == null) return {};
    debugPrint("getFilterableMap=> $map");
    Map<String, String> bodyMap = {};
    map.forEach((key, value) {
      bodyMap["<${map[key]!.fieldNameApi}>"] = map[key]!.getValue();
    });
    debugPrint("getFilterableMap bodyMap $bodyMap");
    return bodyMap;
  }

  void setFilterableMap(Map<String, FilterableProviderHelper> map) {
    _lastFilterableMap = map;
    setCustomMap(getFilterableMap(map));
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
