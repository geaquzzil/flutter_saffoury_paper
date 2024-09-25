import 'package:flutter/material.dart';
import 'package:flutter_view_controller/globals.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page_new.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class WidgetNavigationHelper {
  Widget widget;
  String title;
  WidgetNavigationHelper({
    required this.widget,
    required this.title,
  });
}

List<WidgetNavigationHelper> list = [];

class BaseDeterminePageState extends StatelessWidget {
  late Widget _drawerWidget;
  late CurrentScreenSize _currentScreenSize;
  late double _height;
  late double _width;

  BaseDeterminePageState({super.key});

  @override
  Widget build(BuildContext context) {
    {
      return ScreenHelperSliver(
          requireAutoPadding: false,
          onChangeLayout: (w, h, c) {
            _currentScreenSize = c;

            _height = h;
            _width = w;
            _drawerWidget = DrawerLargeScreens(
              size: _currentScreenSize,
            );
          },
          mobile: (w, h) {
            return _getTabletWidget(context);
          },
          smallTablet: (w, h) {
            return _getTabletWidget(context);
          },
          largeTablet: (w, h) {
            return _getTabletWidget(context);
          },
          desktop: (w, h) {
            return _getTabletWidget(context);
          });
    }
  }

  Widget _getTabletWidget(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //TODO DublicatedKey key: _drawerMenuControllerProvider.getStartDrawableKey,
        drawer: _drawerWidget,
        body: Selector<DrawerMenuControllerProvider,
            Tuple2<dynamic, DrawerMenuControllerProviderAction>>(
          builder: (context, value, child) {
            bool isLarge = isDesktop(context, maxWidth: _width) ||
                isTablet(context, maxWidth: _width);
            bool buildDrawer = !isLarge;
            debugPrint("isLarge: $isLarge");
            Widget widget;
            switch (value.item2) {
              case DrawerMenuControllerProviderAction.custom_widget:
                widget = value.item1 as Widget;
                break;
              case DrawerMenuControllerProviderAction.custom:
                widget = MasterViewStandAlone(viewAbstract: value.item1);
                break;
              case DrawerMenuControllerProviderAction.dashboard:
                widget = BaseDashboardMainPage(
                  title: "D",
                  buildDrawer: buildDrawer,
                );
                break;
              case DrawerMenuControllerProviderAction.edit:
                widget = const Text("NOIN edit");
                break;
              case DrawerMenuControllerProviderAction.list:
              case DrawerMenuControllerProviderAction.list_to_details:
              case DrawerMenuControllerProviderAction.none:
                widget = ListToDetailsPageNew(
                  key: Globals.keyForLargeScreenListable,
                  title: "SOSO",
                  buildDrawer: buildDrawer,
                );
                break;
              case DrawerMenuControllerProviderAction.print:
                //         pathParameters: {
                //   "tableName": getTableNameApi() ?? getCustomAction() ?? "-",
                //   "id": "$iD"
                // },
                widget = PdfPageNew(
                  buildBaseHeader: true,
                  iD: value.item1.iD,
                  tableName: value.item1.getTableNameApi() ??
                      value.item1.getCustomAction() ??
                      "-",
                  invoiceObj: value.item1,
                );
                break;
              case DrawerMenuControllerProviderAction.view:
                widget = const Text("NOIN view");
                break;
            }
            if (isLarge) {
              // return _drawerWidget;
              return Row(children: [_drawerWidget, Expanded(child: widget)]);
            }
            return widget;
          },
          selector: (p0, p1) => Tuple2(p1.getObject, p1.getAction),
        ));
  }
}
