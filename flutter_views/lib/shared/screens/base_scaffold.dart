import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import '../../new_screens/cart/base_home_cart_screen.dart';

class BaseScaffold extends StatelessWidget {
  Widget body;
  bool automaticallyImplyLeading = false;
  AppBar? appBar;
  BaseScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      appBar: appBar,
      body: body,
    );
  }
}
