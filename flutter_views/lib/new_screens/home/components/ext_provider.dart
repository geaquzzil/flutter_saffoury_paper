import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

void notifyListApi(BuildContext context) {
  ViewAbstract? v = context.read<DrawerViewAbstractProvider>().getObject;
  v.setFilterableMap(context.read<FilterableProvider>().getList);
  context.read<DrawerViewAbstractProvider>().change(context, v);
  
}

void addFilterableSort(BuildContext context, SortByType selectedItem) {
  context.read<FilterableProvider>().addSortBy(selectedItem);
}

void addFilterableSortField(BuildContext context, String selectedItem) {
  context.read<FilterableProvider>().addSortFieldName(selectedItem);
}

void addFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  addFilterableSelectedStringValue(
      context, selectedItem.getForeignKeyName(), selectedItem.getIDString());
}

void addFilterableSelectedStringValue(
    BuildContext context, String field, String value) {
  context.read<FilterableProvider>().add(field, field, value);
}

void clearFilterableSelected(BuildContext context, String field) {
  context.read<FilterableProvider>().clear(field: field);
}

void removeFilterableSelectedStringValue(
    BuildContext context, String field, String value) {
  context.read<FilterableProvider>().remove(field, value: value);
}

void removeFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  removeFilterableSelectedStringValue(
      context, selectedItem.getForeignKeyName(), selectedItem.getIDString());
}

bool isFilterableSelectedStringValue(
    BuildContext context, String field, String value) {
  return context.watch<FilterableProvider>().isSelected(field, value);
}

bool isFilterableSelected(BuildContext context, ViewAbstract item) {
  return context
      .watch<FilterableProvider>()
      .isSelected(item.getForeignKeyName(), item.getIDString());
}

int getFilterableFieldsCount(BuildContext context, ViewAbstract item) {
  return context.read<FilterableProvider>().getCount(item.getForeignKeyName());
}

int getFilterableFieldsCountStringValue(BuildContext context, String field) {
  return context.read<FilterableProvider>().getCount(field);
}
