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
import 'package:flutter_view_controller/screens/web/web_shoping_cart.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/responsive_scroll.dart';
import 'package:provider/provider.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'home/components/drawers/drawer_large_screen.dart';

/// WebSmothSceroll additional offset to users scroll input WEB WAS 150
const scrollOffset = 10;

///WebSmothSceroll animation duration WEB WAS 600
const animationDuration = 250;

const double kDefualtAppBar = 70;

const double kDefualtClipRect = 25;
GlobalKey<BasePageWithApi> globalKeyBasePageWithApi =
    GlobalKey<BasePageWithApi>();

///Auto generate view
///[CurrentScreenSize.MOBILE] if this  is true
///
///
///
abstract class BasePageState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin {
  dynamic _firstWidget;
  dynamic _secondWidget;
  dynamic _width;
  dynamic _height;

  final ScrollController _scrollFirstPaneController = ScrollController();
  final ScrollController _scrollSecoundPaneController = ScrollController();
  bool pinToolbar = false;
  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;
  bool buildDrawer;
  bool buildSecoundPane;

  BasePageState({this.buildDrawer = true, this.buildSecoundPane = true});
  // The listener
  final _connectionListener = ConnectionListener();

  final firstPaneScaffold = GlobalKey<ScaffoldMessengerState>();
  final secondPaneScaffold = GlobalKey<ScaffoldMessengerState>();
  final ValueNotifier<int> baseBottomSheetValueNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> firstPaneBottomSheetValueNotifier =
      ValueNotifier<int>(0);
  final ValueNotifier<int> secoundPaneBottomSheetValueNotifier =
      ValueNotifier<int>(0);

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getDesktopFirstPane({TabControllerHelper? tab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getFirstPane({TabControllerHelper? tab});

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab});

  Widget? getBaseFloatingActionButton();
  Widget? getFirstPaneFloatingActionButton({TabControllerHelper? tab});
  Widget? getSecondPaneFloatingActionButton({TabControllerHelper? tab});
  Widget? getBaseAppbar();
  Widget? getFirstPaneAppbar({TabControllerHelper? tab});
  Widget? getSecondPaneAppbar({TabControllerHelper? tab});

  List<Widget>? getBaseBottomSheet();

  //TODO
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab});
  //TODO
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab});

  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab});
  bool isPaneScaffoldOverlayColord(bool firstPane, {TabControllerHelper? tab});
  bool setBodyPadding(bool firstPane, {TabControllerHelper? tab});

  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab});

  late CurrentScreenSize _currentScreenSize;
  late TabController _tabBaseController;
  late TabController _tabControllerFirstPane;
  late TabController _tabControllerSecondPane;
  int currentBaseTabIndex = 0;
  int currentPaneIndexFirstPane = 0;
  int currentPaneIndexSecondPane = 0;
  List<TabControllerHelper>? _tabList;
  List<TabControllerHelper>? _tabListFirstPane;
  List<TabControllerHelper>? _tabListSecondPane;
  ValueNotifier<int> onTabSelectedSecondPane = ValueNotifier<int>(0);
  get getWidth => this._width;

  get getHeight => this._height;

  bool isDesktopPlatform() => isDesktop(context);

  List<TabControllerHelper>? _getTabBarList() {
    return _tabList;
  }

  List<TabControllerHelper>? _getTabBarListSecondPane() {
    return _tabListSecondPane;
  }

  List<TabControllerHelper>? _getTabBarListFirstPane() {
    return _tabListFirstPane;
  }

  List<TabControllerHelper>? initTabBarList() {
    return null;
  }

  List<TabControllerHelper>? initTabBarListFirstPane(
      {TabControllerHelper? tab}) {
    return null;
  }

  List<TabControllerHelper>? initTabBarListSecondPane(
      {TabControllerHelper? tab}) {
    return null;
  }

  bool _hasBaseTabBarList() {
    return _getTabBarList() != null;
  }

  bool _hasTabBarListFirstPane() {
    return _getTabBarListFirstPane() != null;
  }

  bool _hasTabBarListSecondPane() {
    return _getTabBarListSecondPane() != null;
  }

  bool _hasTabBarList({bool? firstPane}) {
    if (firstPane == null) return _hasBaseToolbar();
    return firstPane ? _hasTabBarListFirstPane() : _hasTabBarListSecondPane();
  }

  TabController getTabController({bool? firstPane}) {
    if (firstPane == null) return _tabBaseController;
    return firstPane ? _tabControllerFirstPane : _tabControllerSecondPane;
  }

  List<Widget> getTabsForTabController({bool? firstPane}) {
    if (firstPane == null) return _tabList!;
    return firstPane ? _tabListFirstPane! : _tabListSecondPane!;
  }

  PreferredSizeWidget? getTabBarWidget({bool? firstPane}) {
    if (!_hasTabBarList(firstPane: firstPane)) {
      debugPrint("getTabBarWidget !has tabBarList pane $firstPane");
      return null;
    }
    return TabBar(
        controller: getTabController(firstPane: firstPane),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        // labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
        isScrollable: true,
        //  firstPane != null,
        tabs: getTabsForTabController(firstPane: firstPane));
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
      CurrentScreenSize s = getCurrentScreenSize();
      debugPrint("getCustomPaneProportion called");
      // if ( return 0.5;
      if (s == CurrentScreenSize.MOBILE ||
          s == CurrentScreenSize.SMALL_TABLET ||
          MediaQuery.of(context).hinge != null) {
        return 0.5;
      }
      if (SizeConfig.isMediumFromScreenSize(context)) {
        return 0.5;
      } else {
        double defualtWidth = 0;
        if (s case CurrentScreenSize.DESKTOP) {
          defualtWidth = kDesktopWidth;
          return .3;
        } else if (s case CurrentScreenSize.LARGE_TABLET) {
          defualtWidth = kLargeTablet;
        } else if (s case CurrentScreenSize.MOBILE) {
          return .5;
        } else if (s case CurrentScreenSize.SMALL_TABLET) {
          return .5;
        }

        double sss = max(
          defualtWidth - _width,
          _width - defualtWidth,
        );
        debugPrint(
            " current width $_width  defualt width $defualtWidth   VALUE=$sss  ");

        return sss > 250 ? 0.3 : 0.5;
      }
    }
  }

  ///generate all toolbars for the base and first pane and second pane
  ///if [customAppBar] is null then generates the base toolbar
  ///else if [customAppBar] is not null then generates the app bar based on the panes
  generateToolbar({Widget? customAppBar, bool? firstPane}) {
    Widget? baseAppbar = getBaseAppbar();
    return AppBar(
        surfaceTintColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        forceMaterialTransparency: false,
        // primary: true,

        backgroundColor: customAppBar != null
            ? ElevationOverlay.overlayColor(context, 2)
            : null,
        toolbarHeight: customAppBar == null
            ? baseAppbar == null
                ? null
                : 100
            : null,
        // backgroundColor: ElevationOverlay.overlayColor(context, 2),
        // leading: ,
        title: customAppBar ?? baseAppbar,
        leading: showHamburger(getCurrentScreenSize())
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _drawerMenuControllerProvider.controlStartDrawerMenu();
                },
              )
            : null,
        bottom: getTabBarWidget(firstPane: firstPane));
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

  Widget checkTogetTabbarSliver(bool firstPane) {
    if (firstPane) {
      return getTabbarSliver(_tabListFirstPane!, _tabControllerFirstPane);
    } else {
      return getTabbarSliver(_tabListSecondPane!, _tabControllerSecondPane);
    }
  }

  Widget getTabbarSliver(
      List<TabControllerHelper> tabs, TabController tabController) {
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: EdgeInsets.zero,
        sliver: SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegatePreferedSize(
                wrapWithSafeArea: true,
                child: ColoredTabBar(
                  useCard: false,
                  color: Theme.of(context).colorScheme.surface.withOpacity(.9),
                  cornersIfCard: 80.0,
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    tabs: tabs,
                    isScrollable: true,
                    controller: tabController,
                  ),
                ))),
      ),
    );
  }

  ScrollController getScrollController(bool firstPane,
      {TabControllerHelper? tab}) {
    if (tab != null) {
      return firstPane
          ? tab.scrollFirstPaneController
          : tab.scrollSecoundPaneController;
    }
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
        body = ResponsiveScroll(
          controller: getScrollController(firstPane, tab: tab),
          animationDuration: animationDuration,
          scrollOffset: scrollOffset,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: getScrollController(firstPane, tab: tab),
            slivers: [
              if (appBar != null) getSliverAppBar(appBar),
              if (_hasTabBarList(firstPane: firstPane))
                checkTogetTabbarSliver(firstPane),
              ...list
            ],
          ),
        );
      } else {
        debugPrint(
            "BasePage IsPanel  isDesktopOrWebPlatform flassse isSliver ${isPanesIsSliver(firstPane)} body $body");
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: getScrollController(firstPane, tab: tab),
          slivers: [
            if (appBar != null) getSliverAppBar(appBar),
            if (_hasTabBarList(firstPane: firstPane))
              checkTogetTabbarSliver(firstPane),
            ...list
          ],
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
          : generateToolbar(firstPane: firstPane, customAppBar: appBarBody),
      bottomSheet: generatePaneBottomSheet(firstPane, tab: tab),
      body: Padding(
        padding: setBodyPadding(firstPane, tab: tab)
            ? const EdgeInsets.all(kDefaultPadding / 2)
            : EdgeInsets.zero,
        child: body,
      ),
    );

    if (setPaneClipRect(firstPane, tab: tab)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius),
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
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabList = initTabBarList();

      /// Here you can have your context and do what ever you want
      if (_hasBaseTabBarList()) {
        _tabBaseController =
            TabController(vsync: this, length: _tabList!.length);
        _tabBaseController.addListener(_tabControllerChangeListener);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _connectionListener.dispose();
    if (_hasBaseTabBarList()) {
      _tabBaseController.removeListener(_tabControllerChangeListener);
      _tabBaseController.dispose();
    }
    if (_hasTabBarListFirstPane()) {
      _tabControllerFirstPane
          .removeListener(_tabControllerChangeListenerFirstPane);
      _tabControllerFirstPane.dispose();
    }
    if (_hasTabBarListSecondPane()) {
      _tabControllerSecondPane
          .removeListener(_tabControllerChangeListenerSecondPane);
      _tabControllerSecondPane.dispose();
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
    return ScreenHelperSliver(
        requireAutoPadding: false,
        onChangeLayout: (w, h, c) {
          debugPrint("ScreenHelperSliver build width:$w");
          reset();
          _width = w;
          _height = h;
          _currentScreenSize = c;
          if (buildDrawer) {
            _drawerWidget = DrawerLargeScreens(
              size: _currentScreenSize,
            );
          }
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

  beforeGetDesktopSecoundPaneWidget(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getDesktopSecondPane(tab: tab, secoundTab: secoundTab);
  }

  beforeGetFirstPaneWidget({TabControllerHelper? tab}) {
    return getFirstPane(tab: tab);
  }

  beforeGetSecondPaneWidget(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getSecoundPane(tab: tab, secoundTab: secoundTab);
  }

  void _setupPaneTabBar(bool firstPane, {TabControllerHelper? tab}) {
    if (firstPane) {
      _tabListFirstPane = initTabBarListFirstPane(tab: tab);
      if (_hasTabBarListFirstPane()) {
        _tabControllerFirstPane =
            TabController(vsync: this, length: _tabListFirstPane!.length);
        _tabControllerFirstPane
            .addListener(_tabControllerChangeListenerFirstPane);
      }
    } else {
      _tabListSecondPane = initTabBarListSecondPane(tab: tab);
      if (_hasTabBarListSecondPane()) {
        _tabControllerSecondPane =
            TabController(vsync: this, length: _tabListSecondPane!.length);

        _tabControllerSecondPane
            .addListener(_tabControllerChangeListenerSecondPane);
      }
    }
  }

  Widget _getTowPanes({TabControllerHelper? tab}) {
    if (isMobile(context, maxWidth: getWidth)) {
      _firstWidget = beforeGetFirstPaneWidget(tab: tab);
      return _setSubAppBar(_firstWidget, true)!;
    }
    _setupPaneTabBar(false, tab: tab);
    _setupPaneTabBar(true, tab: tab);
    if (isDesktop(context, maxWidth: getWidth)) {
      if (_hasTabBarList(firstPane: true)) {
        _firstWidget = TabBarView(
            controller: _tabControllerFirstPane,
            children: _getTabBarListFirstPane()!
                .map((e) => beforeGetDesktopFirstPaneWidget(tab: e))
                .toList()
                .cast());
      } else {
        _firstWidget = beforeGetDesktopFirstPaneWidget(tab: tab);
      }

      _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);

      if (_hasTabBarList(firstPane: false)) {
        _secondWidget = TabBarView(
            controller: _tabControllerSecondPane,
            children: _getTabBarListSecondPane()!
                .map((e) => beforeGetDesktopSecoundPaneWidget(tab: e))
                .toList()
                .cast());
      } else {
        _secondWidget = beforeGetDesktopSecoundPaneWidget(tab: tab);
      }
      _secondWidget = _setSubAppBar(_secondWidget, false, tab: tab);
    } else {
      _firstWidget = beforeGetFirstPaneWidget(tab: tab);
      _firstWidget = _setSubAppBar(_firstWidget, true, tab: tab);
      if (buildSecoundPane) {
        _secondWidget = beforeGetSecondPaneWidget(tab: tab);
        _secondWidget = _setSubAppBar(_secondWidget, false, tab: tab);
      }
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

  Widget? generateBaseBottomSheet() {
    return null;
  }

  Widget? generatePaneBottomSheet(bool firstPane, {TabControllerHelper? tab}) {
    return null;
  }

  SizedBox getEndDrawer() {
    return const SizedBox(
        width: 500, child: Card(child: WebShoppingCartDrawer()));
  }

  Widget _getTabletWidget() {
    return Scaffold(
        bottomNavigationBar: generateBaseBottomSheet(),
        endDrawer: getEndDrawer(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getBaseFloatingActionButton(),
        key: _drawerMenuControllerProvider.getStartDrawableKey,
        drawer: buildDrawer ? _drawerWidget : null,
        body: _getBody());
  }

  Widget getBodyIfHasTabBarList(bool isLarge) {
    Widget currentWidget;
    currentWidget = TabBarView(
        controller: _tabBaseController,
        children: _getTabBarList()!.map((e) => _getTowPanes(tab: e)).toList());
    if (isLarge) {
      if (buildDrawer) {
        currentWidget = Row(
            children: [_drawerWidget!, getSelectorBodyIsLarge(currentWidget)]);
      } else {
        currentWidget = getSelectorBodyIsLarge(currentWidget);
      }
    }
    return Scaffold(
      backgroundColor: ElevationOverlay.overlayColor(context, 2),
      appBar: generateToolbar(),
      body: currentWidget,
    );
  }

  Widget _getBody() {
    Widget currentWidget;
    bool isLarge = isDesktop(context, maxWidth: getWidth) ||
        isTablet(context, maxWidth: getWidth);

    if (_hasBaseTabBarList()) {
      currentWidget = getBodyIfHasTabBarList(isLarge);
    } else {
      currentWidget = _getTowPanes();
    }
    return currentWidget;
  }

  Widget getSelectorBodyIsLarge(Widget currentWidget) {
    if (!buildDrawer) {
      return currentWidget;
    }
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        debugPrint("drawer selector $isOpen");
        Widget toShowWidget;
        Widget clipRect = ClipRRect(
            borderRadius: BorderRadius.circular(kDefualtClipRect),
            child: _hasBaseToolbar()
                ? Scaffold(
                    backgroundColor: ElevationOverlay.overlayColor(context, 2),
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
    );
  }

  void _tabControllerChangeListener() {
    currentBaseTabIndex = _tabBaseController.index;
    debugPrint("_tabController $currentBaseTabIndex");
  }

  void _tabControllerChangeListenerFirstPane() {
    currentPaneIndexFirstPane = _tabControllerFirstPane.index;
    debugPrint("_tabController $currentBaseTabIndex");
  }

  void _tabControllerChangeListenerSecondPane() {
    currentPaneIndexSecondPane = _tabControllerSecondPane.index;
    debugPrint("_tabControllerChangeListenerSecondPane $currentBaseTabIndex");
  }

  void changeTabIndex(int index) {
    debugPrint("_tabController $index");
    if (!_hasBaseTabBarList()) return;
    debugPrint("_tabController $index");
    currentBaseTabIndex = index;
    _tabBaseController.index = index;
  }

  void changeTabIndexFirstPane(int index) {
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    if (!_hasTabBarListFirstPane()) return;
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    currentPaneIndexFirstPane = index;
    _tabControllerFirstPane.index = index;
  }

  void changeTabIndexSecondPane(int index) {
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    if (!_hasTabBarListSecondPane()) return;
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    currentPaneIndexSecondPane = index;
    _tabControllerSecondPane.index = index;
  }
}

abstract class BasePageWithApi<T extends StatefulWidget>
    extends BasePageState<T> {
  final refreshListener = ValueNotifier<bool>(true);
  int? iD;
  String? tableName;
  dynamic extras;
  bool _isLoading = false;

  BasePageWithApi(
      {this.iD,
      this.tableName,
      this.extras,
      super.buildDrawer,
      super.buildSecoundPane});
  Future<dynamic> getCallApiFunctionIfNull(BuildContext context,
      {TabControllerHelper? tab});
  ServerActions getServerActions();

  dynamic getExtras({TabControllerHelper? tab}) {
    if (_hasBaseTabBarList()) {
      if (tab != null) {
        dynamic result = _getTabBarList()!.firstWhere(
            (element) => element.extras.runtimeType == tab.extras.runtimeType);
        if (result == null) {
          throw Exception("Could not find tab");
        }
        return result.extras;
      }
      return _getTabBarList()![currentBaseTabIndex].extras;
    }
    return extras;
  }

  TabControllerHelper? findExtrasViaTypeList(List<TabControllerHelper>? list,
      bool Function(TabControllerHelper) test) {
    if (list != null) {
      return list.firstWhereOrNull(test);
    } else {
      return extras;
    }
  }

  int findExtrasIndexFromTabList(List<TabControllerHelper>? list,
      bool Function(TabControllerHelper) test) {
    if (list != null) {
      return list.indexWhere(test);
    } else {
      return -1;
    }
  }

  //todo check return type if not tab bar then return extras ??
  TabControllerHelper? findExtrasViaType(Type extra) {
    if (_hasBaseTabBarList()) {
      return findExtrasViaTypeList(
          _getTabBarList(), (e) => e.extras.runtimeType == extra);
    } else {
      return extras;
    }
  }

  int findExtrasIndexFromTab(Type extra) {
    if (_hasBaseTabBarList()) {
      return findExtrasIndexFromTabList(
          _getTabBarList(), (element) => element.extras.runtimeType == extra);
    } else {
      return -1;
    }
  }

  int findExtrasIndexFromTabSecoundPane(Type extra) {
    if (_hasBaseTabBarList()) {
      return findExtrasIndexFromTabList(
          _getTabBarList(), (element) => element.extras.runtimeType == extra);
    } else {
      return -1;
    }
  }

  bool isExtrasIsDashboard({TabControllerHelper? tab}) {
    return getExtras(tab: tab) is DashableInterface;
  }

  DashableInterface getExtrasCastDashboard({TabControllerHelper? tab}) {
    return getExtras(tab: tab) as DashableInterface;
  }

  ViewAbstract getExtrasCast({TabControllerHelper? tab}) {
    return getExtras(tab: tab) as ViewAbstract;
  }

  void setExtras(
      {int? iD, String? tableName, dynamic ex, TabControllerHelper? tabH}) {
    _isLoading = false;
    if (_hasBaseTabBarList()) {
      TabControllerHelper tab = tabH ?? _getTabBarList()![currentBaseTabIndex];
      tab.extras = ex;
      tab.iD = iD;
      tab.tableName = tableName;
      if (tabH != null) {
        _getTabBarList()![_getTabBarList()!.indexWhere((element) =>
            element.extras.runtimeType == tabH.extras.runtimeType)] = tab;
      } else {
        _getTabBarList()![currentBaseTabIndex] = tab;
      }
    } else {
      this.extras = ex;
      this.iD = iD;
      this.tableName = tableName;
    }
  }

  void refresh(
      {int? iD, String? tableName, dynamic extras, TabControllerHelper? tab}) {
    debugPrint("refresh basePage");
    setExtras(iD: iD, tableName: tableName, ex: extras, tabH: tab);
    setState(() {});
  }

  bool getBodyWithoutApi({TabControllerHelper? tab}) {
    dynamic ex = getExtras(tab: tab);
    if (ex is! ViewAbstract) return false;
    if (ex is DashableInterface) {
      if ((ex as DashableInterface)
              .getDashboardShouldWaitBeforeRequest(context, tab: tab) !=
          null) {
        return true;
      }
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

    var shouldWaitWidget;
    if (isExtrasIsDashboard()) {
      shouldWaitWidget = getExtrasCastDashboard(tab: tab)
          .getDashboardShouldWaitBeforeRequest(context,
              globalKey: globalKeyBasePageWithApi, firstPane: true, tab: tab);
    }
    return shouldWaitWidget ?? super.beforeGetFirstPaneWidget(tab: tab);
  }

  @override
  beforeGetDesktopFirstPaneWidget({TabControllerHelper? tab}) {
    if (_isLoading) return getLoadingWidget(true, tab: tab);
    var shouldWaitWidget;
    if (isExtrasIsDashboard()) {
      shouldWaitWidget = getExtrasCastDashboard(tab: tab)
          .getDashboardShouldWaitBeforeRequest(context,
              globalKey: globalKeyBasePageWithApi, firstPane: true, tab: tab);
    }
    return shouldWaitWidget ?? super.beforeGetDesktopFirstPaneWidget(tab: tab);
  }

  @override
  beforeGetDesktopSecoundPaneWidget(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    if (_isLoading) return getLoadingWidget(false, tab: tab);
    var shouldWaitWidget;
    if (isExtrasIsDashboard()) {
      shouldWaitWidget = getExtrasCastDashboard(tab: tab)
          .getDashboardShouldWaitBeforeRequest(context,
              globalKey: globalKeyBasePageWithApi, firstPane: false, tab: tab);
    }
    return shouldWaitWidget ??
        super.beforeGetDesktopSecoundPaneWidget(
            tab: tab, secoundTab: secoundTab);
  }

  @override
  beforeGetSecondPaneWidget(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    if (_isLoading) return getLoadingWidget(false, tab: tab);
    var shouldWaitWidget;
    if (isExtrasIsDashboard()) {
      shouldWaitWidget = getExtrasCastDashboard(tab: tab)
          .getDashboardShouldWaitBeforeRequest(context,
              globalKey: globalKeyBasePageWithApi, firstPane: false, tab: tab);
    }
    return shouldWaitWidget ??
        super.beforeGetSecondPaneWidget(tab: tab, secoundTab: secoundTab);
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
          debugPrint(
              "BasePageApi FutureBuilder done snape data ${snapshot.data.runtimeType}");
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
