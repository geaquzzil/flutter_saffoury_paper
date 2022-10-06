import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/l10n.dart';
import 'package:flutter_view_controller/new_screens/authentecation/base_authentication_screen.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/mobile_screens/home_mobile_page.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_manager/window_manager.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'home/base_home_main.dart';

class BaseMaterialAppPage extends StatefulWidget {
  const BaseMaterialAppPage({Key? key}) : super(key: key);

  @override
  State<BaseMaterialAppPage> createState() => _BaseMaterialAppPageState();
}

class _BaseMaterialAppPageState extends State<BaseMaterialAppPage> {
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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.resize(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.resize(2460, name: "4K"),
        ],
        background: Container(
          color: kBackgroundColor,
        ),
      ),
      // title: AppLocalizations.of(context)!.appTitle,
      title: "SSSS",
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'root',
      initialRoute: '/',
      routes: {
        '/': (context) {
          Status authStatus = context.read<AuthProvider>().getStatus;
          if (authStatus == Status.Authenticated) {
            return const BaseHomeMainPage();
          } else {
            return const BaseAuthenticatingScreen();
          }
        },
        '/sign_in': (context) => const SignInPage()
      },
      // theme: ThemeData(
      //   useMaterial3: true,
      // ),
      // theme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: bgColor,
      //   // textTheme: GoogleFonts.(Theme.of(context).textTheme)
      //   //     .apply(bodyColor: Colors.white),
      //   canvasColor: secondaryColor,
      // ),
      // home: const BaseAuthenticatingScreen()
    );
    return widget;
  }

  LayoutBuilder getLayoutBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text("HomeMobilePage ");
        // return const HomeMobilePage();
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
