import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_screen_layout.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawer/drawer_small_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

class BaseHomeMainPage extends StatefulWidget {
  const BaseHomeMainPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeMainPage> createState() => _BaseHomeMainPageState();
}

class _BaseHomeMainPageState extends State<BaseHomeMainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: const DrawerMobile(),
      body: const SafeArea(child: BaseHomeScreenLayout()),
    );
  }
}
