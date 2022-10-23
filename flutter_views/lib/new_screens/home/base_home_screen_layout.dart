import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/search/search_api.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/dashboard/main_dashboard.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/header/header.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/screens/base_app_shared_header.dart';
import 'package:flutter_view_controller/screens/view/base_home_details_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../new_components/ext.dart';
import '../../new_components/search/search_filterable_widget.dart';
import '../dashboard/main_dashboard2.dart';
import '../dashboard2/dashboard.dart';
import '../setting/list_sticky_setting_page.dart';
import '../setting/setting_page.dart';
import 'components/header/header_title_on_list.dart';

class BaseHomeScreenLayout extends StatelessWidget {
  const BaseHomeScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (SizeConfig.isDesktop(context)) DrawerLargeScreens(),
      Expanded(
        child: Column(
          children: [
            // const HeaderMain(),
            // const HeaderTitleMain(),
            getCurrentPage(context)
          ],
        ),
      )
    ]);
  }

  Widget getCurrentPage(BuildContext context) {
    CurrentPage currentPage =
        context.watch<LargeScreenPageProvider>().getCurrentPage;

    ViewAbstract viewAbstract =
        context.watch<DrawerViewAbstractProvider>().getObject;

    if (viewAbstract is DashableInterface) {
      return DashboardPage(dashboard: viewAbstract as DashableInterface,);
    }
    switch (currentPage) {
      case CurrentPage.settings:
        return SettingPage();
      case CurrentPage.dashboard:
        return DashboardWidget(
          viewAbstract: viewAbstract,
        );
      case CurrentPage.cart:
        return const BaseHomeCartPage();
      case CurrentPage.list:
      default:
        return getMainHomeList(context, viewAbstract);
    }
  }

  Expanded getMainHomeList(BuildContext context, ViewAbstract viewAbstract) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(children: [
        Expanded(
            // It takes 5/6 part of the screen
            flex: size.width > 1340 ? 4 : 1,
            // flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const HeaderTitleOnListMain(),
                  SearchWidgetApi(),
                  SearchField(),

                  SearchFilterableWidget(
                    viewAbstract: viewAbstract,
                  ),
                  const ListApiWidget(),
                ],
              ),
            )),
        // Expanded(
        //     // It takes 5/6 part of the screen
        //     flex: 5,
        //     child: Center(
        //       child: Text("This is a list"),
        //     )),
        if (SizeConfig.isDesktop(context))
          Expanded(
              flex: size.width > 1340 ? 8 : 2,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: getShadowBoxDecoration(),
                  child: const Center(
                    child: BaseSharedDetailsView(),
                  )))
      ]),
    );
  }
}
