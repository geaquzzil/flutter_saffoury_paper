import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

abstract class DashableItemInterface {}

abstract class DashableInterface<T extends ViewAbstract> {
  List<DashableGridHelper> getDashboardSections(BuildContext context);
  void setDate(DateObject? date);
}

class DashableGridHelper {
  String title;
  Widget? onTitleButton;
  List<StaggeredGridTile> widgets;
  List<List<ViewAbstract>>? sectionsListToTabbar;
  List<ViewAbstract>? headerListToAdd;
  DashableGridHelper(
      {required this.title,
      required this.widgets,
      this.onTitleButton,
      this.headerListToAdd,
      this.sectionsListToTabbar});
}
