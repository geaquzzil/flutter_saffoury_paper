//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_stand_alone.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

class DrawerViewAbstractListProvider with ChangeNotifier {
  ViewAbstract object;
  DrawerViewAbstractListProvider({required this.object});

  ViewAbstract get getObject => object;
  String getTitle(BuildContext context) =>
      object.getMainHeaderLabelTextOnly(context).toLowerCase();

  void change(BuildContext context, ViewAbstract object) {
    this.object = object;
    notifyListeners();
    context.read<FilterableProvider>().init(object);
    context.read<DrawerViewAbstractStandAloneProvider>().change(context,null);
  }
}
