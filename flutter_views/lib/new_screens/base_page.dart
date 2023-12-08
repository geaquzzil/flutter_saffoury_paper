import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import 'home/components/drawers/drawer_large_screen.dart';

///Auto generate view
///[CurrentScreenSize.MOBILE] if this  is true
///
///
///
abstract class BasePageState<T extends StatefulWidget> extends State<T> {
  Widget? _firstWidget;
  Widget? _secondWidget;
  double? _width;
  double? _height;

  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;

  Widget? getDesktopFirstPane(double width);
  Widget? getDesktopSecondPane(double width);
  Widget getFirstPane(double width);
  Widget? getSecoundPane(double width);
  Widget? getBaseFloatingActionButton(CurrentScreenSize currentScreenSize);
  Widget? getFirstPaneFloatingActionButton(CurrentScreenSize currentScreenSize);
  Widget? getSecondPaneFloatingActionButton(
      CurrentScreenSize currentScreenSize);
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize);
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize);
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize);

  bool isPanesIsSliver(bool firstPane);

  ///set padding to content view pased on the screen size
  ///if this is [true] then we add divider between panes
  ///if this is [false] then we check for second pane if no second pane then we add padding automatically
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize);

  bool getHasDecorationOnFirstPane() {
    return _secondWidget != null &&
        setPaddingWhenTowPane(getCurrentScreenSize());
  }

  bool _hasBaseToolbar() {
    return getBaseAppbar(getCurrentScreenSize()) != null;
  }

  ///generate all toolbars for the base and first pane and second pane
  ///if [customAppBar] is null then generates the base toolbar
  ///else if [customAppBar] is not null then generates the app bar based on the panes
  generateToolbar({Widget? customAppBar}) {
    return AppBar(
      forceMaterialTransparency: true,
      primary: true,
      backgroundColor: customAppBar != null
          ? ElevationOverlay.overlayColor(context, 2)
          : null,
      toolbarHeight: customAppBar == null ? 100 : null,
      // backgroundColor: ElevationOverlay.overlayColor(context, 2),
      title: customAppBar ?? getBaseAppbar(getCurrentScreenSize())!,
    );
  }

  Widget? _setSubAppBar(Widget? widget, bool firstPane) {
    Widget? appBarBody = firstPane
        ? getFirstPaneAppbar(getCurrentScreenSize())
        : getSecondPaneAppbar(getCurrentScreenSize());
    if (appBarBody == null) return widget;
    Widget? body = widget;
    if (SizeConfig.isDesktopOrWebPlatform(context))
    {

    }else{
      
    }
      return Scaffold(
        backgroundColor: ElevationOverlay.overlayColor(context, 0),
        appBar: isPanesIsSliver(firstPane) ? null : generateToolbar(),
        body: widget,
      );
  }

  Widget _getBorderDecoration(Widget widget) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(
                    width: .5, color: Theme.of(context).dividerColor))),
        child: widget);
  }

  @override
  void initState() {
    _drawerMenuControllerProvider =
        context.read<DrawerMenuControllerProvider>();
    super.initState();
  }

  CurrentScreenSize getCurrentScreenSize() {
    return getCurrentScreenSizeStatic(context);
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
    _drawerWidget ??= const DrawerLargeScreens();
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
    if (isMobile(context, maxWidth: w)) {
      _firstWidget = getFirstPane(w);
      return _setSubAppBar(_firstWidget, true)!;
    }
    Widget? firstPaneFloating;
    Widget? secondPaneFloating;
    Widget? firstPaneAppbar;
    Widget? secondPaneAppbar;

    if (isDesktop(context, maxWidth: w)) {
      _firstWidget = getDesktopFirstPane(w);
      _secondWidget = getDesktopSecondPane(w);
      _firstWidget = _setSubAppBar(_firstWidget, true);
      _secondWidget = _setSubAppBar(_secondWidget, true);

      // if
    } else {
      _firstWidget = getFirstPane(w);
      _secondWidget = getSecoundPane(w);
      _firstWidget = _setSubAppBar(_firstWidget, true);
      _secondWidget = _setSubAppBar(_secondWidget, true);
    }
    if (_secondWidget == null) {
      return _firstWidget!;
    }

    if (getHasDecorationOnFirstPane()) {
      _firstWidget = _getBorderDecoration(_firstWidget!);
    }

    return TowPaneExt(startPane: _firstWidget!, endPane: _secondWidget);
  }

  Widget _getTabletWidget(double w) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton:
            getBaseFloatingActionButton(getCurrentScreenSize()),
        drawer: _drawerWidget,
        body: _getBody(w));
  }

  Widget _getBody(double w) {
    Widget currentWidget;
    currentWidget = _getTowPanes(w);
    if (isDesktop(context, maxWidth: w) || isTablet(context, maxWidth: w)) {
      return SafeArea(
          child: Row(
        children: [
          _drawerWidget!,
          Selector<DrawerMenuControllerProvider, bool>(
            builder: (__, isOpen, ___) {
              Widget toShowWidget;
              Widget clipRect = ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: _hasBaseToolbar()
                      ? Scaffold(
                          backgroundColor:
                              ElevationOverlay.overlayColor(context, 2),
                          appBar: generateToolbar(),
                          body: currentWidget,
                        )
                      : currentWidget);

              if (_secondWidget == null ||
                  setPaddingWhenTowPane(getCurrentScreenSize())) {
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
