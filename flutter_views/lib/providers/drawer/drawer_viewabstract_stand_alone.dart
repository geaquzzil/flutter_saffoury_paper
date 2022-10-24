//create product cart provider class

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_non_list.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:provider/provider.dart';

class DrawerViewAbstractStandAloneProvider with ChangeNotifier {
  ViewAbstractStandAloneCustomView? object;
  DrawerViewAbstractStandAloneProvider(this.object);

  ViewAbstractStandAloneCustomView? get getObject => object;
  String getTitle(BuildContext context) =>
      object?.getMainHeaderLabelTextOnly(context).toLowerCase()??"null";

  void change(BuildContext context, ViewAbstractStandAloneCustomView? object) {
    this.object = object;
    notifyListeners();
    // context.read<FilterableProvider>().init(object);
  }
}
