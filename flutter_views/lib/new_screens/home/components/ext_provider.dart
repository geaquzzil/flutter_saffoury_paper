import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

void notifyListApi(BuildContext context) {
  ViewAbstract? v = context.read<DrawerMenuControllerProvider>().getObject;
  v.setFilterableMap(context.read<FilterableProvider>().getList);
  context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
}

void notifyFilterableListApiIsCleared(BuildContext context) {
  ViewAbstract? v = context.read<DrawerMenuControllerProvider>().getObject;
  context
      .read<DrawerMenuControllerProvider>()
      .change(context, v.getSelfNewInstance());
}

void addFilterableSort(BuildContext context, SortByType selectedItem) {
  context.read<FilterableProvider>().addSortBy(context, selectedItem);
}

void addFilterableSortField(
    BuildContext context, String selectedItem, String selectedItemMainValue) {
  context
      .read<FilterableProvider>()
      .addSortFieldName(context, selectedItem, selectedItemMainValue);
}

void addFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  addFilterableSelectedStringValue(
      context,
      selectedItem.getForeignKeyName(),
      selectedItem.getIDString(),
      selectedItem.getMainHeaderLabelTextOnly(context),
      selectedItem.getMainHeaderTextOnly(context));
}

void addFilterableSelectedStringValue(BuildContext context, String field,
    String value, String mainLabelName, String mainValueName) {
  context
      .read<FilterableProvider>()
      .add(field, field, value, mainValueName, mainLabelName);
}

void clearFilterableSelected(BuildContext context, String field) {
  context.read<FilterableProvider>().clear(field: field);
}

List<FilterableProviderHelper> getAllSelectedFiltersRead(BuildContext context) {
  var list = context.read<FilterableProvider>().getList.values.toList();
  var listSelectd = list
      .map((master) => master.values
          .map((e) => FilterableProviderHelper(
              field: master.field,
              fieldNameApi: master.fieldNameApi,
              values: [e],
              mainFieldName: master.mainFieldName,
              mainValuesName: [
                master.mainValuesName[master.values.indexOf(e)]
              ]))
          .toList())
      .toList();
  List<FilterableProviderHelper> finalList = [];
  for (var element in listSelectd) {
    for (var element in element) {
      finalList.add(element);
    }
  }
  return finalList;
}

List<FilterableProviderHelper> getAllSelectedFilters(BuildContext context) {
  var list = context.watch<FilterableProvider>().getList.values.toList();
  var listSelectd = list
      .map((master) => master.values
          .map((e) => FilterableProviderHelper(
              field: master.field,
              fieldNameApi: master.fieldNameApi,
              values: [e],
              mainFieldName: master.mainFieldName,
              mainValuesName: [
                master.mainValuesName[master.values.indexOf(e)]
              ]))
          .toList())
      .toList();
  List<FilterableProviderHelper> finalList = [];
  for (var element in listSelectd) {
    for (var element in element) {
      finalList.add(element);
    }
  }
  return finalList;
}

void removeFilterableSelectedStringValue(
    BuildContext context, String field, String value, String mainValueName) {
  context
      .read<FilterableProvider>()
      .remove(field, value: value, mainValueName: mainValueName);
}

void removeFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  removeFilterableSelectedStringValue(context, selectedItem.getForeignKeyName(),
      selectedItem.getIDString(), selectedItem.getMainHeaderTextOnly(context));
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

bool isFilterableSelectedByField(
    BuildContext context, String field, String value) {
  return context.watch<FilterableProvider>().isSelected(field, value);
}

int getFilterableFieldsCount(BuildContext context, ViewAbstract item) {
  return context.read<FilterableProvider>().getCount(item.getForeignKeyName());
}

int getFilterableFieldsCountStringValue(BuildContext context, String field) {
  return context.read<FilterableProvider>().getCount(field);
}
