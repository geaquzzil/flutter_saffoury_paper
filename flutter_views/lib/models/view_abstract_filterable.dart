// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';
import 'package:flutter_view_controller/new_screens/controllers/controller_dropbox_list.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:json_annotation/json_annotation.dart';

import 'servers/server_helpers.dart';

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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'field': field});
    result.addAll({'type': _$SortByType[type]});

    return result;
  }

  factory SortFieldValue.fromMap(Map<String, dynamic> map) {
    return SortFieldValue(
        field: map['field'] ?? '',
        type: $enumDecode(_$SortByType, map['type']));
  }

  String toJson() => json.encode(toMap());

  factory SortFieldValue.fromJson(String source) =>
      SortFieldValue.fromMap(json.decode(source));
}

abstract class ViewAbstractFilterable<T> extends ViewAbstractLists<T> {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? searchByAutoCompleteTextInput;

  String getForeignKeyName() {
    return getTableNameApi() ?? " no_foreign_key";
  }

  String getFieldToReduceSize() {
    return "iD";
  }

  Map<String, FilterableProviderHelper>? getLastFilterableMap(
          {ServerActions action = ServerActions.list}) =>
      getRequestOption(action: action)?.filterMap;

  bool isSortAvailable() =>
      getRequestOption(action: ServerActions.list)?.sortBy != null;

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
    return "${getTableNameApi()}listAPI${getRequestOptionFromParamOrAbstract(action: ServerActions.list)?.filterMap}";
  }

  String getListableKey() {
    return "${getTableNameApi()}listAPI${getRequestOptionFromParamOrAbstract(action: ServerActions.list)?.getKey() ?? ""}";
  }
}

// enum SortByType {
//   @JsonValue("ASC")
//   ASC,
//   @JsonValue("DESC")
//   DESC }
const _$SortByType = {
  SortByType.ASC: 'ASC',
  SortByType.DESC: 'DESC',
};

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
