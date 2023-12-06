import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'home/components/drawers/drawer_large_screen.dart';

abstract class BasePageState<T extends StatefulWidget, C> extends State<T> {
  Widget? _firstWidget;
  Widget? _secondWidget;
  Widget? _desktopWidget;

  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;

  Widget? getSecoundPane(double width);
  Widget getFirstPane(double width);
  Widget? getDesktopPage(double width);
  @override
  void initState() {
    super.initState();

    _drawerMenuControllerProvider =
        context.read<DrawerMenuControllerProvider>();
    _drawerWidget = DrawerLargeScreens();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenHelperSliver(
        requireAutoPadding: true,
        mobile: (w, h) {
          return _getMobileWidget(w);
        },
        smallTablet: (w, h) {
          return _getTabletWidget(w);
        },
        largeTablet: (w, h) {
          return _getTabletWidget(w);
        },
        desktop: (w, h) {
          return _getDesktopWidget(w);
        });
  }

  Widget _getTowPanes(double w) {
    _firstWidget ??= getFirstPane(w);
    _secondWidget ??= getSecoundPane(w);
    return TowPaneExt(startPane: _firstWidget!, endPane: _secondWidget);
  }

  Widget _getDesktopWidget(double w) {
    _desktopWidget ??= getDesktopPage(w);
    _desktopWidget ??= Scaffold(
      drawer: _drawerWidget,
      
      body: _getTowPanes(w),
    );
    return _desktopWidget!;
  }

  Widget _getTabletWidget(double w) {
    return Scaffold(
      drawer: _drawerWidget,
      body: _getTowPanes(w),
    );
  }

  Widget _getMobileWidget(double w) {
    _firstWidget ??= getFirstPane(w);
    return Scaffold(
      drawer: _drawerWidget,
      body: _firstWidget,
    );
  }
}
