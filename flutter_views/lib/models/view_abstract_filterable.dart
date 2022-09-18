import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/theming/text_field_theming.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ViewAbstractFilterable<T> extends ViewAbstractLists<T> {
  String? getSortByFieldName();
  SortByType getSortByType();

  String getForeignKeyName() {
    return getTableNameApi() ?? " no_foreign_key";
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

  Future<bool> hasPermssionFilterable(
      BuildContext context, ViewAbstract viewAbstract) async {
    return await hasPermissionList(context, viewAbstract: viewAbstract);
  }

  bool hasPermssionFilterableField(BuildContext context, String field) {
    return true;
  }
}

enum SortByType { 
  @JsonValue("ASC")
  ASC, 
  @JsonValue("DESC")
  DESC }

// enum SortByType implements ViewAbstractEnum<SortByType> {
//   ASC,
//   DESC;

//   @override
//   IconData getMainIconData() => Icons.stacked_line_chart_outlined;
//   @override
//   String getMainLabelText(BuildContext context) =>
//       AppLocalizations.of(context)!.sortBy;

//   @override
//   String getFieldLabelString(BuildContext context, SortByType field) {
//     switch (field) {
//       case ASC:
//         return AppLocalizations.of(context)!.ascSorting;
//       case DESC:
//         return AppLocalizations.of(context)!.descSorting;
//     }
//     return " ";
//   }

//   @override
//   List<SortByType> getValues() {
//     return SortByType.values;
//   }
// }

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
      : theme = TextFieldTheming(lableText: title,icon: icon );
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
