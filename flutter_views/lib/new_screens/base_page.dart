import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity_listener/connectivity_listener.dart';
import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/color_tabbar.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_base.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget_new.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page_new.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile_new.dart';
import 'package:flutter_view_controller/screens/web/web_shoping_cart.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/responsive_scroll.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

mixin TickerWidget<T extends StatefulWidget> on State<T> {
  int getTickerSecond();

  Timer? _timer;

  void initTimer() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(Duration(seconds: getTickerSecond()), (timer) {
      setState(() {});
    });
  }

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}

mixin BasePageWithDraggablePage<T extends StatefulWidget> on BasePageState<T> {
  ValueNotifier<QrCodeNotifierState?>? getValueNotifierQrState(bool firstPane);
  Widget? getDraggableHeaderWidget(bool firstPane);
  Widget? getDraggableHeaderExpandedWidget(bool firstPane);

  Widget _getDraggableHomePane(widget, bool firstPane,
      {TabControllerHelper? tab}) {
    bool isLargeScreen = isLargeScreenFromScreenSize(_currentScreenSize);
    return DraggableHome(
      valueNotifierQrState: getValueNotifierQrState(firstPane),
      showLeadingAsHamborg: !isLargeScreen,
      floatingActionButton: firstPane
          ? getFirstPaneFloatingActionButton(tab: tab)
          : getSecondPaneFloatingActionButton(tab: tab),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      stretchTriggerOffset: .7,
      leading: Icon(Icons.date_range),
      alwaysShowLeadingAndAction: false,
      showAppbarOnTopOnly: false,
      headerWidget: getDraggableHeaderWidget(firstPane),
      expandedBody: getDraggableHeaderExpandedWidget(firstPane),

      title: firstPane
          ? getFirstPaneAppbarTitle(tab: tab)
          : getSecondPaneAppbarTitle(tab: tab),
      headerExpandedHeight: isLargeScreen
          ? 0.1
          : isSelectedMode
              ? 0.25
              : 0.4,
      stretchMaxHeight: isSelectedMode ? .3 : .5,
      fullyStretchable: isLargeScreen
          ? false
          : isSelectedMode
              ? false
              : true,
      // headerBottomBar: getHeaderWidget(),
      pinnedToolbar: isSelectedMode,
      centerTitle: false,
      actions: !isSelectedMode
          ? getAppbarActions(firstPane: firstPane, tab: tab)
          : [IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],

      // tabBuilder: (p0) {
      //   return getF
      // },
      // actions: getSharedAppBarActions,
      slivers: widget as List<Widget>,
    );
  }

  @override
  Widget getTowPanes({TabControllerHelper? tab}) {
    _setupPaneTabBar(true, tab: tab);
    _setupPaneTabBar(false, tab: tab);
    _firstWidget = beforeGetFirstPaneWidget(tab: tab);

    _firstWidget = _getDraggableHomePane(_firstWidget, true, tab: tab);

    _secondWidget = beforeGetSecondPaneWidget(tab: tab);
    _secondWidget = _getDraggableHomePane(_secondWidget, false, tab: tab);

    return getPaneExt();
  }
  // NotificationListener<ScrollNotification> getNotificationListener(
  //     double expandedHeight,
  //     double appBarHeight,
  //     double fullyExpandedHeight,
  //     double topPadding,
  //     {TabControllerHelper? tab}) {
  //   return NotificationListener<ScrollNotification>(
  //       onNotification: (notification) {
  //         if (notification is ScrollEndNotification &&
  //             notification.metrics.axis == Axis.vertical) {
  //           Configurations.saveScrollOffset(
  //               context, notification.metrics.pixels, bucketOffsetKey);
  //           debugPrint(
  //               "currentPageScroll ${Configurations.currentPageScrollOffset(context, bucketOffsetKey)}");
  //         }
  //         if (notification.metrics.axis == Axis.vertical) {
  //           // isFullyCollapsed
  //           if ((isFullyExpanded.value) &&
  //               notification.metrics.extentBefore > 100) {
  //             isFullyExpanded.add(false);
  //           }

  //           //isFullyCollapsed
  //           if (notification.metrics.extentBefore >
  //               expandedHeight - AppBar().preferredSize.height - 40) {
  //             if (!(isFullyCollapsed.value)) isFullyCollapsed.add(true);
  //           } else {
  //             if ((isFullyCollapsed.value)) isFullyCollapsed.add(false);
  //           }
  //         }
  //         return false;
  //       },
  //       child: sliver(context, appBarHeight, fullyExpandedHeight,
  //           expandedHeight, topPadding));
  // }
}

mixin BasePageWithTicker<T extends StatefulWidget> on BasePageState<T> {
  ValueNotifier valueFirstPane = ValueNotifier(null);
  ValueNotifier valueSecondPane = ValueNotifier(null);

  ValueNotifierPane getTickerPane();

  getTickerFirstPane(
    bool isDesktop, {
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  });

  getTickerSecondPane(
    bool isDesktop, {
    TabControllerHelper? tab,
    TabControllerHelper? secoundTab,
  });

  int getTickerSecond();

  Timer? _timer;

  void initTimer() {
    if (_timer != null && _timer!.isActive) return;
    ValueNotifierPane p = getTickerPane();
    _timer = Timer.periodic(Duration(seconds: getTickerSecond()), (timer) {
      debugPrint("Ticker is active");
      switch (p) {
        case ValueNotifierPane.FIRST:
          valueFirstPane.value = Random().nextDouble();
          break;
        case ValueNotifierPane.SECOND:
          valueSecondPane.value = Random().nextDouble();
          break;
        case ValueNotifierPane.BOTH:
          valueFirstPane.value = Random().nextDouble();
          valueSecondPane.value = Random().nextDouble();
          break;
        default:
          break;
      }
    });
  }

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  getDesktopFirstPane({TabControllerHelper? tab}) {
    return getWidgetFromBase(true, true, tab: tab);
  }

  @override
  getDesktopSecondPane(
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(false, true, tab: tab);
  }

  @override
  getSecoundPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(false, false, tab: tab);
  }

  @override
  getFirstPane({TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return getWidgetFromBase(true, false, tab: tab);
  }

  getWidgetFromBase(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab}) {
    debugPrint("BasePageActionOnToolbarMixin getWidgetFromBase");
    ValueNotifierPane pane = getTickerPane();
    if (pane == ValueNotifierPane.NONE) {
      return getWidget(
        firstPane,
        isDesktop,
        tab: tab,
      );
    }
    if (pane == ValueNotifierPane.BOTH) {
      return getValueListenableBuilder(firstPane, isDesktop, tab);
    }
    if (firstPane) {
      if (pane == ValueNotifierPane.FIRST) {
        return getValueListenableBuilder(firstPane, isDesktop, tab);
      } else {
        return getWidget(
          firstPane,
          isDesktop,
          tab: tab,
        );
      }
    } else {
      if (pane == ValueNotifierPane.SECOND) {
        return getValueListenableBuilder(firstPane, isDesktop, tab);
      } else {
        return getWidget(
          firstPane,
          isDesktop,
          tab: tab,
        );
      }
    }
  }

  Widget getValueListenableBuilder(
      bool firstPane, bool isDesktop, TabControllerHelper? tab) {
    return ValueListenableBuilder(
        valueListenable: firstPane ? valueFirstPane : valueSecondPane,
        builder: (context, value, child) {
          return getWidget(
            firstPane,
            isDesktop,
            tab: tab,
          );
        });
  }

  @override
  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab}) => false;

  Widget getWidget(bool firstPane, bool isDesktop,
      {TabControllerHelper? tab, TabControllerHelper? secoundTab}) {
    return firstPane
        ? getTickerFirstPane(
            isDesktop,
            tab: tab,
            secoundTab: secoundTab,
          )
        : getTickerSecondPane(
            isDesktop,
            tab: tab,
            secoundTab: secoundTab,
          );
  }
}
mixin BasePageWithThirdPaneMixinStatic<T extends StatefulWidget,
    E extends ListToDetailsSecoundPaneHelper> on BasePageState<T> {
  @override
  double getCustomPaneProportion() {
    return getThirdPane() == null ? .5 : 1 / 3;
  }

  Widget? getThirdPane();
  @override
  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: TowPaneExt(
        startPane: _secondWidget,
        customPaneProportion: .5,
        endPane: getThirdPane(),
      ),
      customPaneProportion: getCustomPaneProportion(),
    );
  }
}
mixin BasePageWithThirdPaneMixin<T extends StatefulWidget,
    E extends ListToDetailsSecoundPaneHelper> on BasePageState<T> {
  final ValueNotifier<E?> _valueNotifierSecondToThird = ValueNotifier(null);

  List<E> listOfStackedObject = [];
  void setThirdPane(E? value) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _valueNotifierSecondToThird.value = value;
    });
  }

  @override
  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _getSecondPaneWidgetMixin(),
      customPaneProportion: getCustomPaneProportion(),
    );
  }

  E? getPreviousPane(E? lastPane) {
    if (listOfStackedObject.length == 1 || listOfStackedObject.isEmpty) {
      return null;
    }
    if (lastPane == null) return null;
    int idx = listOfStackedObject.indexOf(lastPane);
    debugPrint(
        "BasePageWithThirdPaneMixin====> getPreviousPane total: ${listOfStackedObject.length} currentIndex: $idx previousIndex: ${idx - 1} ");
    if (listOfStackedObject.length <= (idx - 1)) {
      return listOfStackedObject[idx - 1];
    }
    return null;
  }

  Widget getAppBarLeading(E? item) {
    E? previousPane = getPreviousPane(item);

    if (previousPane == null) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _valueNotifierSecondToThird.value = null;
        },
      );
    } else {
      return BackButton(
        onPressed: () {
          listOfStackedObject.remove(previousPane);
          _valueNotifierSecondToThird.value = previousPane
            ..shouldAddToThirdPaneList = false;
        },
      );
    }
  }

  AppBar getAppBarForThirdPane(E? selectedItem) {
    return AppBar(
      leading: getAppBarLeading(selectedItem),
      title: Text(selectedItem?.actionTitle ?? ""),
    );
  }

  Widget wrapScaffoldInThirdPane(
      {TabControllerHelper? tab,
      ListToDetailsSecoundPaneHelper? selectedItem}) {
    return Scaffold(
        appBar: getAppBarForThirdPane(selectedItem as E?),
        body: super.getWidgetFromListToDetailsSecoundPaneHelper(
            tab: tab, selectedItem: selectedItem));
  }

  void checkValueToAddToList(E? value) {
    if (value == null) {
      listOfStackedObject.clear();
    } else {
      if (value.shouldAddToThirdPaneList) {
        listOfStackedObject.add(value);
      }
    }
  }

  bool canDoThirdPane() {
    return isLargeScreenFromCurrentScreenSize(context);
  }

  Widget? _getSecondPaneWidgetMixin() {
    if (!isLargeScreenFromScreenSize(getCurrentScreenSize())) {
      return _secondWidget;
    }
    // return _secondWidget;
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint(
            "BasePageWithThirdPaneMixin constraints width : ${constraints.maxWidth} height: ${constraints.maxHeight}");
        return ValueListenableBuilder(
          valueListenable: _valueNotifierSecondToThird,
          builder: (context, value, child) {
            bool showThirdPane = value != null;
            checkValueToAddToList(value);

            double width = showThirdPane
                ? constraints.maxWidth * 0.5
                : constraints.maxWidth;

            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                      height: constraints.maxHeight,
                      width: width,
                      child: _secondWidget),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: showThirdPane ? 1 : 0,
                              key: UniqueKey(),
                              child: const VerticalDivider(
                                width: 1,
                              ),
                            );
                          },
                          future:
                              Future.delayed(const Duration(milliseconds: 300)),
                        ),
                  !showThirdPane
                      ? const SizedBox.shrink()
                      : FutureBuilder(
                          future:
                              Future.delayed(const Duration(milliseconds: 300)),
                          builder: (c, d) {
                            if (d.connectionState != ConnectionState.done) {
                              return const SizedBox.shrink();
                            }
                            return SizedBox(
                              width: width - 1,
                              child: AnimatedOpacity(
                                key: UniqueKey(),
                                duration: const Duration(milliseconds: 500),
                                opacity: showThirdPane ? 1 : 0,
                                curve: Curves.linear,
                                child: SlideInRight(
                                  duration: const Duration(milliseconds: 200),
                                  key: Key(value.actionTitle.toString() ?? ""),
                                  // delay: Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: wrapScaffoldInThirdPane(
                                      // tab:tab,
                                      selectedItem: value),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
            );
          },
        );
      },
    );
    // return AnimatedContainer(duration: const Duration(milliseconds: 800),child: SizedBox(width: ,),);
  }
}

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
  bool _isInitialization = true;
  final ScrollController _scrollFirstPaneController = ScrollController();
  final ScrollController _scrollSecoundPaneController = ScrollController();
  bool pinToolbar = false;
  late DrawerMenuControllerProvider _drawerMenuControllerProvider;
  Widget? _drawerWidget;
  bool buildDrawer;
  bool buildSecoundPane;
  bool isSelectedMode = false;

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
  Widget? getFirstPaneAppbarTitle({TabControllerHelper? tab});
  Widget? getSecondPaneAppbarTitle({TabControllerHelper? tab});

  List<Widget>? getBaseBottomSheet();

  //TODO
  List<Widget>? getFirstPaneBottomSheet({TabControllerHelper? tab});
  //TODO
  List<Widget>? getSecondPaneBottomSheet({TabControllerHelper? tab});

  bool isPanesIsSliver(bool firstPane, {TabControllerHelper? tab});
  bool isPaneScaffoldOverlayColord(bool firstPane, {TabControllerHelper? tab});
  bool setPaneBodyPadding(bool firstPane, {TabControllerHelper? tab});

  bool setPaneClipRect(bool firstPane, {TabControllerHelper? tab});

  late CurrentScreenSize _currentScreenSize;
  TabController? _tabBaseController;
  TabController? _tabControllerFirstPane;
  TabController? _tabControllerSecondPane;
  int currentBaseTabIndex = 0;
  int currentPaneIndexFirstPane = 0;
  int currentPaneIndexSecondPane = 0;
  List<TabControllerHelper>? _tabList;
  List<TabControllerHelper>? _tabListFirstPane;
  List<TabControllerHelper>? _tabListSecondPane;
  ValueNotifier<int> onTabSelectedSecondPane = ValueNotifier<int>(0);
  get getWidth => this._width;

  get getHeight => this._height;

  DrawerMenuItem? lastDrawerItemSelected;

  bool isDesktopPlatform() => isDesktop(context);

  List<TabControllerHelper>? _getTabBarList({bool? firstPane}) {
    if (firstPane == null) return _tabList;
    return firstPane ? _tabListFirstPane : _tabListSecondPane;
  }

  List<TabControllerHelper>? initTabBarList(
      {bool? firstPane, TabControllerHelper? tab}) {
    return null;
  }

  bool _hasTabBarList({bool? firstPane}) {
    return _getTabBarList(firstPane: firstPane) != null;
  }

  TabController getTabController({bool? firstPane}) {
    if (firstPane == null) return _tabBaseController!;
    return firstPane ? _tabControllerFirstPane! : _tabControllerSecondPane!;
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
  bool setMainPageSuggestionPadding();

  bool setHorizontalDividerWhenTowPanes();

  bool _hasHorizontalDividerWhenTowPanes() {
    if (_secondWidget != null) {
      return setHorizontalDividerWhenTowPanes();
    }
    return false;
  }

  bool _hasBaseToolbar() {
    return getBaseAppbar() != null;
  }

  bool reverseCustomPane() {
    return false;
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

  List<Widget>? getAppbarActions(
      {bool? firstPane, TabControllerHelper? tab}) {
    return null;
  }

  ///generate all toolbars for the base and first pane and second pane
  ///if [customAppBar] is null then generates the base toolbar
  ///else if [customAppBar] is not null then generates the app bar based on the panes
  generateToolbar({Widget? customAppBar, bool? firstPane}) {
    Widget? baseAppbar = getBaseAppbar();
    bool isBaseAppBar = firstPane == null;
    if (baseAppbar == null && customAppBar == null) {
      return null;
    }
    return AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 100,

        // automaticallyImplyLeading: false,
        forceMaterialTransparency: false,
        actions: !isBaseAppBar
            ? getAppbarActions(firstPane: firstPane)
            : [
                ...getAppbarActions(firstPane: null) ?? [],
                ...getSharedAppBarActions
              ],
        // primary: true,
        automaticallyImplyLeading: false,
        backgroundColor: customAppBar != null
            ? ElevationOverlay.overlayColor(context, 2)
            : null,
        // toolbarHeight: customAppBar == null
        //     ? baseAppbar == null
        //         ? null
        //         : 100
        //     : null,

        // backgroundColor: ElevationOverlay.overlayColor(context, 2),
        // leading: ,
        title: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: customAppBar ?? baseAppbar,
        ),
        leading: hideHamburger(getCurrentScreenSize())
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _drawerMenuControllerProvider.controlStartDrawerMenu();
                },
              ),
        bottom: getTabBarWidget(firstPane: firstPane));
  }

  List<Widget> get getSharedAppBarActions {
    return [
      if (context.read<AuthProvider<AuthUser>>().hasNotificationWidget())
        NotificationPopupWidget(),
      if (context.read<AuthProvider<AuthUser>>().hasNotificationWidget())
        const SizedBox(
          width: kDefaultPadding / 2,
        ),
      const DrawerLanguageButton(),
      const SizedBox(
        width: kDefaultPadding / 2,
      ),
      const ProfilePicturePopupMenu(),
      const SizedBox(
        width: kDefaultPadding / 2,
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          context.read<DrawerMenuControllerProvider>().change(
              context,
              SettingPageNew(),
              // SettingAndProfileWeb(),
              DrawerMenuControllerProviderAction.custom_widget);
        },
      )
    ];
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
      return getTabbarSliver(_tabListFirstPane!, _tabControllerFirstPane!);
    } else {
      return getTabbarSliver(_tabListSecondPane!, _tabControllerSecondPane!);
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
          child: getCustomScrollView(firstPane, tab, appBar, list),
        );
      } else {
        debugPrint(
            "BasePage IsPanel  isDesktopOrWebPlatform flassse isSliver ${isPanesIsSliver(firstPane)} body $body");
        return getCustomScrollView(firstPane, tab, appBar, list);
      }
    }
    debugPrint(
        "BasePage IsPanel isSliver=> ${isPanesIsSliver(firstPane, tab: tab)} body $body");
    return body;
  }

  Widget getCustomScrollView(bool firstPane, TabControllerHelper? tab,
      Widget? appBar, List<Widget> list) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: const AlwaysScrollableScrollPhysics(),
        ),
        controller: getScrollController(firstPane, tab: tab),
        slivers: [
          if (appBar != null) getSliverAppBar(appBar),
          if (_hasTabBarList(firstPane: firstPane))
            checkTogetTabbarSliver(firstPane),
          ...list
        ],
      ),
    );
  }

  ///setting appbar but when is sliver then we added to CustomScrollView Sliver
  Widget? _setSubAppBar(widget, bool firstPane, {TabControllerHelper? tab}) {
    Widget? appBarBody = firstPane
        ? getFirstPaneAppbarTitle(tab: tab)
        : getSecondPaneAppbarTitle(tab: tab);

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
        padding: setPaneBodyPadding(firstPane, tab: tab)
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
    if (_tabList == null) {
      _initBaseTab();
    }
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

    super.initState();
  }

  void _initBaseTab() {
    _tabList = initTabBarList();

    /// Here you can have your context and do what ever you want
    if (_hasTabBarList()) {
      _tabBaseController = TabController(vsync: this, length: _tabList!.length);
      _tabBaseController!.addListener(_tabControllerChangeListener);
    }
  }

  @override
  void dispose() {
    _connectionListener.dispose();
    if (_hasTabBarList()) {
      _tabBaseController!.removeListener(_tabControllerChangeListener);
      _tabBaseController!.dispose();
    }
    if (_hasTabBarList(firstPane: true)) {
      _tabControllerFirstPane!
          .removeListener(_tabControllerChangeListenerFirstPane);
      _tabControllerFirstPane!.dispose();
    }
    if (_hasTabBarList(firstPane: false)) {
      _tabControllerSecondPane!
          .removeListener(_tabControllerChangeListenerSecondPane);
      _tabControllerSecondPane!.dispose();
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
    _initBaseTab();
    return ScreenHelperSliver(
        requireAutoPadding: setMainPageSuggestionPadding(),
        onChangeLayout: (w, h, c) {
          debugPrint("ScreenHelperSliver build width:$w");
          reset();
          _width = w;
          _height = h;
          _currentScreenSize = c;
          if (canBuildDrawer()) {
            _drawerWidget = _generateCustomDrawer() ??
                DrawerLargeScreens(
                  size: _currentScreenSize,
                );
          }
        },
        mobile: (w, h) {
          return _getMainWidget();
        },
        smallTablet: (w, h) {
          return _getMainWidget();
        },
        largeTablet: (w, h) {
          return _getMainWidget();
        },
        desktop: (w, h) {
          return _getMainWidget();
        });
  }

  Widget getWidgetFromListToDetailsSecoundPaneHelper(
      {TabControllerHelper? tab,
      ListToDetailsSecoundPaneHelper? selectedItem}) {
    if (selectedItem == null) {
      return const Text("NONE ");
    }
    int iD = selectedItem.viewAbstract?.iD ?? -1;
    String tableName = selectedItem.viewAbstract?.getTableNameApi() ?? "";
    debugPrint(
        "ListToDetailsSecoundPane is _isInitialization $_isInitialization");
    Widget currentWidget;
    if (!_isInitialization) {
      debugPrint("ListToDetailsSecoundPane is initial call addAction");
      if (this is BasePageActionOnToolbarMixin) {
        (this as BasePageActionOnToolbarMixin)
            .addAction(selectedItem, notifyListener: false);
      }
    } else {
      _isInitialization = false;
    }
    switch (selectedItem.action) {
      case ServerActions.custom_widget:
        currentWidget = selectedItem.customWidget!;
        break;
      case ServerActions.add:
        currentWidget = BaseEditNewPage(
            viewAbstract: context
                .read<DrawerMenuControllerProvider>()
                .getObjectCastViewAbstract
                .getNewInstance());
        break;
      case ServerActions.edit:
        currentWidget = BaseEditNewPage(
          viewAbstract: selectedItem.viewAbstract!,
        );
        break;
      case ServerActions.view:
        currentWidget = BaseViewNewPage(
          // actionOnToolbarItem: getOnActionAdd,
          // key: widget.key,
          viewAbstract: selectedItem.viewAbstract!,
        );
        break;
      case ServerActions.print:
        currentWidget = PdfPageNew(
          iD: iD,
          tableName: tableName,
          invoiceObj: selectedItem.viewAbstract! as PrintableMaster,
        );
        break;
      case ServerActions.delete_action:
      case ServerActions.call:
      case ServerActions.file:
      case ServerActions.list_reduce_size:
      case ServerActions.search:
      case ServerActions.search_by_field:
      case ServerActions.search_viewabstract_by_field:
      case ServerActions.notification:
      case ServerActions.file_export:
      case ServerActions.file_import:
      case ServerActions.list:
        currentWidget = Container();
    }
    ViewAbstract? secoundPaneViewAbstract = selectedItem.viewAbstract;
    if (secoundPaneViewAbstract != null && tab?.widget != null) {
      return tab!.widget!;
    }
    // if (selectedItem.subObject != null) {
    //   if (this is BasePageWithThirdPaneMixin)
    //     (this as BasePageWithThirdPaneMixin).setThirdPane(currentWidget);
    // }
    return currentWidget;
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
      _tabListFirstPane = initTabBarList(firstPane: firstPane, tab: tab);
      if (_hasTabBarList(firstPane: firstPane)) {
        _tabControllerFirstPane =
            TabController(vsync: this, length: _tabListFirstPane!.length);
        _tabControllerFirstPane!
            .addListener(_tabControllerChangeListenerFirstPane);
      }
    } else {
      _tabListSecondPane = initTabBarList(firstPane: firstPane, tab: tab);
      if (_hasTabBarList(firstPane: firstPane)) {
        _tabControllerSecondPane =
            TabController(vsync: this, length: _tabListSecondPane!.length);

        _tabControllerSecondPane!
            .addListener(_tabControllerChangeListenerSecondPane);
      }
    }
  }

  Widget getTowPanes({TabControllerHelper? tab}) {
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
            children: _getTabBarList(firstPane: true)!
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
            children: _getTabBarList(firstPane: false)!
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

    if (_hasHorizontalDividerWhenTowPanes()) {
      _firstWidget = _getBorderDecoration(_firstWidget!);
    }

    return getPaneExt();
  }

  TowPaneExt getPaneExt() {
    return TowPaneExt(
      startPane: _firstWidget!,
      endPane: _secondWidget,
      customPaneProportion: reverseCustomPane()
          ? 1 - getCustomPaneProportion()
          : getCustomPaneProportion(),
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
    //TODO
    return null;
  }

  Widget? generatePaneBottomSheet(bool firstPane, {TabControllerHelper? tab}) {
    //TODO
    return null;
  }

  SizedBox? getEndDrawer() {
    Widget? customEnd = getCustomEndDrawer();
    bool isLarge = isLargeScreenFromScreenSize(getCurrentScreenSize());
    double width = isLarge ? MediaQuery.of(context).size.width * .4 : 500;
    return SizedBox(
        width: width, child: Card(child: customEnd ?? WebShoppingCartDrawer()));
  }

  Map<String, List<DrawerMenuItem>>? getCustomDrawer() {
    return null;
  }

  Widget? _generateCustomDrawer() {
    Map<String, List<DrawerMenuItem>>? drawer = getCustomDrawer();
    return drawer == null
        ? null
        : DrawerLargeScreens(
            customItems: drawer,
            size: findCurrentScreenSize(context),
          );
  }

  Widget? getCustomEndDrawer() {
    return null;
  }

  bool canBuildDrawer() {
    //this overrides if small screen then set the default drawer
    if (!isLargeScreenFromCurrentScreenSize(context)) {
      return true;
    }
    return getCustomDrawer() != null || buildDrawer;
  }

  // bool _canWrapDrawerOnLargeScreen() {
  //   return wrapDrawerOnLargeScreen() &&
  //       isLargeScreenFromCurrentScreenSize(context);
  // }

  // bool wrapDrawerOnLargeScreen() {
  //   return false;
  // }

  Widget _getMainWidget() {
    bool isLarge = isDesktop(context, maxWidth: getWidth) ||
        isTablet(context, maxWidth: getWidth);
    bool isCustomDrawer = getCustomDrawer() != null;
    Widget body = Scaffold(
        bottomNavigationBar: buildDrawer ? null : generateBaseBottomSheet(),
        endDrawer: getEndDrawer(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: getBaseFloatingActionButton(),
        key: _drawerMenuControllerProvider.getStartDrawableKey,
        drawer: canBuildDrawer() ? _drawerWidget : null,
        appBar: generateToolbar(),
        body: (isCustomDrawer)
            ? Selector<DrawerMenuControllerProvider, DrawerMenuItem?>(
                builder: (__, v, ___) {
                  lastDrawerItemSelected = v;
                  return _getBody();
                },
                selector: (p0, p1) => p1.getLastDrawerMenuItemClicked,
              )
            : _getBody());

    if ((isLarge && buildDrawer) || (isLarge && isCustomDrawer)) {
      body = Row(children: [_drawerWidget!, Expanded(child: body)]);
    }
    return body;
  }

  Widget getBodyIfHasTabBarList(bool isLarge) {
    Widget currentWidget;
    currentWidget = TabBarView(
        controller: _tabBaseController,
        children: _getTabBarList()!.map((e) => getTowPanes(tab: e)).toList());
    Widget child = getSelectorBodyIsLarge(isLarge, currentWidget);
    currentWidget = child;
    return currentWidget;
  }

  Widget _getBody() {
    Widget currentWidget;
    bool isLarge = isDesktop(context, maxWidth: getWidth) ||
        isTablet(context, maxWidth: getWidth);
    bool isCustomDrawer = getCustomDrawer() != null;

    if (_hasTabBarList()) {
      currentWidget = getBodyIfHasTabBarList(isLarge);
    } else {
      currentWidget = getTowPanes();
    }
    if (setMainPageSuggestionPadding()) {
      currentWidget = Padding(
        padding: getSuggestionPadding(_width),
        child: currentWidget,
      );
    }
    // if (isCustomDrawer) {
    //   currentWidget = Selector<DrawerMenuControllerProvider, DrawerMenuItem?>(
    //     builder: (__, v, ___) {
    //       lastDrawerItemSelected = v;
    //       return currentWidget;
    //     },
    //     selector: (p0, p1) => p1.getLastDrawerMenuItemClicked,
    //   );
    // }

    return currentWidget;
  }

  Widget getSelectorBodyIsLarge(bool isLarge, Widget currentWidget) {
    if (!buildDrawer || !isLarge) {
      return currentWidget;
    }
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        debugPrint("drawer selector $isOpen");
        return AnimatedContainer(
            key: UniqueKey(),
            height: _height,
            width: (_width! -
                    (isOpen ? kDrawerOpenWidth : kDefaultClosedDrawer)
                        .toNonNullable()) -
                0,
            duration: const Duration(milliseconds: 100),
            child: currentWidget);
      },
      selector: (p0, p1) => p1.getSideMenuIsOpen,
    );
  }

  void _tabControllerChangeListener() {
    currentBaseTabIndex = _tabBaseController!.index;
    debugPrint("_tabController $currentBaseTabIndex");
  }

  void _tabControllerChangeListenerFirstPane() {
    currentPaneIndexFirstPane = _tabControllerFirstPane!.index;
    debugPrint("_tabController $currentBaseTabIndex");
  }

  void _tabControllerChangeListenerSecondPane() {
    currentPaneIndexSecondPane = _tabControllerSecondPane!.index;
    debugPrint("_tabControllerChangeListenerSecondPane $currentBaseTabIndex");
  }

  void changeTabIndex(int index) {
    debugPrint("_tabController $index");
    if (!_hasTabBarList()) return;
    debugPrint("_tabController $index");
    currentBaseTabIndex = index;
    _tabBaseController!.index = index;
  }

  void changeTabIndexFirstPane(int index) {
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    if (!_hasTabBarList(firstPane: true)) return;
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    currentPaneIndexFirstPane = index;
    _tabControllerFirstPane!.index = index;
  }

  void changeTabIndexSecondPane(int index) {
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    if (!_hasTabBarList(firstPane: false)) return;
    debugPrint("_tabControllerChangeListenerSecondPane $index");
    currentPaneIndexSecondPane = index;
    _tabControllerSecondPane!.index = index;
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
    if (_hasTabBarList()) {
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
    if (_hasTabBarList()) {
      return findExtrasViaTypeList(
          _getTabBarList(), (e) => e.extras.runtimeType == extra);
    } else {
      return extras;
    }
  }

  int findExtrasIndexFromTab(Type extra) {
    if (_hasTabBarList()) {
      return findExtrasIndexFromTabList(
          _getTabBarList(), (element) => element.extras.runtimeType == extra);
    } else {
      return -1;
    }
  }

  int findExtrasIndexFromTabSecoundPane(Type extra) {
    if (_hasTabBarList()) {
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
    if (_hasTabBarList()) {
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
      return (ex).canGetObjectWithoutApiChecker(getServerActions());
    }
    return ex.getBodyWithoutApi(getServerActions());
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
  Widget getTowPanes({TabControllerHelper? tab}) {
    debugPrint("getBody _getTowPanes TabController ${tab?.extras.runtimeType}");
    dynamic ex = getExtras(tab: tab);
    _isLoading = !getBodyWithoutApi(tab: tab);
    if (ex != null && !_isLoading) {
      return super.getTowPanes(tab: tab);
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
            return super.getTowPanes(tab: tab);
          } else {
            debugPrint("BasePageApi FutureBuilder !done");
            return getErrorWidget();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint("BasePageApi FutureBuilder waiting");
          _isLoading = true;
          return super.getTowPanes(tab: tab);
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
