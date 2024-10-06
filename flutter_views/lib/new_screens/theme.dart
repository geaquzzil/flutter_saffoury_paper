import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';

///TODO override [constraints] on TextField
///TODO override isLargeOrDesktop to [isDesktopPlatform]
InputDecorationTheme getMainTheme(BuildContext context,
    {ColorScheme? colorScheme}) {
  ThemeData theme = Theme.of(context);
  colorScheme ??= theme.colorScheme;
  bool isLargeOrDesktop = isLargeScreen(context);
  return theme.inputDecorationTheme.copyWith(
    // isDense: isLargeOrDesktop,
    filled: isLargeOrDesktop,
    fillColor: colorScheme.surfaceContainerHighest,

    constraints: isLargeOrDesktop
        ? BoxConstraints.tight(const Size.fromHeight(30))
        : BoxConstraints.tight(const Size.fromHeight(56)),
    // hoverColor: Colors.transparent,
    border: _getBorder(isLargeOrDesktop),
    // focusedBorder: _getBorder(isLargeOrDesktop),
    // enabledBorder: _getBorder(isLargeOrDesktop)
  );
}

bool isLargeScreen(BuildContext context) {
  return true;
}

ListTileThemeData getListTileThemeData(BuildContext context,
    {ColorScheme? colorScheme}) {
  ThemeData theme = Theme.of(context);
  colorScheme ??= theme.colorScheme;
  bool isLargeOrDesktop = isLargeScreen(context);
  return theme.listTileTheme.copyWith(
      dense: isLargeOrDesktop,
      style: ListTileStyle.list,
      contentPadding: EdgeInsets.symmetric(
          horizontal: 16, vertical: isLargeOrDesktop ? 2 : 8),
      // minVerticalPadding: 0,

      // horizontalTitleGap: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
      // tileColor: Colors.green,
      // selectedColor: colorScheme.primary,
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
