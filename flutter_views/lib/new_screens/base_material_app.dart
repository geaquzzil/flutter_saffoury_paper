// ignore_for_file: use_build_context_synchronously

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/util.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BaseMaterialAppPage extends StatefulWidget {
  List<RouteBase>? addOnRoutes;
  BaseMaterialAppPage({super.key, this.addOnRoutes});

  @override
  State<BaseMaterialAppPage> createState() => _BaseMaterialAppPageState();
}

class _BaseMaterialAppPageState extends State<BaseMaterialAppPage> {
  late LangaugeProvider langaugeProvider;
  late AuthProvider authProvider;
  late RouteGenerator routeGenerator;
  // Fictitious brand color.
  final _brandBlue = const Color.fromARGB(0, 0, 204, 255);

  CustomColors lightCustomColors =
      const CustomColors(danger: Color(0xFFE53935));
  CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));

  @override
  void initState() {
    super.initState();
    langaugeProvider = Provider.of<LangaugeProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    routeGenerator = RouteGenerator(
        appService: authProvider,
        context: context,
        addonRoutes: authProvider.getGoRoutesAddOns(context));

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
  void dispose() {
    langaugeProvider.dispose();
    super.dispose();
  }

// Fictitious brand color.
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
          final screenWidth = MediaQuery.of(context).size.width;
          final scaleFactor =
              screenWidth / 360; // Adjust as needed based on your design

          final fontSize =
              14 * scaleFactor; // Base font size multiplied by scaling factor
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              ColorScheme lightColorScheme;
              ColorScheme darkColorScheme;

              if (lightDynamic != null && darkDynamic != null) {
                // On Android S+ devices, use the provided dynamic color scheme.
                // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
                lightColorScheme = lightDynamic.harmonized();
                // (Optional) Customize the scheme as desired. For example, one might
                // want to use a brand color to override the dynamic [ColorScheme.secondary].
                lightColorScheme = lightColorScheme;
                // (Optional) If applicable, harmonize custom colors.
                lightCustomColors =
                    lightCustomColors.harmonized(lightColorScheme);

                // Repeat for the dark color scheme.
                darkColorScheme = darkDynamic.harmonized();
                darkColorScheme = darkColorScheme;
                darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
              } else {
                // Otherwise, use fallback schemes.
                lightColorScheme = ColorScheme.fromSeed(
                  seedColor: _brandBlue,
                );
                darkColorScheme = ColorScheme.fromSeed(
                  seedColor: _brandBlue,
                  brightness: Brightness.dark,
                );
              }

              notifyLogoColor(context, lightDynamic, darkDynamic);
              return MaterialApp.router(
                // scrollBehavior: SizeConfig.isDesktop(context)
                //     ? const MaterialScrollBehavior().copyWith(
                //         dragDevices: {
                //           PointerDeviceKind.mouse,
                //           PointerDeviceKind.touch,
                //           PointerDeviceKind.stylus,
                //           PointerDeviceKind.unknown
                //         },rod
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
                  child: ClampingScrollWrapper.builder(
                    context,
                    MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        // boldText: true,
                        textScaler: MediaQuery.of(context)
                            .textScaler
                            .clamp(minScaleFactor: .5, maxScaleFactor: .9),
                      ),
                      child: widget!,
                    ),
                  ),

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
                routeInformationParser:
                    routeGenerator.router.routeInformationParser,
                routerDelegate: routeGenerator.router.routerDelegate,
                routeInformationProvider:
                    routeGenerator.router.routeInformationProvider,

                theme: ThemeData(
                  inputDecorationTheme:
                      Theme.of(context).inputDecorationTheme.copyWith(
                            isDense: !isDesktopPlatform(),
                            border: const OutlineInputBorder(

                                // borderSide: BorderSide(strokeAlign: ),
                                // borderSide: BorderSide.none,
                                // gapPadding: 0,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(kBorderRadius))),
                          ),
                  // textTheme: kIsWeb
                  //     ? GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
                  //         .apply()
                  //     : GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
                  //         .apply(fontSizeDelta: .9, fontSizeFactor: .5),
                  visualDensity: isDesktopPlatform()
                      ? VisualDensity.comfortable
                      : VisualDensity.compact,
                  // scaffoldBackgroundColor: lightDynamic?.background,
                  // shadowColor: lightDynamic?.shadow,
                  // cardColor: lightDynamic?.surfaceVariant,
                  colorScheme: lightColorScheme,
                  extensions: [lightCustomColors],
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
                  dividerColor: darkColorScheme.outlineVariant,
                  dividerTheme: DividerThemeData(
                    endIndent: 4,
                    indent: 4,
                    thickness: 1,
                    color: darkColorScheme.outlineVariant,
                  ),

                  highlightColor: darkColorScheme.onSurface.withOpacity(.2),
                  focusColor: darkColorScheme.secondaryContainer,
                  // bor: ,
                  canvasColor: darkColorScheme.surfaceContainer,
                  // floatingActionButtonTheme: FloatingActionButtonThemeData(highlightElevation: ),

                  textButtonTheme: TextButtonThemeData(
                      style: getButtonStyleIfIcon(darkColorScheme)),
                  iconButtonTheme: getIconDataTheme(darkColorScheme),
                  elevatedButtonTheme: getElevatedTheme(darkColorScheme),
                  menuTheme: MenuThemeData(
                      style: MenuStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.black))),
                  menuButtonTheme: MenuButtonThemeData(
                      style: ButtonStyle(
                          iconColor: WidgetStateProperty.all(Colors.orange))),
                  popupMenuTheme: Theme.of(context).popupMenuTheme.copyWith(
                        color: darkColorScheme.surfaceContainer,

                        // elevation: Theme.of(context).ele,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(kBorderRadius))),
                      ),
                  buttonTheme: const ButtonThemeData(),

                  dropdownMenuTheme: Theme.of(context)
                      .dropdownMenuTheme
                      .copyWith(
                        menuStyle: const MenuStyle(
                            visualDensity: VisualDensity.compact),
                        // menuStyle: Theme.of(context).menuTheme.style?.copyWith(
                        //     padding: ),
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        inputDecorationTheme: Theme.of(context)
                            .inputDecorationTheme
                            .copyWith(
                                filled: true,
                                // fillColor: darkDynamic?.onPrimary,
                                isDense: isDesktopPlatform(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                      ),

                  visualDensity: isDesktopPlatform()
                      ? const VisualDensity(horizontal: -4.0, vertical: -4.0)
                      : VisualDensity.compact,
                  listTileTheme: getListTileThemeData(context,
                      colorScheme: darkColorScheme),

                  //  ListTileThemeData(

                  //     // contentPadding: EdgeInsets.zero,
                  //     dense: isDesktopPlatform()),
                  checkboxTheme: const CheckboxThemeData(
                    // side: BorderSide.none,

                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // checkColor: WidgetStateProperty.all(
                    //     darkColorScheme.onPrimaryContainer),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(kBorderRadius))
                        // fillColor: WidgetStateProperty.all(Colors.amberAccent)

                        ),
                  ),

                  // fontFamily: GoogleFonts.roboto(height: 1.2).fontFamily,
                  inputDecorationTheme:
                      getMainTheme(context, colorScheme: darkColorScheme),
                  textTheme: kIsWeb
                      ? GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
                      : null,

                  // scaffoldBackgroundColor:
                  //     Theme.of(context).colorScheme.background,
                  // scaffoldBackgroundColor: darkDynamic?.background,
                  // shadowColor: darkDynamic?.shadow,
                  // cardColor: darkDynamic?.surfaceVariant,
                  colorScheme: darkColorScheme,
                  extensions: [darkCustomColors],

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

  IconButtonThemeData getIconDataTheme(ColorScheme colorSheme) {
    return IconButtonThemeData(style: getButtonStyleIfIcon(colorSheme));
  }

  ElevatedButtonThemeData getElevatedTheme(ColorScheme colorSheme) {
    return ElevatedButtonThemeData(style: getButtonStyleIfIcon(colorSheme));
  }

  ButtonStyle getButtonStyleIfIcon(ColorScheme colorSheme) {
    return ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      // surfaceTintColor:
      //     WidgetStateProperty.all(const Color.fromRGBO(0, 0, 0, 0)),
      shape: WidgetStateProperty.all(const CircleBorder()),
      //  side: ,
      // shape:  WidgetStateProperty.all(),
      iconSize: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return 19;
        }
        if (states.contains(WidgetState.hovered)) {
          return 20;
        }
        return null;
      }),

      textStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Theme.of(context).textTheme.bodySmall;
        }
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(context).textTheme.bodyMedium;
        }
        return null;
      }),
      iconColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorSheme.primaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return colorSheme.primary;
        }
        return null;
      }),
    );
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

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}
