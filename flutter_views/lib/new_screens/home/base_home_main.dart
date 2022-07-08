import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawer/drawer_small_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      drawer: const DrawerMobile(),
      endDrawer: BaseHomeCartPage(),
      body: const SafeArea(child: BaseHomeScreenLayout()),
    );
  }

 
}
