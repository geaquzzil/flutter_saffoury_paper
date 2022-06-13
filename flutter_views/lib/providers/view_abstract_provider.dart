//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ViewAbstractProvider with ChangeNotifier {
  ViewAbstract object;
  ViewAbstractProvider({required this.object});

  ViewAbstract get getObject => object;

  void change(ViewAbstract object) {
    this.object = object;
    notifyListeners();
  }
}
