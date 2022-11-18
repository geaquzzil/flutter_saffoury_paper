import 'package:flutter/material.dart';

import '../models/view_abstract.dart';

abstract class ListableInterface<T extends ViewAbstract> {
  List<T>? deletedList = [];

  /// get future that fired when pos widget is created
  List<T> getListableList();

  void onListableDelete(T item);

  void onListableUpdate(T item);
}
