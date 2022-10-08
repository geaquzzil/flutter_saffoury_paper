//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';

import '../../models/view_abstract.dart';

class NotificationProvider with ChangeNotifier {
  List<ViewAbstract> list = [];

  List<ViewAbstract> get getList => list;

  int get getCount => list.length;

  void add(ViewAbstract product) {
    list.add(product);
    notifyListeners();
  }

  void remove(ViewAbstract product) {
    list.remove(product);
    notifyListeners();
  }

  Future<bool> hasItem(ViewAbstract product) async {
    return list.firstWhereOrNull((p0) => p0.isEquals(product)) != null;
  }

  void clear() {
    list.clear();
    notifyListeners();
  }
}
