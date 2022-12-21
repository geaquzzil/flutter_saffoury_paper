import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_small_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import 'components/drawers/drawer_large_screen.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      drawer: SafeArea(child: DrawerLargeScreens()),
      endDrawer: const BaseHomeCartPage(),
      body: const SafeArea(child: BaseHomeScreenLayout()),
    );
  }
}
