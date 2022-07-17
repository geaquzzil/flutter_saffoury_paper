import 'package:flutter/cupertino.dart';
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
    return getSortByFieldName()??"";
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

// enum SortByType { ASC, DESC }

enum SortByType implements ViewAbstractEnum<SortByType> {
  ASC,
  DESC;

  @override
  IconData getMainIconData() => Icons.stacked_line_chart_outlined;
  @override
  String getMainLabelText(BuildContext context) =>
      AppLocalizations.of(context)!.status;

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
  List<SortByType> getValues() {
    return SortByType.values;
  }
}
