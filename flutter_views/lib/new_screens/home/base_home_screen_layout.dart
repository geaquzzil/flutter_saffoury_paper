import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/search/search_api.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/new_screens/home/components/header/header.dart';
import 'package:flutter_view_controller/new_screens/home/components/header/header_title.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_widget.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/screens/view/base_home_details_view.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class BaseHomeScreenLayout extends StatelessWidget {
  const BaseHomeScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (SizeConfig.isDesktop(context)) const DrawerLargeScreens(),
      Expanded(
        child: Column(
          children: [
            const HeaderMain(),
            const HeaderTitleMain(),
            getCurrentPage(context)
          ],
        ),
      )
    ]);
  }

  Widget getCurrentPage(BuildContext context) {
    CurrentPage currentPage =
        context.watch<LargeScreenPageProvider>().getCurrentPage;
    switch (currentPage) {
      case CurrentPage.cart:
        return const BaseHomeCartPage();
      case CurrentPage.list:
      default:
        return getMainHomeList(context);
    }
  }

  Expanded getMainHomeList(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(children: [
        // Expanded(
        //     // It takes 5/6 part of the screen
        //     flex: 5,
        //     child: ListApiWidget())
        Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: Center(
              child: Text("This is a list"),
            )),
        if (SizeConfig.isDesktop(context))
          Expanded(
              flex: size.width > 1340 ? 8 : 10,
              child: Container(
                  // margin: EdgeInsets.all(25),
                  // decoration: BoxDecoration(
                  //   // boxShadow: [
                  //   //   BoxShadow(
                  //   //     color: Colors.grey[100]!,
                  //   //     spreadRadius: 10,
                  //   //     blurRadius: 5,
                  //   //   )
                  //   // ],
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                  child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: BaseSharedDetailsView(),
                ),
              )))
      ]),
    );
  }
}
