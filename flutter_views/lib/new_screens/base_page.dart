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
abstract class BasePageState<T extends StatefulWidget> extends State<T> {
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
  getDesktopFirstPane(double width);

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getDesktopSecondPane(double width);

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getFirstPane(double width);

  ///on enable sliver [isPanesIsSliver] then this method should return List<Widget> else Widget?
  getSecoundPane(double width);

  Widget? getBaseFloatingActionButton(CurrentScreenSize currentScreenSize);
  Widget? getFirstPaneFloatingActionButton(CurrentScreenSize currentScreenSize);
  Widget? getSecondPaneFloatingActionButton(
      CurrentScreenSize currentScreenSize);
  Widget? getBaseAppbar(CurrentScreenSize currentScreenSize);
  Widget? getFirstPaneAppbar(CurrentScreenSize currentScreenSize);
  Widget? getSecondPaneAppbar(CurrentScreenSize currentScreenSize);

  Widget? getBaseBottomSheet();

  Widget? getFirstPaneBottomSheet();
  Widget? getSecondPaneBottomSheet();

  bool isPanesIsSliver(bool firstPane);
  bool isPaneScaffoldOverlayColord(bool firstPane);
  bool setBodyPadding(bool firstPane);

  bool setPaneClipRect(bool firstPane);

  late CurrentScreenSize _currentScreenSize;

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
      title: customAppBar ?? getBaseAppbar(getCurrentScreenSize())!,
      bottom: customAppBar == null
          ? TabBar(
              dividerColor: Colors.transparent,
              // labelStyle: Theme.of(context).textTheme.titleSmall,
              indicatorSize: TabBarIndicatorSize.tab,
              // indicatorColor:
              //     Theme.of(context).colorScheme.primary.withOpacity(.2),
              // labelColor: Theme.of(context).colorScheme.primary,

              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(80.0),
                color:
                    Theme.of(context).colorScheme.onSecondary,
              ),
              isScrollable: true,
              tabs: [
                  Tab(
                    // text: "FirstTab",
                    icon: Icon(Icons.dashboard),
                  ),
                  Tab(
                    text: "FirstTab",
                    // icon: Icon(Icons.dashboard),
                  ),
                  Tab(
                    text: "FirstTab",
                    // icon: Icon(Icons.dashboard),
                  ),
                  Tab(
                    text: "FirstTab",
                    // icon: Icon(Icons.dashboard),
                  )
                ])
          : null,
    );
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

  Widget? _getScrollContent(widget, Widget? appBar, bool firstPane) {
    dynamic body = widget;
    debugPrint(
        "BasePage IsPanel isSliver started=> firstPane ${isPanesIsSliver(firstPane)}");

    if (isPanesIsSliver(firstPane)) {
      List<Widget> list = body;
      debugPrint(
          "BasePage IsPanel isSliver ${isPanesIsSliver(firstPane)} body $body");
      if (SizeConfig.isDesktopOrWebPlatform(context)) {
        debugPrint(
            "BasePage IsPanel  isDesktopOrWebPlatform isSliver ${isPanesIsSliver(firstPane)} body $body");
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
        "BasePage IsPanel isSliver=> ${isPanesIsSliver(firstPane)} body $body");
    return body;
  }

  ///setting appbar but when is sliver then we added to CustomScrollView Sliver
  Widget? _setSubAppBar(widget, bool firstPane) {
    Widget? appBarBody = firstPane
        ? getFirstPaneAppbar(getCurrentScreenSize())
        : getSecondPaneAppbar(getCurrentScreenSize());

    Widget? body = _getScrollContent(widget, appBarBody, firstPane);
    Widget scaffold = Scaffold(
      // key: firstPane ? firstPaneScaffold : secondPaneScaffold,
      backgroundColor: isPaneScaffoldOverlayColord(firstPane)
          ? ElevationOverlay.overlayColor(context, 0)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: firstPane
          ? getFirstPaneFloatingActionButton(getCurrentScreenSize())
          : getSecondPaneFloatingActionButton(getCurrentScreenSize()),
      appBar: isPanesIsSliver(firstPane) || appBarBody == null
          ? null
          : generateToolbar(customAppBar: appBarBody),
      bottomSheet:
          firstPane ? getFirstPaneBottomSheet() : getSecondPaneBottomSheet(),
      body: Padding(
        padding: setBodyPadding(firstPane)
            ? const EdgeInsets.all(kDefaultPadding)
            : EdgeInsets.zero,
        child: body,
      ),
    );

    if (setPaneClipRect(firstPane)) {
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
    super.initState();
  }

  @override
  void dispose() {
    _connectionListener.dispose();
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

    if (isDesktop(context, maxWidth: w)) {
      _firstWidget = getDesktopFirstPane(w);
      _secondWidget = getDesktopSecondPane(w);
      _firstWidget = _setSubAppBar(_firstWidget, true);
      _secondWidget = _setSubAppBar(_secondWidget, false);

      // if
    } else {
      _firstWidget = getFirstPane(w);
      _secondWidget = getSecoundPane(w);
      _firstWidget = _setSubAppBar(_firstWidget, true);
      _secondWidget = _setSubAppBar(_secondWidget, false);
    }
    if (_secondWidget == null) {
      return _firstWidget!;
    }

    if (getHasDecorationOnFirstPane()) {
      _firstWidget = _getBorderDecoration(_firstWidget!);
    }

    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _secondWidget,
      customPaneProportion: getCustomPaneProportion(),
    );
  }

  Widget _getTabletWidget(double w) {
    Widget body = _getBody(w);
    Widget t = Scaffold(
        // extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton:
            getBaseFloatingActionButton(getCurrentScreenSize()),
        drawer: _drawerWidget,
        body: true ? TabBarView(children: [body, body, body, body]) : body);

    if (true) {
      return DefaultTabController(length: 4, child: t);
    } else {
      return t;
    }
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

abstract class BasePageWithApi<T extends StatefulWidget>
    extends BasePageState<T> {
  final refreshListener = ValueNotifier<bool>(true);
  int? iD;
  String? tableName;
  dynamic extras;
  bool _isLoading = false;

  BasePageWithApi({this.iD, this.tableName, this.extras});
  Future<dynamic> getCallApiFunctionIfNull(BuildContext context);
  ServerActions getServerActions();

  dynamic getExtras() {
    return extras;
  }

  void refresh({int? iD, String? tableName, dynamic extras}) {
    this.iD = iD;
    this.tableName = tableName;
    this.extras = extras;
    // refreshListener.value = !refreshListener.value;
    setState(() {});
  }

  bool getBodyWithoutApi() {
    if (extras is! ViewAbstract) return false;
    if (extras is DashableInterface) {
      return (extras as ViewAbstract).isRequiredObjectsListChecker();
    }
    bool canGetBody =
        (extras as ViewAbstract).isRequiredObjectsList()?[getServerActions()] ==
            null;
    if (canGetBody) {
      debugPrint("BasePageWithApi getBodyWithoutApi skiped");
      return true;
    }
    bool res = (extras as ViewAbstract).isNew() ||
        (extras as ViewAbstract).isRequiredObjectsListChecker();
    debugPrint("BasePageWithApi getBodyWithoutApi result => $res");
    return res;
  }

  @override
  generateToolbar({Widget? customAppBar}) {
    if (_isLoading) {
      return null;
    }
    return super.generateToolbar(customAppBar: customAppBar);
  }

  @override
  Widget _getTowPanes(double w) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return super._getTowPanes(w);
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    _isLoading = !getBodyWithoutApi();
    if (extras != null && getBodyWithoutApi()) {
      widget = super.build(context);
    }

    widget = FutureBuilder<dynamic>(
      future: getCallApiFunctionIfNull(context),
      builder: (context, snapshot) {
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
            extras = snapshot.data;
            if (extras is ViewAbstract) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                context
                    .read<ListMultiKeyProvider>()
                    .edit(extras as ViewAbstract);
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
          ;
        } else {
          return const Text("TOTODO");
        }
      },
    );

    return widget;
    // ValueListenableBuilder<DateObject?>(
    //     valueListenable: selectDateChanged,
    //     builder: ((context, value, child) {
    //       // widget.dashboard.setDate(value);
    //       extras = widget.dashboard;
    //       extras.setDate(value);
    //       debugPrint("BasePageApi refreshing refreshListener");
    //       setState(() {});
    //       return Text("s");
    //     }));
  }
}
