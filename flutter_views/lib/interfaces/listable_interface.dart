import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/view_abstract.dart';

abstract class ListableInterface<T extends ViewAbstract> {
  @JsonKey(ignore: true)
  List<T>? deletedList = [];

  /// get future that fired when pos widget is created
  List<T> getListableList();
  void onListableSelectedListAdded(List<ViewAbstract> list);

  ViewAbstract getListablePickObject();

  String? getListableTotalQuantity(BuildContext context);
  double? getListableTotalPrice(BuildContext context);
  double? getListableTotalDiscount(BuildContext context);

  void onListableDelete(T item);

  void onListableUpdate(T item);
}
