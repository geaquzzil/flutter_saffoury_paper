//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class DrawerViewAbstractProvider with ChangeNotifier {
  ViewAbstract object;
  DrawerViewAbstractProvider({required this.object});

  ViewAbstract get getObject => object;
  String getTitle(BuildContext context) => object.getMainLabelTextOnly(context);

  void change(ViewAbstract object) {
    this.object = object;
    notifyListeners();
  }
}
