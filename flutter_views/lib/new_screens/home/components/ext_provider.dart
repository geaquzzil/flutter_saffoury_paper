import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

void addFilterableSort(BuildContext context, SortByType selectedItem) {
  context.read<FilterableProvider>().addSortBy(selectedItem);
}

void addFilterableSortField(BuildContext context, String selectedItem) {
  context.read<FilterableProvider>().addSortFieldName(selectedItem);
}

void addFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  context.read<FilterableProvider>().add(selectedItem.getForeignKeyName(),
      selectedItem.getForeignKeyName(), selectedItem.getIDString());
}

void removeFilterableSelected(BuildContext context, ViewAbstract selectedItem) {
  context.read<FilterableProvider>().remove(selectedItem.getForeignKeyName(),
      value: selectedItem.getIDString());
}

bool isFilterableSelected(BuildContext context, ViewAbstract item) {
  return context
      .watch<FilterableProvider>()
      .isSelected(item.getForeignKeyName(), item.getIDString());
}

int getFilterableFieldsCount(BuildContext context, ViewAbstract item) {
  return context.read<FilterableProvider>().getCount(item.getForeignKeyName());
}
