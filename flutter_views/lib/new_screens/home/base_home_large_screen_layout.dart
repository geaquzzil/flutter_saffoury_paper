import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_stand_alone.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/dashboard/main_dashboard.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_stand_alone.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../models/view_abstract_non_list.dart';
import '../actions/view/base_home_details_view.dart';
import '../dashboard2/dashboard.dart';
import '../setting/setting_page.dart';

class BaseHomeLargeScreenLayout extends StatelessWidget {
  const BaseHomeLargeScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (SizeConfig.isMobile(context)) {}
    return Row(children: [
      if (SizeConfig.isTablet(context)) DrawerLargeScreens(),
      Expanded(
        child: Column(
          children: [getCurrentPage(context)],
        ),
      )
    ]);
  }

  Widget getCurrentPage(BuildContext context) {
    CurrentPage currentPage =
        context.watch<LargeScreenPageProvider>().getCurrentPage;

    ViewAbstract viewAbstract =
        context.watch<DrawerViewAbstractListProvider>().getObject;

    ViewAbstractStandAloneCustomView? viewAbstractStandAloneCustomView =
        context.watch<DrawerViewAbstractStandAloneProvider>().getObject;

    if (viewAbstract is DashableInterface) {
      return DashboardPage(
        dashboard: viewAbstract as DashableInterface,
      );
    }
    if (viewAbstractStandAloneCustomView is ViewAbstractStandAloneCustomView) {
      return MasterViewStandAlone(
          viewAbstract: viewAbstractStandAloneCustomView);
    }
    switch (currentPage) {
      case CurrentPage.settings:
        return const SettingPage();
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

  Widget getMainHomeList(BuildContext context, ViewAbstract viewAbstract) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(children: [
        Expanded(
            // It takes 5/6 part of the screen
            flex: size.width > 1340 ? 4 : 1,
            // flex: 4,
            child: const ListApiSearchableWidget()),

        VerticalDivider(),

        //  SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // const HeaderTitleOnListMain(),
        //       SearchWidgetApi(),
        //       SearchField(),

        //       SearchFilterableWidget(
        //         viewAbstract: viewAbstract,
        //       ),
        //       const ListApiWidget(),
        //     ],
        //   ),
        // )),
        // Expanded(
        //     // It takes 5/6 part of the screen
        //     flex: 5,
        //     child: Center(
        //       child: Text("This is a list"),
        //     )),
        if (SizeConfig.isDesktop(context))
          Expanded(
              flex: size.width > 1340 ? 10 : 2,
              child: const Center(
                child: BaseSharedDetailsView(),
              ))
      ]),
    );
  }
}
