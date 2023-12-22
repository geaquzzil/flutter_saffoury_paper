// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_view_controller/models/apis/date_object.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_screens/base_page.dart';

abstract class DashableItemInterface {}

abstract class DashableInterface<T extends ViewAbstract> {
  List<DashableGridHelper> getDashboardSectionsFirstPane(
      BuildContext context, int crossAxisCount);
  List<DashableGridHelper> getDashboardSectionsSecoundPane(
      BuildContext context, int crossAxisCount);

  void setDate(DateObject? date);

  ///this should wait for user input before request api
  getDashboardShouldWaitBeforeRequest(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi>? globalKey,
      TabControllerHelper? tab});

  Widget? getDashboardAppbar(BuildContext context,
      {bool? firstPane,
      GlobalKey<BasePageWithApi>? globalKey,
      TabControllerHelper? tab});
}

enum WidgetDashboardType {
  NORMAL,
  CHART;
}

class WidgetGridHelper {
  StaggeredGridTile widget;
  WidgetDashboardType widgetDashboardType;

  WidgetGridHelper({
    required this.widget,
    required this.widgetDashboardType,
  });
}

class DashableGridHelper {
  String? title;
  Widget? onTitleButton;
  List<WidgetGridHelper> widgets;
  List<List<ViewAbstract>>? sectionsListToTabbar;
  List<ViewAbstract>? headerListToAdd;
  bool wrapWithCard;
  DashableGridHelper(
      {this.title,
      required this.widgets,
      this.onTitleButton,
      this.headerListToAdd,
      this.wrapWithCard = false,
      this.sectionsListToTabbar});
}
