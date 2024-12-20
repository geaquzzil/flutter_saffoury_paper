import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/base_material_app.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

const kDefaultLargeScreenIconSize = 20.0;
const kDefaultSmallScreenIconSize = 25.0;

const kDefaultTextFieldLarge = 30;
const kDefaultTextFieldSmall = 56;

///TODO override [constraints] on TextField
///TODO override isLargeOrDesktop to [isDesktopPlatform]
InputDecorationTheme getMainTheme(BuildContext context,
    {ColorScheme? colorScheme}) {
  ThemeData theme = Theme.of(context);
  colorScheme ??= theme.colorScheme;
  bool isLargeOrDesktop = isLargeScreen(context);
  return theme.inputDecorationTheme.copyWith(
    isDense: isLargeOrDesktop,
    filled: isLargeOrDesktop,
    fillColor: colorScheme.surfaceContainerHighest,

    // constraints: isLargeOrDesktop
    //     ? BoxConstraints.tight(const Size.fromHeight(30))
    //     : BoxConstraints.tight(const Size.fromHeight(50)),
    // hoverColor: Colors.transparent,
    border: _getBorder(isLargeOrDesktop),
    // focusedBorder: _getBorder(isLargeOrDesktop),
    // enabledBorder: _getBorder(isLargeOrDesktop)
  );
}

ThemeData getThemeData(BuildContext context, bool isDark,
    ColorScheme colorScheme, CustomColors customColor) {
  return ThemeData(
      badgeTheme: getBadgeTheme(context, colorScheme),
      expansionTileTheme: getExpansionTileTheme(context, colorScheme),
      colorScheme: colorScheme,
      cardTheme: getCardTheme(context, colorScheme),
      visualDensity: isLargeScreen(context)
          ? const VisualDensity(horizontal: -4, vertical: -4)
          : VisualDensity.compact,
      dividerColor: colorScheme.outlineVariant,
      dividerTheme: DividerThemeData(
        endIndent: 4,
        indent: 4,
        thickness: 1,
        color: colorScheme.outlineVariant,
      ),
      highlightColor: colorScheme.onSurface.withOpacity(.2),
      focusColor: colorScheme.secondaryContainer,
      canvasColor: colorScheme.surfaceContainer,
      cardColor: colorScheme.surfaceContainerHighest,
      shadowColor: colorScheme.shadow,
      tabBarTheme: getTabBarTheme(context, colorScheme),

      // floatingActionButtonTheme: FloatingActionButtonThemeData(highlightElevation: ),
      // scaffoldBackgroundColor: lightDynamic?.background,
      // shadowColor: lightDynamic?.shadow,
      // cardColor: lightDynamic?.surfaceVariant,
      // scaffoldBackgroundColor: lightDynamic?.background,
      // shadowColor: lightDynamic?.shadow,
      // cardColor: lightDynamic?.surfaceVariant,
      // textTheme: kIsWeb
      //     ? GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
      //         .apply()
      //     : GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
      //         .apply(fontSizeDelta: .9, fontSizeFactor: .5),

      textButtonTheme: TextButtonThemeData(
          style: getButtonStyleIfIcon(context, colorScheme)),
      iconButtonTheme: getIconDataTheme(context, colorScheme),
      elevatedButtonTheme: getElevatedTheme(context, colorScheme),
      menuTheme: MenuThemeData(
          style: MenuStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black))),
      menuButtonTheme: MenuButtonThemeData(
          style:
              ButtonStyle(iconColor: WidgetStateProperty.all(Colors.orange))),
      popupMenuTheme: Theme.of(context).popupMenuTheme.copyWith(
            color: colorScheme.surfaceContainer,

            // surfaceTintColor: colorScheme.surfaceTint,

            // elevation: Theme.of(context).ele,
            elevation: 10,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
          ),
      buttonTheme: const ButtonThemeData(),
      dropdownMenuTheme: Theme.of(context).dropdownMenuTheme.copyWith(
            menuStyle: const MenuStyle(visualDensity: VisualDensity.compact),

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
      textTheme: GoogleFonts.robotoTextTheme(
          isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      listTileTheme: getListTileThemeData(context, colorScheme: colorScheme),
      iconTheme: getIconThemeData(context, colorScheme: colorScheme),
      //  ListTileThemeData(

      //     // contentPadding: EdgeInsets.zero,
      //     dense: isDesktopPlatform()),
      checkboxTheme: const CheckboxThemeData(
        // side: BorderSide.none,

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // checkColor: WidgetStateProperty.all(
        //     darkColorScheme.onPrimaryContainer),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
            // fillColor: WidgetStateProperty.all(Colors.amberAccent)

            ),
      ),

      // fontFamily: GoogleFonts.roboto(height: 1.2).fontFamily,
      inputDecorationTheme: getMainTheme(context, colorScheme: colorScheme),
      extensions: [customColor],
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomTransitionBuilder(),
          TargetPlatform.iOS: CustomTransitionBuilder(),
          TargetPlatform.macOS: CustomTransitionBuilder(),
          TargetPlatform.windows: CustomTransitionBuilder(),
          TargetPlatform.linux: CustomTransitionBuilder(),
        },
      ));
}

getTabBarTheme(BuildContext context, ColorScheme colorScheme) {
  return TabBarTheme(
    indicatorColor: colorScheme.primary,
    dividerColor: colorScheme.surfaceContainerHighest,
    labelStyle: Theme.of(context).textTheme.titleSmall,
    labelColor: colorScheme.primary,
    // indicator: BoxDecoration(
    //   borderRadius: BorderRadius.circular(80.0),
    //   color: Theme.of(context).colorScheme.onSecondary,
    // ),
  );
}

getCardTheme(BuildContext context, ColorScheme colorScheme) {
  return CardTheme(
    margin: isLargeScreen(context)
        ? const EdgeInsets.all(1)
        : const EdgeInsets.all(4),
    shape: const RoundedRectangleBorder(
      // side: BorderSide(
      //     width: 1, color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
    ),
  );
}

getBadgeTheme(BuildContext context, ColorScheme colorScheme) {
  return BadgeThemeData(
    backgroundColor: colorScheme.primary,
    offset: const Offset(-2, -2),
  );
}

getExpansionTileTheme(BuildContext context, ColorScheme colorScheme) {
  return ExpansionTileThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius)),
      backgroundColor: colorScheme.surfaceContainer,
      collapsedBackgroundColor: colorScheme.surface
      // backgroundColor: colorScheme.onSurfaceVariant
      // backgroundColor: ElevationOverlay.overlayColor(context, 2)
      );
}

IconButtonThemeData getIconDataTheme(
    BuildContext context, ColorScheme colorSheme) {
  return IconButtonThemeData(style: getButtonStyleIfIcon(context, colorSheme));
}

ElevatedButtonThemeData getElevatedTheme(
    BuildContext context, ColorScheme colorSheme) {
  return ElevatedButtonThemeData(
      style: getButtonStyleIfIcon(context, colorSheme));
}

ButtonStyle getButtonStyleIfIcon(BuildContext context, ColorScheme colorSheme) {
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
      double size = isLargeScreen(context)
          ? kDefaultLargeScreenIconSize
          : kDefaultSmallScreenIconSize;
      if (states.contains(WidgetState.pressed)) {
        return size - 2;
      }
      if (states.contains(WidgetState.hovered)) {
        return size - 1;
      }
      return size;
    }),

    textStyle: WidgetStateProperty.resolveWith((states) {
      //todo
      // if (states.contains(WidgetState.pressed)) {
      //   return Theme.of(context).textTheme.bodySmall;
      // }
      // if (states.contains(WidgetState.hovered)) {
      //   return Theme.of(context).textTheme.bodyMedium;
      // }
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

bool isLargeScreen(BuildContext context) {
  return false;
}

IconThemeData getIconThemeData(BuildContext context,
    {ColorScheme? colorScheme}) {
  ThemeData theme = Theme.of(context);
  colorScheme ??= theme.colorScheme;
  bool isLargeOrDesktop = isLargeScreen(context);
  return theme.iconTheme.copyWith(
      color: colorScheme.onSurfaceVariant,
      size: isLargeOrDesktop
          ? kDefaultLargeScreenIconSize
          : kDefaultSmallScreenIconSize);
}

ListTileThemeData getListTileThemeData(BuildContext context,
    {ColorScheme? colorScheme}) {
  ThemeData theme = Theme.of(context);
  colorScheme ??= theme.colorScheme;
  bool isLargeOrDesktop = isLargeScreen(context);
  return theme.listTileTheme.copyWith(
      dense: isLargeOrDesktop,
      style: ListTileStyle.drawer,
      contentPadding: EdgeInsets.symmetric(
          horizontal: 16, vertical: isLargeOrDesktop ? 0 : 8),
      // minVerticalPadding: 0,

      // horizontalTitleGap: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
      // tileColor: Colors.green,
      selectedColor: colorScheme.onSecondaryContainer,
      selectedTileColor: colorScheme.secondaryContainer);
}

InputDecorationTheme getTextDropDownTheme(BuildContext context) {
  bool isLargeOrDesktop = isDesktopPlatform();
  return getMainTheme(context).copyWith(
    filled: true,
    constraints: isLargeOrDesktop
        ? BoxConstraints.tight(const Size.fromHeight(40))
        : null,
  );
}

InputDecorationTheme getTextFieldTheme(BuildContext context) {
  bool isLargeOrDesktop = isDesktopPlatform();
  return getMainTheme(context).copyWith(
    filled: true,
    constraints: isLargeOrDesktop
        ? BoxConstraints.tight(const Size.fromHeight(60))
        : null,
  );
}

OutlineInputBorder _getBorder(bool isLargeOrDesktop) {
  return OutlineInputBorder(
      gapPadding: isLargeOrDesktop ? 0 : 4,
      borderSide: isLargeOrDesktop ? BorderSide.none : const BorderSide(),
      borderRadius: BorderRadius.all(
          Radius.circular(isLargeOrDesktop ? kBorderRadius : 4)));
}

InputDecorationTheme getTextPopMenuTheme(BuildContext context) {
  bool isLargeOrDesktop = isDesktopPlatform();
  return getMainTheme(context).copyWith(
    filled: true,
    constraints: isLargeOrDesktop
        ? BoxConstraints.tight(const Size.fromHeight(40))
        : null,
  );
}

InputDecorationTheme getCheckTileTheme(BuildContext context) {
  // bool isLargeOrDesktop = isDesktopPlatform();
  return getMainTheme(context).copyWith(
    filled: false,
    // constraints: isLargeOrDesktop
    //     ? BoxConstraints.tight(const Size.fromHeight(40))
    //     : null,
  );
}
// ButtonStyle getButtonStyle(BuildContext context) {}
