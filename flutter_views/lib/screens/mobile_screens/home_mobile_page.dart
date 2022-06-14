import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_view_controller/components/app_bar.dart';
import 'package:flutter_view_controller/components/cart_button.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_page.dart';
import 'package:flutter_view_controller/screens/mobile_screens/bottom_navigation_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
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
  int _currentIndex = 0;
  String getTextLabel() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Profile';
      case 2:
        return 'Settings';
      default:
        return 'Home';
    }
  }

  _buildTextAndSearchBody() {
    return getView();
    // return ListView(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             getTextLabel(),
    //             style:
    //                 const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
    //           ),
    //           IconButton(
    //               icon: const Icon(Icons.search),
    //               color: Colors.black26,
    //               onPressed: () {}),
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16),
    //       child: getView(),
    //     )
    //   ],
    // );
  }

  Widget getView() {
    return PostsPage();
    // return IndexedStack(
    //   index: _currentIndex,
    //   children: [
    //     PostsPage(),
    //     //Text("TEST $_currentIndex"),
    //     Text("TEST $_currentIndex"),
    //     Text("TEST $_currentIndex")
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ViewHelper.getDrawer(context, widget.drawerItems),
      appBar: AppBar(title: Text("TEST")),
      body: _buildTextAndSearchBody(),
      bottomNavigationBar: getBottomNavigationBar(),
    );

    return AdvancedDrawer(
        backdropColor: Colors.blueGrey,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
        childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
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
          body: _buildTextAndSearchBody(),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) => setState(() => _currentIndex = index),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: ('Home')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: ('Search')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: ('Profile')),
              ]),
        ));

    // return

    // Scaffold(

    //     appBar: buildAppBar(
    //         actions: getBaseActions(context),
    //         leading: IconButton(
    //           onPressed: _handleMenuButtonPressed,
    //           icon: ValueListenableBuilder<AdvancedDrawerValue>(
    //             valueListenable: _advancedDrawerController,
    //             builder: (_, value, __) {
    //               return AnimatedSwitcher(
    //                 duration: const Duration(milliseconds: 250),
    //                 child: Icon(
    //                   value.visible ? Icons.clear : Icons.menu,
    //                   key: ValueKey<bool>(value.visible),
    //                 ),
    //               );
    //             },
    //           ),
    //         )),
    //     body: Scaffold(
    //         drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
    //       appBar: buildAppBar(
    //           actions: getBaseActions(context),
    //           leading: IconButton(
    //             onPressed: _handleMenuButtonPressed,
    //             icon: ValueListenableBuilder<AdvancedDrawerValue>(
    //               valueListenable: _advancedDrawerController,
    //               builder: (_, value, __) {
    //                 return AnimatedSwitcher(
    //                   duration: const Duration(milliseconds: 250),
    //                   child: Icon(
    //                     value.visible ? Icons.clear : Icons.menu,
    //                     key: ValueKey<bool>(value.visible),
    //                   ),
    //                 );
    //               },
    //             ),
    //           )),
    //       body: const NavigationPage(),
    //     ));
    // return AdvancedDrawer(
    //     backdropColor: Colors.blueGrey,
    //     controller: _advancedDrawerController,
    //     animationCurve: Curves.easeInOut,
    //     animationDuration: const Duration(milliseconds: 300),
    //     animateChildDecoration: true,
    //     rtlOpening: false,
    //     // openScale: 1.0,
    //     disabledGestures: false,
    //     childDecoration: const BoxDecoration(
    //       // NOTICE: Uncomment if you want to add shadow behind the page.
    //       // Keep in mind that it may cause animation jerks.
    //       // boxShadow: <BoxShadow>[
    //       //   BoxShadow(
    //       //     color: Colors.black12,
    //       //     blurRadius: 0.0,
    //       //   ),
    //       // ],
    //       borderRadius: BorderRadius.all(Radius.circular(16)),
    //     ),
    //     drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
    //     child: const NavigationPage()

    //     );
  }

  BottomNavigationBar getBottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          getBottomNavigationBarItem(Icons.home_outlined, Icons.home,
              AppLocalizations.of(context)?.home),
          getBottomNavigationBarItem(Icons.search_outlined, Icons.search,
              AppLocalizations.of(context)?.search),
          getBottomNavigationBarItem(Icons.account_circle_outlined,
              Icons.account_circle, AppLocalizations.of(context)?.profile),
        ]);
  }

  BottomNavigationBarItem getBottomNavigationBarItem(
          IconData icon, IconData activeIcon, String? label) =>
      BottomNavigationBarItem(
          icon: Icon(icon), activeIcon: Icon(activeIcon), label: label);

  List<Widget> getBaseActions(BuildContext context) {
    return [CartButton()];
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.toggleDrawer();
  }
}
