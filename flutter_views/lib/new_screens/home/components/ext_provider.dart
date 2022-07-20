import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

void addFilterableSort(BuildContext context, SortByType selectedItem) {
  context.read<FilterableProvider>().addSortBy(selectedItem);
}

void addFilterableSortField(BuildContext context, String selectedItem) {
  context.read<FilterableProvider>().addSortFieldName(selectedItem);
}
