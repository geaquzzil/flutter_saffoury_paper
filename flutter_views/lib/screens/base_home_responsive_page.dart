import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/large_tablet_screens/home_large_tablet.dart';
import 'package:flutter_view_controller/screens/mobile_screens/home_mobile_page.dart';
import 'package:flutter_view_controller/screens/small_tablet_screens/home_small_tablet_page.dart';
import 'package:flutter_view_controller/screens/web/home.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../models/view_abstract.dart';

class ResponsivePage extends StatefulWidget {
  List<ViewAbstract> drawerItems;
  ResponsivePage({Key? key, required this.drawerItems}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResponsivePage();
}

class _ResponsivePage extends State<ResponsivePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return HomeMobilePage(drawerItems: widget.drawerItems);
        // if (kIsWeb) {
        //   return const HomeWebPage();
        // } else
        // if (SizeConfig.isMobile(context)) {

        // } else if (SizeConfig.isTablet(context)) {
        //   return HomeSmallTabletPage(drawerItems: widget.drawerItems);
        // } else {
        //   return HomeLargeTabletPage(drawerItems: widget.drawerItems);
        // }
      },
    );
  }
}
