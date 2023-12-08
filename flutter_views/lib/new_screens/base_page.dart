import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'home/components/drawers/drawer_large_screen.dart';

abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  Widget? _firstWidget;
  Widget? _secondWidget;
  double? _width;
  double? _height;

  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;

  Widget getFirstPane(double width);
  Widget? getFloatingActionButton();
  Widget? getSecoundPane(double width);
  Widget? getDesktopFirstPane(double width);
  Widget? getDesktopSecondPane(double width);

  bool setPaddingWhenTowPane();

  @override
  void initState() {
    _drawerMenuControllerProvider =
        context.read<DrawerMenuControllerProvider>();
    super.initState();
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

  void reset() {
    _secondWidget = null;
    _firstWidget = null;
    _width = 0;
    _height = 0;
  }

  @override
  Widget build(BuildContext context) {
    _drawerWidget = DrawerLargeScreens();
    return ScreenHelperSliver(
        requireAutoPadding: false,
        onChangeLayout: (w, h) {
          reset();
          _width = w;
          _height = h;
        },
        mobile: (w, h) {
          return _getTabletWidget(w);
        },
        smallTablet: (w, h) {
          return _getTabletWidget(w);
        },
        largeTablet: (w, h) {
          return _getTabletWidget(w);
        },
        desktop: (w, h) {
          return _getTabletWidget(w);
        });
  }

  Widget _getTowPanes(double w) {
    if (isDesktop(context, maxWidth: w)) {
      _firstWidget = getDesktopFirstPane(w);
      _secondWidget = getDesktopSecondPane(w);
      // if
    } else {
      _firstWidget = getFirstPane(w);
      _secondWidget = getSecoundPane(w);
    }
    if (_secondWidget == null) {
      return _firstWidget!;
    }

    if (_secondWidget != null) {
      set border on non foldaable only
      _firstWidget = Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: .5, color: Theme.of(context).dividerColor))),
          child: _firstWidget);
    }
    return TowPaneExt(startPane: _firstWidget!, endPane: _secondWidget);
  }

  Widget _getTabletWidget(double w) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getFloatingActionButton(),
        drawer: _drawerWidget,
        body: _getBody(w));
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
          Selector<DrawerMenuControllerProvider, bool>(
            builder: (__, isOpen, ___) {
              Widget toShowWidget;
              Widget clipRect = ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: currentWidget);

              if (_secondWidget == null || setPaddingWhenTowPane()) {
                toShowWidget = Padding(
                  padding: getSuggestionPadding(w),
                  child: clipRect,
                );
              } else {
                toShowWidget = clipRect;
              }

              return AnimatedContainer(
                  key: UniqueKey(),
                  height: _height,
                  width: (_width! -
                          (isOpen ? kDrawerOpenWidth : kDefaultClosedDrawer)
                              .toNonNullable()) -
                      0,
                  duration: const Duration(milliseconds: 100),
                  child: toShowWidget);
            },
            selector: (p0, p1) => p1.getSideMenuIsOpen,
          )
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
