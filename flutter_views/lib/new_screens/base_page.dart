import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'home/components/drawers/drawer_large_screen.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  Widget? _firstWidget;
  Widget? _secondWidget;

  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;

  Widget getFirstPane(double width);
  Widget? getFloatingActionButton();
  Widget? getSecoundPane(double width);
  Widget? getDesktopFirstPane(double width);
  Widget? getDesktopSecondPane(double width);

  @override
  void initState() {
    super.initState();
    _drawerMenuControllerProvider =
        context.read<DrawerMenuControllerProvider>();
    _drawerWidget = DrawerLargeScreens();
  }

  void addFramPost(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  void setSideMenuClosed() {
    addFramPost((p0) {
      context.read<DrawerMenuControllerProvider>().setSideMenuIsClosed();
    });
  }

  void setSideMenuOpen() {
    addFramPost((p0) {
      context.read<DrawerMenuControllerProvider>().setSideMenuIsOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenHelperSliver(
        requireAutoPadding: false,
        mobile: (w, h) {
          setSideMenuOpen();
          return _getTabletWidget(w);
        },
        smallTablet: (w, h) {
          setSideMenuClosed();
          return _getTabletWidget(w);
        },
        largeTablet: (w, h) {
          setSideMenuClosed();
          return _getTabletWidget(w);
        },
        desktop: (w, h) {
          setSideMenuOpen();
          return _getTabletWidget(w);
        });
  }

  Widget _getTowPanes(double w) {
    if (isDesktop(context, maxWidth: w)) {
      _firstWidget = getDesktopFirstPane(w);

      _secondWidget = getDesktopSecondPane(w);
      if (_secondWidget == null) {
        _firstWidget = Padding(
          padding: getSuggestionPadding(w),
          child: _firstWidget,
        );
      }
    } else {
      _firstWidget = getFirstPane(w);
      _secondWidget = getSecoundPane(w);
      if (_secondWidget == null) {
        _firstWidget = Padding(
          padding: getSuggestionPadding(w),
          child: _firstWidget,
        );
      }
    }
    if (_secondWidget == null) {
      return _firstWidget!;
    }
    return TowPaneExt(startPane: _firstWidget!, endPane: _secondWidget);
  }

  Widget _getTabletWidget(double w) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: getFloatingActionButton(),
      drawer: _drawerWidget,
      body: Card(child: _getBody(w)),
    );
  }

  Widget _getBody(double w) {
    Widget currentWidget;
    if (isMobile(context, maxWidth: w)) {
      _firstWidget ??= getFirstPane(w);
      currentWidget = _firstWidget!;
    } else {
      currentWidget = _getTowPanes(w);
    }
    if (isDesktop(context, maxWidth: w) || isTablet(context, maxWidth: w)) {
      return SafeArea(
          child: Row(
        children: [
          _drawerWidget!,
          // if (_secondWidget == null) Text("DASDAS"),

          // if (!isCustomWidget) navigationRailWidget!,
          Expanded(child: currentWidget),
        ],
      ));
    } else {
      return SafeArea(child: currentWidget);
    }
  }

  Widget shouldWrapNavigatorChild(BuildContext context, Widget child,
      {bool isCustomWidget = false}) {
    if (isDesktop(context)) {
      // navigationRailWidget ??= isCustomWidget ? null : getNavigationRail();
      return SafeArea(
          child: Row(
        children: [
          _drawerWidget!,
          // if (!isCustomWidget) navigationRailWidget!,
          Expanded(child: child),
        ],
      ));
    } else if (SizeConfig.isLargeScreen(context)) {
      // navigationRailWidget ??= getNavigationRail();

      return SafeArea(
          child: Row(
        children: [
          // navigationRailWidget!,
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ));
    } else {
      return SafeArea(child: child);
    }
  }
}
