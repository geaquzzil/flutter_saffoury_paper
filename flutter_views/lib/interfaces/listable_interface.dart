import 'package:flutter/material.dart';

import '../models/view_abstract.dart';

abstract class ListableInterface<T extends ViewAbstract> {
  /// get future that fired when pos widget is created
  List<T>  getListableList(BuildContext context);

}
