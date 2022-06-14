import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_view_controller/app_theme.dart';
import 'package:flutter_view_controller/components/app_bar.dart';
import 'package:flutter_view_controller/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:flutter_view_controller/components/cart_button.dart';
import 'package:flutter_view_controller/components/title_text.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/light_color.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/screens/mobile_screens/main_mobile_page.dart';
import 'package:flutter_view_controller/screens/profile_page.dart';
import 'package:flutter_view_controller/screens/shopping_cart_page.dart';
import 'package:provider/provider.dart';
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
  Widget getView(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        // PostsPage(viewAbstract: context.read<ViewAbstractProvider>().getObject),
        MyHomePage(),
        ProfileScreen(),
        ProfileScreen()
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     drawer: ViewHelper.getDrawer(context, widget.drawerItems),
  //     appBar: AppBar(title: Text("TEST")),
  //     body: _buildTextAndSearchBody(),
  //     bottomNavigationBar: getBottomNavigationBar(),
  //   );

  //   return AdvancedDrawer(
  //       backdropColor: Colors.blueGrey,
  //       controller: _advancedDrawerController,
  //       animationCurve: Curves.easeInOut,
  //       animationDuration: const Duration(milliseconds: 300),
  //       animateChildDecoration: true,
  //       rtlOpening: false,
  //       // openScale: 1.0,
  //       disabledGestures: false,
  //       drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
  //       childDecoration: const BoxDecoration(
  //         // NOTICE: Uncomment if you want to add shadow behind the page.
  //         // Keep in mind that it may cause animation jerks.
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //             color: Colors.black12,
  //             blurRadius: 0.0,
  //           ),
  //         ],
  //         borderRadius: BorderRadius.all(Radius.circular(16)),
  //       ),
  //       child: Scaffold(
  //         appBar: buildAppBar(
  //             actions: getBaseActions(context),
  //             leading: IconButton(
  //               onPressed: _handleMenuButtonPressed,
  //               icon: ValueListenableBuilder<AdvancedDrawerValue>(
  //                 valueListenable: _advancedDrawerController,
  //                 builder: (_, value, __) {
  //                   return AnimatedSwitcher(
  //                     duration: const Duration(milliseconds: 250),
  //                     child: Icon(
  //                       value.visible ? Icons.clear : Icons.menu,
  //                       key: ValueKey<bool>(value.visible),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             )),
  //         body: _buildTextAndSearchBody(),
  //         bottomNavigationBar: BottomNavigationBar(
  //             currentIndex: _currentIndex,
  //             onTap: (int index) => setState(() => _currentIndex = index),
  //             items: const [
  //               BottomNavigationBarItem(
  //                   icon: Icon(Icons.home), label: ('Home')),
  //               BottomNavigationBarItem(
  //                   icon: Icon(Icons.search), label: ('Search')),
  //               BottomNavigationBarItem(
  //                   icon: Icon(Icons.person), label: ('Profile')),
  //             ]),
  //       ));

  //   // return

  //   // Scaffold(

  //   //     appBar: buildAppBar(
  //   //         actions: getBaseActions(context),
  //   //         leading: IconButton(
  //   //           onPressed: _handleMenuButtonPressed,
  //   //           icon: ValueListenableBuilder<AdvancedDrawerValue>(
  //   //             valueListenable: _advancedDrawerController,
  //   //             builder: (_, value, __) {
  //   //               return AnimatedSwitcher(
  //   //                 duration: const Duration(milliseconds: 250),
  //   //                 child: Icon(
  //   //                   value.visible ? Icons.clear : Icons.menu,
  //   //                   key: ValueKey<bool>(value.visible),
  //   //                 ),
  //   //               );
  //   //             },
  //   //           ),
  //   //         )),
  //   //     body: Scaffold(
  //   //         drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
  //   //       appBar: buildAppBar(
  //   //           actions: getBaseActions(context),
  //   //           leading: IconButton(
  //   //             onPressed: _handleMenuButtonPressed,
  //   //             icon: ValueListenableBuilder<AdvancedDrawerValue>(
  //   //               valueListenable: _advancedDrawerController,
  //   //               builder: (_, value, __) {
  //   //                 return AnimatedSwitcher(
  //   //                   duration: const Duration(milliseconds: 250),
  //   //                   child: Icon(
  //   //                     value.visible ? Icons.clear : Icons.menu,
  //   //                     key: ValueKey<bool>(value.visible),
  //   //                   ),
  //   //                 );
  //   //               },
  //   //             ),
  //   //           )),
  //   //       body: const NavigationPage(),
  //   //     ));
  //   // return AdvancedDrawer(
  //   //     backdropColor: Colors.blueGrey,
  //   //     controller: _advancedDrawerController,
  //   //     animationCurve: Curves.easeInOut,
  //   //     animationDuration: const Duration(milliseconds: 300),
  //   //     animateChildDecoration: true,
  //   //     rtlOpening: false,
  //   //     // openScale: 1.0,
  //   //     disabledGestures: false,
  //   //     childDecoration: const BoxDecoration(
  //   //       // NOTICE: Uncomment if you want to add shadow behind the page.
  //   //       // Keep in mind that it may cause animation jerks.
  //   //       // boxShadow: <BoxShadow>[
  //   //       //   BoxShadow(
  //   //       //     color: Colors.black12,
  //   //       //     blurRadius: 0.0,
  //   //       //   ),
  //   //       // ],
  //   //       borderRadius: BorderRadius.all(Radius.circular(16)),
  //   //     ),
  //   //     drawer: ViewHelper.getDrawerSafeArea(context, widget.drawerItems),
  //   //     child: const NavigationPage()

  //   //     );
  // }

  BottomNavigationBar getBottomNavigationBar() {
    AppLocalizations.of(context)!.appTitle;
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          getBottomNavigationBarItem(Icons.home_outlined, Icons.home,
              AppLocalizations.of(context)!.home),
          getBottomNavigationBarItem(Icons.search_outlined, Icons.search,
              AppLocalizations.of(context)!.search),
          getBottomNavigationBarItem(Icons.account_circle_outlined,
              Icons.account_circle, AppLocalizations.of(context)!.profile)
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

  bool isHomePageSelected = true;
  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RotatedBox(
            quarterTurns: 4,
            child: _icon(Icons.sort, color: Colors.black54),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10),
                ],
              ),
              child: _icon(Icons.sort, color: Colors.black54),
            ),
          ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: isHomePageSelected ? 'Our' : 'Shopping',
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: isHomePageSelected ? 'Products' : 'Cart',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            !isHomePageSelected
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.delete_outline,
                      color: LightColor.orange,
                    ),
                  ).ripple(() {},
                    borderRadius: BorderRadius.all(Radius.circular(13)))
                : SizedBox()
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        isHomePageSelected = true;
      });
    } else {
      setState(() {
        isHomePageSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNavigationBar(),
      drawer: ViewHelper.getDrawer(context, widget.drawerItems),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _appBar(),
                    _title(),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: getView(context)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
