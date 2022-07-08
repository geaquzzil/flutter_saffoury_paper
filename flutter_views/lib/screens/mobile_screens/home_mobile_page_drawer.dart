import 'package:flutter/material.dart';
import 'package:flutter_view_controller/app_theme.dart';
import 'package:flutter_view_controller/components/custom_drawer/home_drawer.dart';
import 'package:flutter_view_controller/screens/mobile_screens/main_mobile_page.dart';
import 'package:flutter_view_controller/screens/profile_page.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          // body: DrawerUserController(
          //   screenIndex: drawerIndex,
          //   drawerWidth: MediaQuery.of(context).size.width * 0.75,
          //   onDrawerCall: (DrawerIndex drawerIndexdata) {
          //     // changeIndex(drawerIndexdata);
          //     //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
          //   },
          //   screenView: screenView,
          //   //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          // ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = ProfileScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = ProfileScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = ProfileScreen();
          });
          break;
        default:
          break;
      }
    }
  }
}
