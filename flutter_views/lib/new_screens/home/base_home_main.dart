import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_large_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_small_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/search/search_page.dart';
import 'package:flutter_view_controller/providers/actions/list_actions_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../actions/view/base_home_details_view.dart';
import 'components/drawers/drawer_large_screen.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  int _currentIndex = 0;
  bool lastStateIsSelectMood = false;
  @override
  Widget build(BuildContext context) {
    bool singleScreen = MediaQuery.of(context).hinge == null &&
        MediaQuery.of(context).size.width < 1000;
    var panePriority = TwoPanePriority.both;
    if (singleScreen) {
      panePriority = TwoPanePriority.start;
    }

    return TwoPane(
      startPane: Scaffold(
        bottomNavigationBar: getBottomNavigationBar(),
        // resizeToAvoidBottomInset: true,
        appBar: getAppBar(),
        key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
        drawer: SafeArea(child: DrawerLargeScreens()),
        endDrawer: const BaseHomeCartPage(),
        body: SizeConfig.isMobile(context)
            ? SafeArea(
                child: IndexedStack(index: _currentIndex, children: [
                  ListApiSearchableWidget(
                      key: context.read<ListActionsProvider>().getListStateKey),
                  // SearchPage(),
                  NotificationWidget()
                  // ListApiSearchableWidgetTestScrolling(),
                  // ListApiSearchableWidgetTestScrolling(),
                ]),
              )
            : SafeArea(child: ListApiSearchableWidget()),
      ),
      endPane: BaseSharedDetailsView(),
      paneProportion: SizeConfig.getPaneProportion(context),
      panePriority: panePriority,
    );
    return WillPopScope(
      onWillPop: () async {
        if (!SizeConfig.isMobile(context)) return Future.value(true);
        bool? isSelectMood = context
            .read<ListActionsProvider>()
            .getListStateKey
            .currentState
            ?.isSelectedMode;
        if (isSelectMood == null) {
          return Future.value(true);
        }
        if (isSelectMood) {
          exitSelectionMood(
              context.read<ListActionsProvider>().getListStateKey);
          return Future.value(false);
        }
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: getBottomNavigationBar(),
        // resizeToAvoidBottomInset: true,
        appBar: getAppBar(),
        key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
        drawer: SafeArea(child: DrawerLargeScreens()),
        endDrawer: const BaseHomeCartPage(),
        body: SizeConfig.isMobile(context)
            ? SafeArea(
                child: IndexedStack(index: _currentIndex, children: [
                  ListApiSearchableWidget(
                      key: context.read<ListActionsProvider>().getListStateKey),
                  // SearchPage(),
                  NotificationWidget()
                  // ListApiSearchableWidgetTestScrolling(),
                  // ListApiSearchableWidgetTestScrolling(),
                ]),
              )
            : const SafeArea(child: BaseHomeLargeScreenLayout()),
      ),
    );
  }

  Widget? getBottomNavigationBar() {
    if (!SizeConfig.isMobile(context)) return null;

    AppLocalizations.of(context)!.appTitle;
    return BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          getBottomNavigationBarItem(Icons.home_outlined, Icons.home,
              AppLocalizations.of(context)!.home),
          getBottomNavigationBarItem(Icons.search_outlined, Icons.search,
              AppLocalizations.of(context)!.search),
          getBottomNavigationBarItem(Icons.notifications, Icons.account_circle,
              AppLocalizations.of(context)!.notification)
        ]);
  }

  BottomNavigationBarItem getBottomNavigationBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      BottomNavigationBarItem(
          icon: Icon(icon), activeIcon: Icon(activeIcon), label: label);

  PreferredSizeWidget? getAppBar() {
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
