import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_large_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_small_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_small_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget_test_scrolling.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/search/search_page.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'components/drawers/drawer_large_screen.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNavigationBar(),
      // resizeToAvoidBottomInset: true,
      // appBar: AppBar(),
      key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      drawer: SafeArea(child: DrawerLargeScreens()),
      endDrawer: const BaseHomeCartPage(),
      body: SizeConfig.isMobile(context)
          ? SafeArea(
              child: IndexedStack(index: _currentIndex, children: [
                ListApiSearchableWidgetTestScrolling(),
                // SearchPage(),
                NotificationWidget()
                // ListApiSearchableWidgetTestScrolling(),
                // ListApiSearchableWidgetTestScrolling(),
              ]),
            )
          : const SafeArea(child: BaseHomeLargeScreenLayout()),
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
}
