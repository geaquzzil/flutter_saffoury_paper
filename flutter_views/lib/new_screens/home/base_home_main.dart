import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/setting_button.dart';
import 'package:flutter_view_controller/new_screens/home/home_home_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'components/drawers/drawer_large_screen.dart';
import 'components/profile/profile_pic_popup_menu.dart';
import 'home_notification_widget.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({super.key});

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  bool lastStateIsSelectMood = false;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  Widget? drawerWidget;
  Widget? navigationRailWidget;
  Widget? dashboardWidget;
  Widget? homeWidget;
  Widget? drawer;
  Widget? shopingWidget;
  late Widget customWidget;

  @override
  void initState() {
    super.initState();

    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    drawer = DrawerLargeScreens();
  }

  Widget getSliverPadding(
      BuildContext context, ViewAbstractStandAloneCustomViewApi viewAbstract,
      {double padd = 2}) {
    customWidget = MasterViewStandAlone(viewAbstract: viewAbstract);
    if (!viewAbstract.getCustomStandAloneWidgetIsPadding()) {
      return customWidget;
    }
    return LayoutBuilder(builder: (_, constraints) {
      double defualPadding =
          isMobile(context) ? kDefaultPadding * 2 : kDefaultPadding;
      double horizontalPadding = max(
          (constraints.maxWidth -
                  (isTablet(context) ? kTabletMaxWidth : kDesktopMaxWidth)) /
              padd,
          0);
      return Padding(
          padding: EdgeInsets.symmetric(
              vertical: defualPadding,
              horizontal: horizontalPadding > defualPadding
                  ? horizontalPadding
                  : defualPadding),
          child: customWidget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DrawerMenuControllerProvider,
        ViewAbstractStandAloneCustomViewApi?>(
      builder: (context, value, child) {
        ViewAbstract? viewAbstract2 = context
            .read<DrawerMenuControllerProvider>()
            .getObjectCastViewAbstract;
        bool isInitViewAbstractCustomView =
            viewAbstract2 is ViewAbstractStandAloneCustomViewApi;
        if (value != null || isInitViewAbstractCustomView) {
          // List<Widget>? fabs=value.();
          value ??= viewAbstract2 as ViewAbstractStandAloneCustomViewApi;
          return Scaffold(
              key: drawerMenuControllerProvider.getStartDrawableKey,
              drawer: drawer,
              endDrawer: const BaseHomeCartPage(),
              floatingActionButton:
                  value.getCustomFloatingActionWidget(context),
              body: shouldWrapNavigatorChild(
                  context, getSliverPadding(context, value),
                  isCustomWidget: true));
        } else {
          return Scaffold(
              key: drawerMenuControllerProvider.getStartDrawableKey,
              drawer: drawer,
              // drawerScrimColor: Colors.transparent,
              // backgroundColor: compexDrawerCanvasColor,
              endDrawer: const BaseHomeCartPage(),
              bottomNavigationBar: getBottomNavigationBar(),
              appBar: getAppBar(),
              body: getMainBodyIndexedStack(context));
        }
      },
      selector: (p0, p1) => p1.getObjectCastViewStandAlone,
    );
    // return SliverApiMaster();

    // return WillPopScope(
    //   onWillPop: () async {
    //     if (!SizeConfig.isMobile(context)) return Future.value(true);
    //     bool? isSelectMood = context
    //         .read<ListActionsProvider>()
    //         .getListStateKey
    //         .currentState
    //         ?.isSelectedMode;
    //     if (isSelectMood == null) {
    //       return Future.value(true);
    //     }
    //     if (isSelectMood) {
    //       exitSelectionMood(
    //           context.read<ListActionsProvider>().getListStateKey);
    //       return Future.value(false);
    //     }
    //     return Future.value(false);
    //   },
    //   child: Scaffold(
    //     bottomNavigationBar: getBottomNavigationBar(),
    //     // resizeToAvoidBottomInset: true,
    //     appBar: getAppBar(),
    //     key: drawerMenuControllerProvider.getStartDrawableKey,
    //     drawer: SafeArea(child: DrawerLargeScreens()),
    //     endDrawer: const BaseHomeCartPage(),
    //     body: SizeConfig.isMobile(context)
    //         ? SafeArea(
    //             child: IndexedStack(index: _currentIndex, children: [
    //               ListApiSearchableWidget(
    //                   key: context.read<ListActionsProvider>().getListStateKey),
    //               // SearchPage(),
    //               NotificationWidget()
    //               // ListApiSearchableWidgetTestScrolling(),
    //               // ListApiSearchableWidgetTestScrolling(),
    //             ]),
    //           )
    //         : const SafeArea(child: BaseHomeLargeScreenLayout()),
    //   ),
    // );
  }

  GestureDetector getFirstPane(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            debugPrint("BaseHomePage downSwipe");
            showBottomSheetExt(
              context: context,
              builder: (p0) {
                return QrCodeReader();
              },
            );
            // setState(() {
            //   cameraView = true;
            // });
            // Down Swipe
          } else if (details.delta.dy < -sensitivity) {
            debugPrint("BaseHomePage Up Swipe");
            // Up Swipe
            // setState(() {
            //   cameraView = false;
            // });
          }
        },
        child: Scaffold(
            bottomNavigationBar: getBottomNavigationBar(),
            resizeToAvoidBottomInset: false,
            // bottomSheet: SizeConfig.isMobile(context) ? QrCodeReader() : null,
            // resizeToAvoidBottomInset: true,
            appBar: getAppBar(),
            body: getFirstPaneBody(context)));
  }

  Widget shouldWrapNavigatorChild(BuildContext context, Widget child,
      {bool isCustomWidget = false}) {
    if (SizeConfig.isSoLargeScreen(context)) {
      drawerWidget ??= drawer;
      navigationRailWidget ??= isCustomWidget ? null : getNavigationRail();
      return SafeArea(
          child: Row(
        children: [
          drawerWidget!,
          if (!isCustomWidget) navigationRailWidget!,
          Expanded(child: child),
        ],
      ));
    } else if (SizeConfig.isLargeScreen(context)) {
      navigationRailWidget ??= getNavigationRail();

      return SafeArea(
          child: Row(
        children: [
          navigationRailWidget!,
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ));
    } else {
      return SafeArea(child: child);
    }
  }

  SafeArea getFirstPaneBody(BuildContext context) {
    if (SizeConfig.isSoLargeScreen(context)) {
      return SafeArea(
          child: Row(
        children: [
          drawer!,
          Expanded(child: ListApiSearchableWidget()),
        ],
      ));
    } else if (SizeConfig.isLargeScreen(context)) {
      navigationRailWidget ??= getNavigationRail();
      return SafeArea(
          child: Row(
        children: [
          navigationRailWidget!,
          Expanded(child: ListApiSearchableWidget()),
        ],
      ));
    }

    return SizeConfig.isLargeScreen(context)
        ? SafeArea(
            child: Row(
            children: [
              drawer!,
              Expanded(child: ListApiSearchableWidget()),
            ],
          ))
        : SafeArea(
            child: getMainBodyIndexedStack(context),
          );
  }

  Widget getSelectorViewAbstract(BuildContext context,
      {required Widget Function(
        ViewAbstract<dynamic>,
      ) builder}) {
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) => builder.call(value),
      selector: (p0, p1) => p1.getObjectCastViewAbstract,
    );
  }

  Widget getMainBodyIndexedStack(BuildContext context) {
    return Selector<DrawerMenuControllerProvider, int>(
      builder: (context, value, child) {
        dashboardWidget ??= BaseDashboard(
            title: "TEST",
            dashboard:
                context.read<AuthProvider<AuthUser>>().getDashableInterface());
        homeWidget ??= getSelectorViewAbstract(context,
            builder: (viewAbstract) => HomeNavigationPage(
                  viewAbstract: viewAbstract,
                ));
        // shopingWidget ??= const ListToDetailsPage(
        //   title: "sd",
        // );
        return IndexedStack(index: value, children: [
          shouldWrapNavigatorChild(context, dashboardWidget!),
          shouldWrapNavigatorChild(context, homeWidget!),
          shouldWrapNavigatorChild(context, shopingWidget!),
          shouldWrapNavigatorChild(context, HomeNotificationPage()),
          // shouldWrapNavigatorChild(context, HomeCameraNavigationWidget()),
          // shouldWrapNavigatorChild(context, HomeSettingPage()),

          // SearchPage(),
          // NotificationWidget()
          // ListApiSearchableWidgetTestScrolling(),
          // ListApiSearchableWidgetTestScrolling(),
        ]);
      },
      selector: (p0, p1) => p1.getNavigationIndex,
    );
  }

  Widget getNavigationRail() {
    bool isDesktopOrWeb = SizeConfig.isDesktopOrWebPlatform(context);
    return Stack(
      children: [
        Selector<DrawerMenuControllerProvider, Tuple2<int, bool>>(
          builder: (context, value, child) {
            return NavigationRail(
              groupAlignment: 0,
              leading: SizedBox(
                  height: 70,
                  width: 70,
                  child: DrawerHeaderLogo(isOpen: false)),
              // trailing: Align(
              //   alignment: Alignment.bottomCenter,
              //   child: IconButton(
              //     icon: Icon(Icons.menu),
              //     onPressed: () {},
              //   ),
              // ),
              extended: value.item2,
              elevation: 4,
              selectedIndex: value.item1,
              onDestinationSelected: (int index) =>
                  drawerMenuControllerProvider.setNavigationIndex = index,
              destinations:
                  getNavigationDesinations(isNavigationRail: true).cast(),
            );
          },
          selector: (p0, p1) =>
              Tuple2(p1.getNavigationIndex, p1.getNavigationRailIsOpen),
        ),
        if (!isDesktopOrWeb)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              // color: Colors.amber,
              height: 200,
              child: Column(children: [
                DrawerSettingButton(),
                SizedBox(
                  height: kDefaultPadding / 3,
                ),
                DrawerLanguageButton(),
                SizedBox(
                  height: kDefaultPadding / 3,
                ),
                ProfilePicturePopupMenu()
              ]),
            ),
          )
      ],
    );
    return Selector<DrawerMenuControllerProvider, Tuple2<int, bool>>(
      builder: (context, value, child) {
        return NavigationRail(
          groupAlignment: 0,
          leading: SizedBox(
              height: 70, width: 70, child: DrawerHeaderLogo(isOpen: false)),
          trailing: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
          extended: value.item2,
          elevation: 4,
          selectedIndex: value.item1,
          onDestinationSelected: (int index) =>
              drawerMenuControllerProvider.setNavigationIndex = index,
          destinations: getNavigationDesinations(isNavigationRail: true).cast(),
        );
      },
      selector: (p0, p1) =>
          Tuple2(p1.getNavigationIndex, p1.getNavigationRailIsOpen),
    );
  }

  Widget? getBottomNavigationBar() {
    if (SizeConfig.isLargeScreen(context)) return null;
    if (SizeConfig.isSoLargeScreen(context)) return null;

    AppLocalizations.of(context)!.appTitle;
    return Selector<DrawerMenuControllerProvider, int>(
      builder: (context, value, child) => NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          // type: BottomNavigationBarType.fixed,
          selectedIndex: value,
          onDestinationSelected: (int index) {
            drawerMenuControllerProvider.setNavigationIndex = index;
          },
          destinations: getNavigationDesinations().cast()),
      selector: (p0, p1) => p1.getNavigationIndex,
    );
  }

  List getNavigationDesinations({bool isNavigationRail = false}) {
    return [
      isNavigationRail
          ? getNavigationRailBarItem(Icons.dashboard, Icons.dashboard,
              AppLocalizations.of(context)!.dashboard_and_rep)
          : getBottomNavigationBarItem(Icons.dashboard, Icons.dashboard,
              AppLocalizations.of(context)!.dashboard_and_rep),
      isNavigationRail
          ? getNavigationRailBarItem(Icons.home_outlined, Icons.home,
              AppLocalizations.of(context)!.home)
          : getBottomNavigationBarItem(Icons.home_outlined, Icons.home,
              AppLocalizations.of(context)!.home),
      isNavigationRail
          ? getNavigationRailBarItem(Icons.shopping_bag,
              Icons.shopping_bag_outlined, AppLocalizations.of(context)!.search)
          : getBottomNavigationBarItem(
              Icons.shopping_bag,
              Icons.shopping_bag_outlined,
              AppLocalizations.of(context)!.search),
      isNavigationRail
          ? getNavigationRailBarItem(Icons.notifications, Icons.account_circle,
              AppLocalizations.of(context)!.notification)
          : getBottomNavigationBarItem(Icons.notifications,
              Icons.account_circle, AppLocalizations.of(context)!.notification),
    ];
  }

  NavigationDestination getBottomNavigationBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      NavigationDestination(icon: Icon(icon), label: label ?? "");
  NavigationRailDestination getNavigationRailBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      NavigationRailDestination(icon: Icon(icon), label: Text(label ?? ""));
  PreferredSizeWidget? getAppBar() {
    // return null;
    // if (!SizeConfig.isMobile(context)) return null;

    GlobalKey<ListApiMasterState> key =
        context.watch<ListActionsProvider>().getListStateKey;
    lastStateIsSelectMood = key.currentState?.isSelectedMode != null &&
        key.currentState!.isSelectedMode;
    if (key.currentState?.isSelectedMode == null) return null;
    if (!key.currentState!.isSelectedMode) return null;

    int? length = key.currentState?.getSelectedList.length;
    length ??= 0;
    return AppBar(
      title: Text(length == 0
          ? AppLocalizations.of(context)!.noItems
          : "${key.currentState?.getSelectedList.length} ${AppLocalizations.of(context)!.selectItems}"),
      automaticallyImplyLeading: false,
      leading: BackButton(onPressed: (() {
        exitSelectionMood(key);
      })),
      actions: [
        IconButton(onPressed: () => {}, icon: const Icon(Icons.delete))
      ],
    );
  }

  void exitSelectionMood(GlobalKey<ListApiMasterState> key) {
    key.currentState?.toggleSelectMood();
    key.currentState?.clearSelection();
    context.read<ListActionsProvider>().toggleSelectMood();
  }
}
