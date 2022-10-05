import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class DashableItemInterface {}

abstract class DashableInterface<T extends ViewAbstract> {
  List<ViewAbstract> getDashboardsItems(BuildContext context);

 
}
