import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_components/scroll_to_hide_widget.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/home_camera_widget.dart';
import 'package:flutter_view_controller/new_screens/home/home_home_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/home/list_to_details_widget.dart';
import 'package:flutter_view_controller/new_screens/search/search_page.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/actions/list_scroll_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:tuple/tuple.dart';
import '../actions/view/base_home_details_view.dart';
import 'components/drawers/drawer_large_screen.dart';
import 'components/profile/profile_pic_popup_menu.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  bool lastStateIsSelectMood = false;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  Widget? drawerWidget;
  Widget? navigationRailWidget;
  @override
  void initState() {
    super.initState();
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerMenuControllerProvider.getStartDrawableKey,
      drawer: DrawerLargeScreens(),
      endDrawer: const BaseHomeCartPage(),
      bottomNavigationBar: getBottomNavigationBar(),
      appBar: getAppBar(),
      body: getMainBodyIndexedStack(context),
    );
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

  Widget shouldWrapNavigatorChild(BuildContext context, Widget child) {
    if (SizeConfig.isSoLargeScreen(context)) {
      drawerWidget ??= DrawerLargeScreens();
      return SafeArea(
          child: Row(
        children: [
          drawerWidget!,
          Expanded(child: child),
        ],
      ));
    } else if (SizeConfig.isLargeScreen(context)) {
      navigationRailWidget ??= getNavigationRail();

      return SafeArea(
          child: Row(
        children: [
          navigationRailWidget!,
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
          DrawerLargeScreens(),
          Expanded(child: ListApiSearchableWidget()),
        ],
      ));
    } else if (SizeConfig.isLargeScreen(context)) {
      return SafeArea(
          child: Row(
        children: [
          getNavigationRail(),
          Expanded(child: ListApiSearchableWidget()),
        ],
      ));
    }

    return SizeConfig.isLargeScreen(context)
        ? SafeArea(
            child: Row(
            children: [
              DrawerLargeScreens(),
              Expanded(child: ListApiSearchableWidget()),
            ],
          ))
        : SafeArea(
            child: getMainBodyIndexedStack(context),
          );
  }

  Widget getMainBodyIndexedStack(BuildContext context) {
    return Selector<DrawerMenuControllerProvider, int>(
      builder: (context, value, child) => IndexedStack(index: value, children: [
        shouldWrapNavigatorChild(context, HomeNavigationPage()),
        shouldWrapNavigatorChild(context, ListToDetailsPage()),
        shouldWrapNavigatorChild(context, HomeCameraNavigationWidget()),

        // SearchPage(),
        // NotificationWidget()
        // ListApiSearchableWidgetTestScrolling(),
        // ListApiSearchableWidgetTestScrolling(),
      ]),
      selector: (p0, p1) => p1.getNavigationIndex,
    );
  }

  Widget getNavigationRail() {
    return Selector<DrawerMenuControllerProvider, Tuple2<int, bool>>(
      builder: (context, value, child) {
        return NavigationRail(
          groupAlignment: 0,
          leading: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              drawerMenuControllerProvider.setNavigationRailIsOpen();
              // Add your onPressed code here!
            },
            child: const Icon(Icons.add),
          ),
          trailing: IconButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            icon: const Icon(Icons.more_horiz_rounded),
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
          // type: BottomNavigationBarType.fixed,
          selectedIndex: value,
          onDestinationSelected: (int index) =>
              drawerMenuControllerProvider.setNavigationIndex = index,
          destinations: getNavigationDesinations().cast()),
      selector: (p0, p1) => p1.getNavigationIndex,
    );
  }

  List getNavigationDesinations({bool isNavigationRail = false}) {
    return [
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
              Icons.account_circle, AppLocalizations.of(context)!.notification)
    ];
  }

  NavigationDestination getBottomNavigationBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      NavigationDestination(icon: Icon(icon), label: label ?? "");
  NavigationRailDestination getNavigationRailBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      NavigationRailDestination(icon: Icon(icon), label: Text(label ?? ""));
  PreferredSizeWidget? getAppBar() {
    return null;
    if (!SizeConfig.isMobile(context)) return null;

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
      actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.delete))],
    );
  }

  void exitSelectionMood(GlobalKey<ListApiMasterState> key) {
    key.currentState?.toggleSelectMood();
    key.currentState?.clearSelection();
    context.read<ListActionsProvider>().toggleSelectMood();
  }
}
