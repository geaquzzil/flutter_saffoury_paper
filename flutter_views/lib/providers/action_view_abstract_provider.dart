import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ActionViewAbstractProvider with ChangeNotifier {

  ViewAbstract? object;
  ActionViewAbstractProvider();

  ViewAbstract? get getObject => object;

  void change(ViewAbstract object) {
    this.object = object;
    notifyListeners();
  }
}
