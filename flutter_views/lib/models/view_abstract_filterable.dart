import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_enum.dart';
import 'package:flutter_view_controller/models/view_abstract_lists.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

abstract class ViewAbstractFilterable<T> extends ViewAbstractLists<T> {
  String? getSortByFieldName();
  SortByType getSortByType();

  bool isSortAvailable() => getSortByFieldName() != null;

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

  Future<void> getFilterableListFor() async {
    List<String> fields = getMainFields();
    ViewAbstract currentInstance = this as ViewAbstract;
currentInstance.g
  }
}

enum SortByType { ASC, DESC }

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

// class FilterableProviderHelperListItem {
//   //The field Label
//   String labelText;
// //wich contains the field text
//   String valueLabelText;
//   //witch contains the iD
//   Object? valueApi;

//   FilterableProviderHelperListItem(
//       this.labelText, this.valueLabelText, this.valueApi);
// }
