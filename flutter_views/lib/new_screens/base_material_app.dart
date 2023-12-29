import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/util.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../theming/text_field_theming.dart';

class BaseMaterialAppPage extends StatefulWidget {
  List<RouteBase>? addOnRoutes;
  BaseMaterialAppPage({Key? key, this.addOnRoutes}) : super(key: key);

  @override
  State<BaseMaterialAppPage> createState() => _BaseMaterialAppPageState();
}

class _BaseMaterialAppPageState extends State<BaseMaterialAppPage> {
  late LangaugeProvider langaugeProvider;
  @override
  void initState() {
    super.initState();
    langaugeProvider = Provider.of<LangaugeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? savedLang = await Configurations.getValueString("ln");
      if (savedLang != null) {
        context.read<LangaugeProvider>().change(Locale(savedLang, ''));
      }
      langaugeProvider.addListener(() {
        debugPrint(
            "langaugeProvider changed  langaugeProvider= ${langaugeProvider.getLocale}");
        setState(() {});
      });
    });
    init();
  }

  void init() async {
    Utils.initVersionNumber();
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
            builder: (lightDynamic, darkDynamic) {
              notifyLogoColor(context, lightDynamic, darkDynamic);
              return MaterialApp.router(
                // scrollBehavior: SizeConfig.isDesktop(context)
                //     ? const MaterialScrollBehavior().copyWith(
                //         dragDevices: {
                //           PointerDeviceKind.mouse,
                //           PointerDeviceKind.touch,
                //           PointerDeviceKind.stylus,
                //           PointerDeviceKind.unknown
                //         },
                //       )
                //     : null,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: langaugeProvider.getLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  FormBuilderLocalizations.delegate,
                ],
                builder: (context, widget) => ResponsiveBreakpoints.builder(
                  child: ClampingScrollWrapper.builder(context, widget!),
                  // defaultScale: true,
                  breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                    const Breakpoint(
                        start: 1921, end: double.infinity, name: '4K'),
                  ],
                  //TODO background: Container(
                  //   color: kBackgroundColor,
                  // ),
                ),
                // title: AppLocalizations.of(context)!.appTitle,
                title: "SaffouryPaper",
                debugShowCheckedModeBanner: false,
                restorationScopeId: 'root',

                routeInformationParser: RouteGenerator.instance(
                        addonRoutes: this.widget.addOnRoutes)
                    .routeInformationParser,

                routerDelegate: RouteGenerator.instance(
                        addonRoutes: this.widget.addOnRoutes)
                    .routerDelegate,

                routeInformationProvider: RouteGenerator.instance(
                        addonRoutes: this.widget.addOnRoutes)
                    .routeInformationProvider,
                // routerDelegate: RouteGenerator.goRouter.routerDelegate,
                // routeInformationProvider:
                //     RouteGenerator.goRouter.routeInformationProvider,
                // routerConfig: RouteGenerator.instance(
                //     addonRoutes: this.widget.addOnRoutes),
                // initialRoute: '/',
                // onGenerateRoute: RouteGenerator.generateRoute,

                theme: ThemeData(
                  textTheme: kIsWeb
                      ? GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
                      : null,
                  visualDensity: SizeConfig.isDesktopOrWebPlatform(context)
                      ? VisualDensity.comfortable
                      : VisualDensity.compact,
                  // scaffoldBackgroundColor: lightDynamic?.background,
                  // shadowColor: lightDynamic?.shadow,
                  // cardColor: lightDynamic?.surfaceVariant,
                  colorScheme: lightDynamic ?? defaultLightColorScheme,
                  useMaterial3: true,
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CustomTransitionBuilder(),
                      TargetPlatform.iOS: CustomTransitionBuilder(),
                      TargetPlatform.macOS: CustomTransitionBuilder(),
                      TargetPlatform.windows: CustomTransitionBuilder(),
                      TargetPlatform.linux: CustomTransitionBuilder(),
                    },
                  ),
                ),
                darkTheme: ThemeData(
                  // fontFamily: GoogleFonts.roboto(height: 1.2).fontFamily,
                  textTheme: kIsWeb
                      ? GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
                      : null,

                  // scaffoldBackgroundColor:
                  //     Theme.of(context).colorScheme.background,
                  // scaffoldBackgroundColor: darkDynamic?.background,
                  // shadowColor: darkDynamic?.shadow,
                  // cardColor: darkDynamic?.surfaceVariant,
                  colorScheme: darkDynamic ?? defaultDarkColorScheme,
                  useMaterial3: true,
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android: CustomTransitionBuilder(),
                      TargetPlatform.iOS: CustomTransitionBuilder(),
                      TargetPlatform.macOS: CustomTransitionBuilder(),
                      TargetPlatform.windows: CustomTransitionBuilder(),
                      TargetPlatform.linux: CustomTransitionBuilder(),
                    },
                  ),
                ),
                themeMode: ThemeMode.system,
              );
            },
          );
        }));

    return widget;
  }

  void notifyLogoColor(
      BuildContext context, ColorScheme? lightScheme, ColorScheme? darkScheme) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (kIsWeb) {
        CompanyLogo.updateLogoColor(context, kPrimaryColor);
        return;
      }
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      CompanyLogo.updateLogoColor(
          context, isDarkMode ? darkScheme?.secondary : lightScheme?.secondary);
    });
  }
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final tween =
        Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));
    return ScaleTransition(
        scale: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child));
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
