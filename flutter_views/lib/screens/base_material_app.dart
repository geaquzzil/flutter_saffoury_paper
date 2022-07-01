import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/app_theme.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/l10n.dart';
import 'package:flutter_view_controller/screens/base_shared_main_page.dart';
import 'package:flutter_view_controller/screens/mobile_screens/home_mobile_page.dart';

import '../models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseMaterialAppPage<T extends ViewAbstract> extends StatelessWidget {
  BaseMaterialAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness:
    //       !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
    //   systemNavigationBarColor: Colors.white,
    //   systemNavigationBarDividerColor: Colors.transparent,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));
    // if (kIsWeb) {
    // return MaterialApp(
    //   theme: ThemeData(colorSchemeSeed: kPrimaryColor, useMaterial3: true),
    //   title: "Flutter Portfolio",
    //   debugShowCheckedModeBanner: false,
    //   themeMode: ThemeMode.system,
    //   darkTheme: Theme.of(context).copyWith(
    //     platform: TargetPlatform.android,
    //     scaffoldBackgroundColor: kBackgroundColor,
    //     primaryColor: kPrimaryColor,
    //     canvasColor: kBackgroundColor,
    //     textTheme: GoogleFonts.robotoTextTheme(),
    //   ),
    //   builder: (context, widget) => ResponsiveWrapper.builder(
    //     ClampingScrollWrapper.builder(context, widget),
    //     defaultScale: true,
    //     breakpoints: [
    //       const ResponsiveBreakpoint.resize(450, name: MOBILE),
    //       const ResponsiveBreakpoint.resize(800, name: TABLET),
    //       const ResponsiveBreakpoint.resize(1000, name: TABLET),
    //       const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
    //       const ResponsiveBreakpoint.resize(2460, name: "4K"),
    //     ],
    //     background: Container(
    //       color: kBackgroundColor,
    //     ),
    //   ),
    //   home: const HomeWebPage(),
    // );
    // }
    Widget widget = MaterialApp(
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        title: 'Flutter UI',
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'root',
        theme: ThemeData(
          useMaterial3: true,
        ),
        // theme: ThemeData.dark().copyWith(
        //   scaffoldBackgroundColor: bgColor,
        //   // textTheme: GoogleFonts.(Theme.of(context).textTheme)
        //   //     .apply(bodyColor: Colors.white),
        //   canvasColor: secondaryColor,
        // ),
        home: BaseSharedMainPage());
    // home: ShoppingCartPage());
    // home: HomeMobilePage(drawerItems: drawerItems));
    //home: NavigationHomeScreen());
    return widget;

    // return HomeMobilePage(drawerItems: drawerItems);
    // return Scaffold(body: HomeMobilePage(drawerItems: drawerItems));
    // return Scaffold(body: getLayoutBuilder());
    // return NavigationPage();
    // return getLayoutBuilder();

    // PostsPage();
  }

  final int _selectedDestination = 0;
  void selectDestination(int index) {
    // setState(() {
    //   _selectedDestination = index;
    // });
  }
  Row getStandardDrawerView() {
    return Row(
      children: [
        Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Header',
                  style: AppTheme.h6Style,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Item 1'),
                selected: _selectedDestination == 0,
                onTap: () => selectDestination(0),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Item 2'),
                selected: _selectedDestination == 1,
                onTap: () => selectDestination(1),
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Item 3'),
                selected: _selectedDestination == 2,
                onTap: () => selectDestination(2),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Item A'),
                selected: _selectedDestination == 3,
                onTap: () => selectDestination(3),
              ),
            ],
          ),
        ),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("widget.title"),
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: HomeMobilePage(),
            ),

            // GridView.count(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 20,
            //   mainAxisSpacing: 20,
            //   padding: EdgeInsets.all(20),
            //   childAspectRatio: 3 / 2,
            //   children: [ HomeMobilePage(drawerItems: drawerItems),
            //     Image.asset('assets/nav-drawer-1.jpg'),
            //     Image.asset('assets/nav-drawer-2.jpg'),
            //     Image.asset('assets/nav-drawer-3.jpg'),
            //     Image.asset('assets/nav-drawer-4.jpg'),
            //   ],
            // ),
          ),
        ),
      ],
    );
  }

  LayoutBuilder getLayoutBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return HomeMobilePage();
        // if (kIsWeb) {
        //   return const HomeWebPage();
        // } else
        // if (SizeConfig.isMobile(context)) {

        // } else if (SizeConfig.isTablet(context)) {
        //   return HomeSmallTabletPage(drawerItems: widget.drawerItems);
        // } else {
        //   return HomeLargeTabletPage(drawerItems: widget.drawerItems);
        // }
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
