import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
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
  List<T> drawerItems;
  BaseSharedMainPage({Key? key, required this.drawerItems}) : super(key: key);

  @override
  State<BaseSharedMainPage> createState() => _BaseSharedMainPageState();
}

class _BaseSharedMainPageState extends State<BaseSharedMainPage> {
  Future<void> _init() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _init(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Something went wrong")],
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print(authProvider.getStatus.toString());
          switch (authProvider.getStatus) {
            case Status.Inititailazion:
            case Status.Unauthenticated:
            case Status.Authenticating:
              return Center(
                child: Lottie.network(
                    "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
              );
            case Status.Authenticated:
              return MainWidget(context);
            case Status.Faild:
              return Center(
                  child: Lottie.network(
                      "https://assets5.lottiefiles.com/private_files/lf30_fryjclcj.json"));
            default:
              return MainWidget(context);
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
            body: Center(
                child: Lottie.network(
                    "https://assets5.lottiefiles.com/private_files/lf30_fryjclcj.json")));
      },
    );
    // return Scaffold(
    //   body: NavigationDrawerWidget(drawerItems: widget.drawerItems),
    // );
  }

  Scaffold MainWidget(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: BaseSharedDrawer(drawerItems: widget.drawerItems),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (SizeConfig.isDesktop(context))
              NavigationDrawerWidget(drawerItems: widget.drawerItems),
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
            ListProviderWidget()
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
