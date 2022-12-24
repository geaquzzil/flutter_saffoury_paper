import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/l10n/l10n.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/authentecation/base_authentication_screen.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_main_page.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_main_page.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/new_screens/sign_in.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../theming/text_field_theming.dart';
import 'home/base_home_main.dart';

class BaseMaterialAppPage extends StatefulWidget {
  const BaseMaterialAppPage({Key? key}) : super(key: key);

  @override
  State<BaseMaterialAppPage> createState() => _BaseMaterialAppPageState();
}

class _BaseMaterialAppPageState extends State<BaseMaterialAppPage> {
  late LangaugeProvider langaugeProvider;
  @override
  void initState() {
    super.initState();
    langaugeProvider = Provider.of<LangaugeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      langaugeProvider.addListener(() {
        debugPrint(
            "langaugeProvider changed  langaugeProvider= ${langaugeProvider.getLocale}");
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build_MaterialAppPage");
    // Get.put(DashboardController());
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

    Widget widget = ChangeNotifierProvider.value(
        value: langaugeProvider,
        child:
            Consumer<LangaugeProvider>(builder: (context, provider, listTile) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) => MaterialApp(
              scrollBehavior: SizeConfig.isDesktop(context)
                  ? const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.stylus,
                        PointerDeviceKind.unknown
                      },
                    )
                  : null,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: langaugeProvider.getLocale,
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
              onGenerateRoute: RouteGenerator.generateRoute,

              theme: ThemeData(
                scaffoldBackgroundColor: darkDynamic?.background,
                colorScheme: lightDynamic ?? defaultLightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                scaffoldBackgroundColor: darkDynamic?.background,
                colorScheme: darkDynamic ?? defaultDarkColorScheme,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system,
            ),
          );
        }));

    return widget;
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
