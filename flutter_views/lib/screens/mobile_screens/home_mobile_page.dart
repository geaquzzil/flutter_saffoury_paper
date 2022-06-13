import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_view_controller/components/app_bar.dart';
import 'package:flutter_view_controller/screens/components/cart_button.dart';
import 'package:flutter_view_controller/screens/mobile_screens/bottom_navigation_page.dart';

import '../../models/view_abstract.dart';
import '../../view_generator_helper.dart';

class HomeMobilePage extends StatefulWidget {
  List<ViewAbstract> drawerItems;
  HomeMobilePage({Key? key, required this.drawerItems}) : super(key: key);

  @override
  State<HomeMobilePage> createState() => _HomeMobilePage();
}

class _HomeMobilePage extends State<HomeMobilePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    return   AdvancedDrawer(
        backdropColor: Colors.blueGrey,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 0.0,
          //   ),
          // ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
        child: Scaffold(
          appBar: buildAppBar(
              actions: getBaseActions(context),
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              )),
          body: const NavigationPage(),
        ));
  }

  List<Widget> getBaseActions(BuildContext context) {
    return [const CartButton()];
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.toggleDrawer();
  }
}
