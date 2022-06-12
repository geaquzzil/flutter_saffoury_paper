import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/l10n/l10n.dart';
import 'package:flutter_view_controller/screens/action_screens/list_page.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_page.dart';

import '../app_theme.dart';
import '../models/view_abstract.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class BaseHomePage<T extends ViewAbstract> extends StatelessWidget {
  List<T> drawerItems;

  BaseHomePage({Key? key, required this.drawerItems}) : super(key: key);

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
    //   return MaterialApp(
    //     theme: ThemeData(

    //       colorSchemeSeed: kPrimaryColor, useMaterial3: true

    //     ),
    //     title: "Flutter Portfolio",
    //     debugShowCheckedModeBanner: false,
    //     themeMode: ThemeMode.system,
    //     darkTheme: Theme.of(context).copyWith(
    //       platform: TargetPlatform.android,
    //       scaffoldBackgroundColor: kBackgroundColor,
    //       primaryColor: kPrimaryColor,
    //       canvasColor: kBackgroundColor,
    //       textTheme: GoogleFonts.robotoTextTheme(),
    //     ),
    //     builder: (context, widget) => ResponsiveWrapper.builder(
    //       ClampingScrollWrapper.builder(context, widget),
    //       defaultScale: true,
    //       breakpoints: [
    //         const ResponsiveBreakpoint.resize(450, name: MOBILE),
    //         const ResponsiveBreakpoint.resize(800, name: TABLET),
    //         const ResponsiveBreakpoint.resize(1000, name: TABLET),
    //         const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
    //         const ResponsiveBreakpoint.resize(2460, name: "4K"),
    //       ],
    //       background: Container(
    //         color: kBackgroundColor,
    //       ),
    //     ),
    //     home: const HomeWebPage(),
    //   );
    // }
    // Widget widget = MaterialApp(
    //     supportedLocales: L10n.all,
    //     localizationsDelegates: const [
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalCupertinoLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate
    //     ],
    //     title: 'Flutter UI',
    //     debugShowCheckedModeBanner: false,
    //     restorationScopeId: 'root',
    //     theme: ThemeData(
    //       useMaterial3: true,
    //       primarySwatch: Colors.blue,
    //       textTheme: AppTheme.textTheme,
    //     ),
    //     home: const PostPage());

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListPage(),
    );
  }

  // LayoutBuilder getLayoutBuilder() {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return const PostPage();
  //       // if (kIsWeb) {
  //       //   return const HomeWebPage();
  //       // } else
  //       // if (SizeConfig.isMobile(context)) {

  //       // } else if (SizeConfig.isTablet(context)) {
  //       //   return HomeSmallTabletPage(drawerItems: widget.drawerItems);
  //       // } else {
  //       //   return HomeLargeTabletPage(drawerItems: widget.drawerItems);
  //       // }
  //     },
  //   );
  // }
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
