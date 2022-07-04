import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
import 'package:provider/provider.dart';

class BaseHomePage extends StatefulWidget {
  BaseHomePage({Key? key}) : super(key: key);

  @override
  State<BaseHomePage> createState() => _BaseHomePageState();
}

class _BaseHomePageState extends State<BaseHomePage> {
  @override
  Widget build(BuildContext context) {
     Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: context.read<DrawerMenuController>().scaffoldKey,
      drawer: BaseSharedDrawer(),
      body: SafeArea(child: getScreenDivider(context)),
    );
  }
}
