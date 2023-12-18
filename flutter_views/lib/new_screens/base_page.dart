import 'dart:math';

import 'package:connectivity_listener/connectivity_listener.dart';
import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'home/components/drawers/drawer_large_screen.dart';

/// WebSmothSceroll additional offset to users scroll input WEB WAS 150
const scrollOffset = 10;

///WebSmothSceroll animation duration WEB WAS 600
const animationDuration = 250;

const double kDefualtAppBar = 70;

const double kDefualtClipRect = 25;

///Auto generate view
///[CurrentScreenSize.MOBILE] if this  is true
///
///
///
abstract class BasePageState<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  dynamic _firstWidget;
  dynamic _secondWidget;
  dynamic _width;
  dynamic _height;

  final ScrollController _scrollFirstPaneController = ScrollController();
  final ScrollController _scrollSecoundPaneController = ScrollController();
  bool pinToolbar = false;
  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;

  // The listener
  final _connectionListener = ConnectionListener();

  final firstPaneScaffold = GlobalKey<ScaffoldMessengerState>();
  final secondPaneScaffold = GlobalKey<ScaffoldMessengerState>();

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getDesktopFirstPane({TabControllerHelper? tab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getDesktopSecondPane({TabControllerHelper? tab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getFirstPane({TabControllerHelper? tab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getSecoundPane({TabControllerHelper? tab});

  Widget? getBaseFloatingActionButton();
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab});
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab});
  Widget? getBaseAppbar();
  Widget? getFirstPaneAppbar({TabControllerHelper? tab});
  Widget? getSecondPaneAppbar({TabControllerHelper? tab});

  Widget? getBaseBottomSheet();

  Widget? getFirstPaneBottomSheet({TabControllerHelper? tab});
  Widget? getSecondPaneBottomSheet({TabControllerHelper? tab});

  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab});
  bool isPaneScaffoldOverlayColord(bool firstPane, {TabControllerHelper? tab});
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab});

  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab});

  late CurrentScreenSize _currentScreenSize;
  late TabController _tabController;
  int currentTabIndex = 0;
  List<TabControllerHelper>? _tabList;
  get getWidth => this._width;

  get getHeight => this._height;

  List<TabControllerHelper>? _getTabBarList() {
    return _tabList;
  }

  List<TabControllerHelper>? initTabBarList() {
    return null;
  }

  bool _hasTabBarList() {
    return _getTabBarList() != null;
  }

  PreferredSizeWidget getTabBarWidget() {
    return TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        isScrollable: true,
        tabs: _getTabBarList()!);
  }

  ///set padding to content view pased on the screen size
  ///if this is [true] then we add divider between panes
  ///if this is [false] then we check for second pane if no second pane then we add padding automatically
  ///todo tab not working here it will execute globaley
  bool setPaddingWhenTowPane(CurrentScreenSize currentScreenSize,
      {TabControllerHelper? tab});

  bool getHasDecorationOnFirstPane({TabControllerHelper? tab}) {
    return _secondWidget != null &&
        setPaddingWhenTowPane(getCurrentScreenSize(), tab: tab);
  }

  bool _hasBaseToolbar() {
    return getBaseAppbar() != null;
  }

  double getCustomPaneProportion() {
    {
      if (MediaQuery.of(context).hinge != null) return 0.5;
      if (SizeConfig.isMediumFromScreenSize(context)) {
        return 0.5;
      } else {
        CurrentScreenSize s = getCurrentScreenSize();
        double defualtWidth = 0;
        if (s case CurrentScreenSize.DESKTOP) {
          defualtWidth = kDesktopWidth;
          return .3;
        } else if (s case CurrentScreenSize.LARGE_TABLET) {
          defualtWidth = kLargeTablet;
        } else if (s case CurrentScreenSize.MOBILE) {
          return .5;
        }

        double sss = max(
          defualtWidth - _width,
          _width - defualtWidth,
        );
        debugPrint(
            " current width $_width  defualt width $defualtWidth   VALUE=${sss}  ");

        return sss > 250 ? 0.3 : 0.5;
      }
    }
  }

  ///generate all toolbars for the base and first pane and second pane
  ///if [customAppBar] is null then generates the base toolbar
  ///else if [customAppBar] is not null then generates the app bar based on the panes
  generateToolbar({Widget? customAppBar}) {
    return AppBar(
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: false,
        // primary: true,

        backgroundColor: customAppBar != null
            ? ElevationOverlay.overlayColor(context, 2)
            : null,
        toolbarHeight: customAppBar == null ? 100 : null,
        // backgroundColor: ElevationOverlay.overlayColor(context, 2),
        // leading: ,
        title: customAppBar ?? getBaseAppbar()!,
        bottom: customAppBar == null
            ? _hasTabBarList()
                ? getTabBarWidget()
                : null
            : null);
  }

  ///by default this is hidden when scrolling
  Widget getSliverAppBar(Widget widget,
      {bool pinned = false,
      bool floating = true,
      double height = kDefualtAppBar}) {
    return SliverPersistentHeader(
        pinned: pinned,
        floating: floating,
        delegate: SliverAppBarDelegatePreferedSize(
            shouldRebuildWidget: true,
            child: PreferredSize(
                preferredSize: Size.fromHeight(height), child: widget)));
  }

  ScrollController getScrollController(bool firstPane) {
    return firstPane
        ? _scrollFirstPaneController
        : _scrollSecoundPaneController;
  }

  Widget? _getScrollContent(widget, Widget? appBar, bool firstPane,
      {TabControllerHelper? tab}) {
    dynamic body = widget;
    debugPrint(
        "BasePage IsPanel isSliver started=> firstPane ${isPanesIsSliver(firstPane, tab: tab)}");

    if (isPanesIsSliver(firstPane, tab: tab)) {
      List<Widget> list = body;
      debugPrint(
          "BasePage IsPanel isSliver ${isPanesIsSliver(firstPane, tab: tab)} body $body");
      if (SizeConfig.isDesktopOrWebPlatform(context)) {
        debugPrint(
            "BasePage IsPanel  isDesktopOrWebPlatform isSliver ${isPanesIsSliver(firstPane, tab: tab)} body $body");
        body = WebSmoothScroll(
          controller: getScrollController(firstPane),
          animationDuration: animationDuration,
          scrollOffset: scrollOffset,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: getScrollController(firstPane),
            slivers: [if (appBar != null) getSliverAppBar(appBar), ...list],
          ),
        );
      } else {
        debugPrint(
            "BasePage IsPanel  isDesktopOrWebPlatform flassse isSliver ${isPanesIsSliver(firstPane)} body $body");
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: getScrollController(firstPane),
          slivers: [if (appBar != null) getSliverAppBar(appBar), ...list],
        );
      }
    }
    debugPrint(
        "BasePage IsPanel isSliver=> ${isPanesIsSliver(firstPane, tab: tab)} body $body");
    return body;
  }

  ///setting appbar but when is sliver then we added to CustomScrollView Sliver
  Widget? _setSubAppBar(widget, bool firstPane, {TabControllerHelper? tab}) {
    Widget? appBarBody = firstPane
        ? getFirstPaneAppbar(tab: tab)
        : getSecondPaneAppbar(tab: tab);

    Widget? body = _getScrollContent(widget, appBarBody, firstPane, tab: tab);
    Widget scaffold = Scaffold(
      // key: firstPane ? firstPaneScaffold : secondPaneScaffold,
      backgroundColor: isPaneScaffoldOverlayColord(firstPane, tab: tab)
          ? ElevationOverlay.overlayColor(context, 0)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: firstPane
          ? getFirstPaneFloatingActionButton(tab: tab)
          : getSecondPaneFloatingActionButton(tab: tab),
      appBar: isPanesIsSliver(firstPane, tab: tab) || appBarBody == null
          ? null
          : generateToolbar(customAppBar: appBarBody),
      bottomSheet: firstPane
          ? getFirstPaneBottomSheet(tab: tab)
          : getSecondPaneBottomSheet(tab: tab),
      body: Padding(
        padding: setBodyPadding(firstPane, tab: tab)
            ? const EdgeInsets.all(kDefaultPadding)
            : EdgeInsets.zero,
        child: body,
      ),
    );

    if (setPaneClipRect(firstPane, tab: tab)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kDefualtClipRect),
        child: scaffold,
      );
    }
    return scaffold;
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
    _connectionListener.init(
      onConnected: () => debugPrint("BasePage CONNECTED"),
      onReconnected: () => debugPrint("BasePage RECONNECTED"),
      onDisconnected: () => debugPrint("BasePage  DISCONNECTED"),
    );
    _tabList = initTabBarList();
    if (_hasTabBarList()) {
      _tabController = TabController(vsync: this, length: _tabList!.length);
      _tabController.addListener(_tabControllerChangeListener);
    }
    super.initState();
  }

  @override
  void dispose() {
    _connectionListener.dispose();
    if (_hasTabBarList()) {
      _tabController.removeListener(_tabControllerChangeListener);
      _tabController.dispose();
    }
    super.dispose();
  }

  CurrentScreenSize getCurrentScreenSize() {
    return _currentScreenSize;
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
        onChangeLayout: (w, h, c) {
          reset();
          _width = w;
          _height = h;
          _currentScreenSize = c;
        },
        mobile: (w, h) {
          return _getTabletWidget();
        },
        smallTablet: (w, h) {
          return _getTabletWidget();
        },
        largeTablet: (w, h) {
          return _getTabletWidget();
        },
        desktop: (w, h) {
          return _getTabletWidget();
        });
  }

  beforeGetDesktopFirstPaneWidget({TabControllerHelper? tab}) {
    return getDesktopFirstPane(tab: tab);
  }

  beforeGetDesktopSecoundPaneWidget({TabControllerHelper? tab}) {
    return getDesktopSecondPane(tab: tab);
  }

  beforeGetFirstPaneWidget({TabControllerHelper? tab}) {
    return getFirstPane(tab: tab);
  }

  beforeGetSecondPaneWidget({TabControllerHelper? tab}) {
    return getSecoundPane(tab: tab);
  }

  Widget _getTowPanes({TabControllerHelper? tab}) {
    if (isMobile(context, maxWidth: getWidth)) {
      _firstWidget = beforeGetFirstPaneWidget(tab: tab);
      return _setSubAppBar(_firstWidget, true)!;
    }

    if (isDesktop(context, maxWidth: getWidth)) {
      _firstWidget = beforeGetDesktopFirstPaneWidget(tab: tab);
      _secondWidget = beforeGetDesktopSecoundPaneWidget(tab: tab);
      _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);
      _secondWidget = _setSubAppBar(_secondWidget, false, tab: tab);

      // if
    } else {
      _firstWidget = beforeGetFirstPaneWidget(tab: tab);
      _secondWidget = beforeGetSecondPaneWidget(tab: tab);
      _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);
      _secondWidget = _setSubAppBar(_secondWidget, false, tab: tab);
    }
    if (_secondWidget == null) {
      return _firstWidget!;
    }

    if (getHasDecorationOnFirstPane(tab: tab)) {
      _firstWidget = _getBorderDecoration(_firstWidget!);
    }

    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _secondWidget,
      customPaneProportion: getCustomPaneProportion(),
    );
  }

  // Widget getBody() {
  //   return _hasTabBarList()
  //       ? TabBarView(
  //           controller: _tabController,
  //           children: _getTabBarList()!.map((e) => _getBody(tab: e)).toList())
  //       : _getBody();
  // }

  Widget _getTabletWidget() {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getBaseFloatingActionButton(),
        drawer: _drawerWidget,
        body: _getBody());

    // return t;

    // if (_hasTabBarList()) {
    //   List<TabControllerHelper> list = _getTabBarList()!;
    //   return DefaultTabController(
    //       initialIndex: currentTabIndex, length: list.length, child: t);
    // } else {
    //   return t;
    // }
  }

  Widget _getBody() {
    Widget currentWidget;
    bool isLarge = isDesktop(context, maxWidth: getWidth) ||
        isTablet(context, maxWidth: getWidth);

    if (_hasTabBarList()) {
      if (isLarge) {
        return SafeArea(
            child: Row(
          children: [
            _drawerWidget!,
            TabBarView(
                controller: _tabController,
                children: _getTabBarList()!.map((tab) {
                  currentWidget = _getTowPanes(tab: tab);
                  return Selector<DrawerMenuControllerProvider, bool>(
                    builder: (__, isOpen, ___) {
                      debugPrint("drawer selector $isOpen");

                      Widget toShowWidget;
                      Widget clipRect = ClipRRect(
                          borderRadius: BorderRadius.circular(kDefualtClipRect),
                          child: _hasBaseToolbar()
                              ? Scaffold(
                                  backgroundColor:
                                      ElevationOverlay.overlayColor(context, 2),
                                  appBar: generateToolbar(),
                                  body: currentWidget,
                                )
                              : currentWidget);

                      if (_secondWidget == null ||
                          setPaddingWhenTowPane(getCurrentScreenSize(),
                              tab: tab)) {
                        toShowWidget = Padding(
                          padding: getSuggestionPadding(getWidth),
                          child: clipRect,
                        );
                      } else {
                        toShowWidget = clipRect;
                      }

                      return AnimatedContainer(
                          key: UniqueKey(),
                          height: _height,
                          width: (_width! -
                                  (isOpen
                                          ? kDrawerOpenWidth
                                          : kDefaultClosedDrawer)
                                      .toNonNullable()) -
                              0,
                          duration: const Duration(milliseconds: 100),
                          child: toShowWidget);
                    },
                    selector: (p0, p1) => p1.getSideMenuIsOpen,
                  );
                }).toList())
          ],
        ));
      } else {
        return SafeArea(
          child: TabBarView(
              controller: _tabController,
              children:
                  _getTabBarList()!.map((e) => _getTowPanes(tab: e)).toList()),
        );
      }
    } else {
      currentWidget = _getTowPanes();
    }
    if (isLarge) {
      return SafeArea(
          child: Row(
        children: [
          _drawerWidget!,
          Selector<DrawerMenuControllerProvider, bool>(
            builder: (__, isOpen, ___) {
              debugPrint("drawer selector $isOpen");
              Widget toShowWidget;
              Widget clipRect = ClipRRect(
                  borderRadius: BorderRadius.circular(kDefualtClipRect),
                  child: _hasBaseToolbar()
                      ? Scaffold(
                          backgroundColor:
                              ElevationOverlay.overlayColor(context, 2),
                          appBar: generateToolbar(),
                          body: currentWidget,
                        )
                      : currentWidget);

              if (_secondWidget == null ||
                  setPaddingWhenTowPane(
                    getCurrentScreenSize(),
                  )) {
                toShowWidget = Padding(
                  padding: getSuggestionPadding(getWidth),
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

  void _tabControllerChangeListener() {
    currentTabIndex = _tabController.index;
    debugPrint("_tabController $currentTabIndex");
  }
}

abstract class BasePageWithApi<T extends StatefulWidget>
    extends BasePageState<T> {
  final refreshListener = ValueNotifier<bool>(true);
  int? iD;
  String? tableName;
  dynamic extras;
  bool _isLoading = false;

  BasePageWithApi({this.iD, this.tableName, this.extras});
  Future<dynamic> getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab});
  ServerActions getServerActions();

  dynamic getExtras({TabControllerHelper? tab}) {
    if (_hasTabBarList()) {
      if (tab != null) {
        dynamic result = _getTabBarList()!.firstWhere(
            (element) => element.extras.runtimeType == tab.extras.runtimeType);
        if (result == null) {
          throw Exception("Could not find tab");
        }
        return result.extras;
      }
      return _getTabBarList()![currentTabIndex].extras;
    }
    return extras;
  }

  void setExtras(
      {int? iD, String? tableName, dynamic ex, TabControllerHelper? tabH}) {
    _isLoading = false;
    if (_hasTabBarList()) {
      TabControllerHelper tab = tabH ?? _getTabBarList()![currentTabIndex];
      tab.extras = ex;
      tab.iD = iD;
      tab.tableName = tableName;
      if (tabH != null) {
        // _getTabBarList()!.firstWhere(
        //     (element) => element.extras.runtimeType == tabH.extras.runtimeType);
      } else {
        _getTabBarList()![currentTabIndex] = tab;
      }
    } else {
      this.extras = ex;
      this.iD = iD;
      this.tableName = tableName;
    }
  }

  void refresh({int? iD, String? tableName, dynamic extras}) {
    setExtras(iD: iD, tableName: tableName, ex: extras);
    setState(() {});
  }

  bool getBodyWithoutApi({TabControllerHelper? tab}) {
    dynamic ex = getExtras(tab: tab);
    if (ex is! ViewAbstract) return false;
    if (ex is DashableInterface) {
      return (ex).isRequiredObjectsListChecker();
    }
    bool canGetBody = (ex).isRequiredObjectsList()?[getServerActions()] == null;
    if (canGetBody) {
      debugPrint("BasePageWithApi getBodyWithoutApi skiped");
      return true;
    }
    bool res = (ex).isNew() || (ex).isRequiredObjectsListChecker();
    debugPrint("BasePageWithApi getBodyWithoutApi result => $res");
    return res;
  }

  // @override
  // generateToolbar({Widget? customAppBar}) {
  //   if (_isLoading) {
  //     return null;
  //   }
  //   return super.generateToolbar(customAppBar: customAppBar);
  // }
  getLoadingWidget(bool firstPane, {TabControllerHelper? tab}) {
    Widget loading = const Center(child: CircularProgressIndicator());
    if (isPanesIsSliver(firstPane, tab: tab)) {
      return [
        SliverFillRemaining(
          child: loading,
        )
      ];
    }
    return loading;
  }

  @override
  beforeGetFirstPaneWidget({TabControllerHelper? tab}) {
    if (_isLoading) return getLoadingWidget(true, tab: tab);
    return super.beforeGetFirstPaneWidget(tab: tab);
  }

  @override
  beforeGetDesktopFirstPaneWidget({TabControllerHelper? tab}) {
    if (_isLoading) return getLoadingWidget(true, tab: tab);
    return super.beforeGetDesktopFirstPaneWidget(tab: tab);
  }

  @override
  beforeGetDesktopSecoundPaneWidget({TabControllerHelper? tab}) {
    if (_isLoading) return getLoadingWidget(false, tab: tab);
    return super.beforeGetDesktopSecoundPaneWidget(tab: tab);
  }

  @override
  beforeGetSecondPaneWidget({TabControllerHelper? tab}) {
    if (_isLoading) return getLoadingWidget(false, tab: tab);
    return super.beforeGetSecondPaneWidget(tab: tab);
  }

  @override
  Widget _getTowPanes({TabControllerHelper? tab}) {
    debugPrint("getBody _getTowPanes TabController ${tab?.extras.runtimeType}");
    dynamic ex = getExtras(tab: tab);
    _isLoading = !getBodyWithoutApi(tab: tab);
    if (ex != null && !_isLoading) {
      return super._getTowPanes(tab: tab);
    }
    return FutureBuilder<dynamic>(
      future: getCallApiFunctionIfNull(context, tab: tab),
      builder: (context, snapshot) {
        debugPrint("BasePageApi FutureBuilder started");
        if (snapshot.hasError) {
          debugPrint("BasePageApi FutureBuilder hasError");
          return getErrorWidget();
        } else if (snapshot.connectionState == ConnectionState.done) {
          debugPrint("BasePageApi FutureBuilder done");
          _isLoading = false;
          if (snapshot.data != null) {
            setExtras(ex: snapshot.data, tabH: tab);
            if (ex is ViewAbstract) {
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //   context.read<ListMultiKeyProvider>().edit(ex);
              // });
            }
            return super._getTowPanes(tab: tab);
          } else {
            debugPrint("BasePageApi FutureBuilder !done");
            return getErrorWidget();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint("BasePageApi FutureBuilder waiting");
          _isLoading = true;
          return super._getTowPanes(tab: tab);
        } else {
          debugPrint("BasePageApi FutureBuilder !TOTODO");
          return const Text("TOTODO");
        }
      },
    );
  }

  Widget getErrorWidget() {
    _isLoading = false;
    return EmptyWidget(
        lottiUrl: "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
        onSubtitleClicked: () {
          setState(() {});
        },
        title: AppLocalizations.of(context)!.cantConnect,
        subtitle: AppLocalizations.of(context)!.cantConnectRetry);
  }

  // @override
  // Widget _getBody({TabControllerHelper? tab}) {
  //   debugPrint(
  //       "getBody getDesktopFirstPane TabController ${tab?.extras.runtimeType}");
  //   dynamic ex = getExtras(tab: tab);
  //   _isLoading = !getBodyWithoutApi(tab: tab);
  //   if (ex != null && !_isLoading) {
  //     return super._getBody(tab: tab);
  //   }

  //   return FutureBuilder<dynamic>(
  //     future: getCallApiFunctionIfNull(context, tab: tab),
  //     builder: (context, snapshot) {
  //       // debugPrint("BasePageApi snapshot: $snapshot");
  //       if (snapshot.hasError) {
  //         return getErrorWidget();
  //       } else if (snapshot.connectionState == ConnectionState.done) {
  //         _isLoading = false;
  //         if (snapshot.data != null) {
  //           setExtras(ex: snapshot.data, tabH: tab);
  //           if (ex is ViewAbstract) {
  //             // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //             //   context.read<ListMultiKeyProvider>().edit(ex);
  //             // });
  //           }
  //           return super._getBody(tab: tab);
  //         } else {
  //           return getErrorWidget();
  //         }
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         _isLoading = true;
  //         return super._getBody(tab: tab);
  //       } else {
  //         return const Text("TOTODO");
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
    _isLoading = !getBodyWithoutApi();
    if (getExtras() != null && !_isLoading) {
      return super.build(context);
    }

    return FutureBuilder<dynamic>(
      future: getCallApiFunctionIfNull(context),
      builder: (context, snapshot) {
        debugPrint("BasePageApi snapshot: $snapshot");
        if (snapshot.hasError) {
          _isLoading = false;
          return EmptyWidget(
              lottiUrl:
                  "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
              onSubtitleClicked: () {
                setState(() {});
              },
              title: AppLocalizations.of(context)!.cantConnect,
              subtitle: AppLocalizations.of(context)!.cantConnectRetry);
        } else if (snapshot.connectionState == ConnectionState.done) {
          _isLoading = false;
          if (snapshot.data != null) {
            setExtras(ex: snapshot.data);
            if (getExtras() is ViewAbstract) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                context
                    .read<ListMultiKeyProvider>()
                    .edit(getExtras() as ViewAbstract);
              });
            }
            return super.build(context);
          } else {
            _isLoading = false;
            return EmptyWidget(
                lottiUrl:
                    "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
                onSubtitleClicked: () {
                  setState(() {});
                },
                title: AppLocalizations.of(context)!.cantConnect,
                subtitle: AppLocalizations.of(context)!.cantConnectRetry);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          _isLoading = true;
          return super.build(context);
        } else {
          return const Text("TOTODO");
        }
      },
    );
  }
}
