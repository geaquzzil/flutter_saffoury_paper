import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer.dart';
import 'package:flutter_view_controller/screens/base_shared_header.dart';
import 'package:flutter_view_controller/screens/list_provider_screens/list_provider_widget.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class BaseSharedMainPage<T extends ViewAbstract> extends StatefulWidget {
  List<T> drawerItems;
  BaseSharedMainPage({Key? key, required this.drawerItems}) : super(key: key);

  @override
  State<BaseSharedMainPage> createState() => _BaseSharedMainPageState();
}

class _BaseSharedMainPageState extends State<BaseSharedMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: BaseSharedDrawer(drawerItems: widget.drawerItems),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (SizeConfig.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: BaseSharedDrawer(drawerItems: widget.drawerItems),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: getMainPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMainPage() {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            BaseSharedHeader(),
            SizedBox(height: defaultPadding),
            Center(child: Text("THIS IS A TEST")),
            // ListProviderWidget()
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 5,
            //       child: Column(
            //         children: [
            //           MyFiles(),
            //           SizedBox(height: defaultPadding),
            //           RecentFiles(),
            //           if (Responsive.isMobile(context))
            //             SizedBox(height: defaultPadding),
            //           if (Responsive.isMobile(context)) StarageDetails(),
            //         ],
            //       ),
            //     ),
            //     if (!Responsive.isMobile(context))
            //       SizedBox(width: defaultPadding),
            //     // On Mobile means if the screen is less than 850 we dont want to show it
            //     if (!Responsive.isMobile(context))
            //       Expanded(
            //         flex: 2,
            //         child: StarageDetails(),
            //       ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
