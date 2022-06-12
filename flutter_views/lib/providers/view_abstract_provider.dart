//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ViewAbstractProvider with ChangeNotifier {
  late ViewAbstract object;

  ViewAbstract get getObject => object;

  void change(ViewAbstract object) {
    this.object = object;
    notifyListeners();
  }
}
