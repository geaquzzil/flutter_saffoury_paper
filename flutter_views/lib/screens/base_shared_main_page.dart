import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/network_faild.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/base_shared_details_view.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer.dart';
import 'package:flutter_view_controller/screens/base_app_shared_header.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_new_2.dart';
import 'package:flutter_view_controller/screens/list_provider_screens/list_provider_widget.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BaseSharedMainPage<T extends ViewAbstract> extends StatefulWidget {
  BaseSharedMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BaseSharedMainPage> createState() => _BaseSharedMainPageState();
}

class _BaseSharedMainPageState extends State<BaseSharedMainPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    print(authProvider.getStatus.toString());
    switch (authProvider.getStatus) {
      case Status.Initialization:
        return getLoadingWidget();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Center(
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
        );
      case Status.Authenticated:
        return getFutureDrawerItemsBuilder(context, authProvider);
      case Status.Faild:
        return NetworkFaildWidget();
      default:
        return getFutureDrawerItemsBuilder(context, authProvider);
    }

    // return Scaffold(
    //   body: NavigationDrawerWidget(drawerItems: widget.drawerItems),
    // );
  }

  Widget getLoadingWidget() => Center(
      child: Lottie.network(
          "https://assets10.lottiefiles.com/packages/lf20_9sglud8f.json"));
  Widget getFutureDrawerItemsBuilder(
      BuildContext context, AuthProvider authProvider) {
    return FutureBuilder(
        future: authProvider.initDrawerItems(context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return getLoadingWidget();
            case ConnectionState.done:
              print("drawer itmes ${authProvider.getDrawerItems.toString()}");
              return getMainContainerWidget(context);
            default:
              if (snapshot.hasError) {
                return const NetworkFaildWidget();
              } else {
                return const NetworkFaildWidget();
              }
          }
        });
  }

  Widget getScreenDivider(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: double.infinity,
          child: Container(
            child: BaseSharedHeader(),
          ), //desktop header
        ),
        Expanded(
          child: Row(children: [
            if (SizeConfig.isDesktop(context)) NavigationDrawerWidget(),
            Expanded(
                // It takes 5/6 part of the screen
                flex: _size.width > 1340 ? 8 : 10,
                child: Center(
                  child: Text("left"),
                )),
            if (SizeConfig.isDesktop(context))
              Expanded(
                  flex: 5,
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50)),
                      ),
                      child: Center(
                        child: Text("Right"),
                      )))
          ]),
        )
      ],
    );
  }

  Widget getMainContainerWidget(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: BaseSharedDrawer(),
      body: SafeArea(child: getScreenDivider(context)),
    );
  }

  Scaffold MainWidget(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: BaseSharedDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (SizeConfig.isDesktop(context)) NavigationDrawerWidget(),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: getMainPage(),
            ),
            if (SizeConfig.isDesktop(context))
              Expanded(
                  flex: _size.width > 1340 ? 8 : 10,
                  child: BaseSharedDetailsView()),
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
            BaseAppSharedHeader(),
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
