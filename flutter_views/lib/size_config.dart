// ignore_for_file: constant_identifier_names, library_prefixes

import 'dart:io';
import 'dart:math' as Math;
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'constants.dart';

const double kMobileWidth = 599;
const double kFoldableSmallTablet = 600;
const double kLargeTablet = 840;
const double kDesktopWidth = 1200;
const double kDrawerOpenWidth = 200;

const double kDefaultClosedDrawer = 80;


Size findPopupSizeSquare(BuildContext context,
    {CurrentScreenSize? screenSize}) {
  screenSize ??= findCurrentScreenSize(context);
  Size s = MediaQuery.of(context).size;
  return const Size(400, 400);
}

bool isLargeScreenFromScreenSize(CurrentScreenSize? screenSize) {
  return screenSize == CurrentScreenSize.DESKTOP ||
      screenSize == CurrentScreenSize.LARGE_TABLET;
}

bool hideHamburger(BuildContext context, {CurrentScreenSize? screenSize}) {
  return screenSize == null
      ? isLargeScreenFromCurrentScreenSize(context)
      : isLargeScreenFromScreenSize(screenSize);
}

bool showHamburger(CurrentScreenSize? screenSize) {
  return screenSize == CurrentScreenSize.MOBILE ||
      screenSize == CurrentScreenSize.SMALL_TABLET;
}

bool isLargeScreenFromCurrentScreenSize(BuildContext context, {double? width}) {
  CurrentScreenSize currentScreenSize =
      findCurrentScreenSize(context, width: width);
  return currentScreenSize == CurrentScreenSize.DESKTOP ||
      currentScreenSize == CurrentScreenSize.LARGE_TABLET;
}

CurrentScreenSize findCurrentScreenSize(BuildContext context, {double? width}) {
  width ??= MediaQuery.of(context).size.width;

  if (isDesktop(context, maxWidth: width)) {
    return CurrentScreenSize.DESKTOP;
  } else if (isMobile(context, maxWidth: width)) {
    return CurrentScreenSize.MOBILE;
  } else if (isSmallTablet(context, maxWidth: width)) {
    return CurrentScreenSize.SMALL_TABLET;
  } else {
    return CurrentScreenSize.LARGE_TABLET;
  }
}

/// check for width is < [kMobileWidth]=599
bool isMobileFromWidth(double maxWidth) {
  return maxWidth < kMobileWidth;
}

///check for width is
bool isTabletFromWidth(double maxWidth) {
  return maxWidth >= kLargeTablet && maxWidth < kDesktopWidth;
}

bool isMobilePlatform() {
  return Platform.isAndroid || Platform.isIOS;
}

bool supportsSerialPort() {
  return Platform.isAndroid ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isWindows;
}

bool supportsFirebaseNotification() {
  return Platform.isAndroid || Platform.isMacOS || Platform.isIOS || kIsWeb;
}

bool isDesktopPlatform() {
  return !isMobilePlatform();
}

bool isMobile(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return isMobileFromWidth(value);
}

bool isSmallTablet(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value >= kFoldableSmallTablet && value < kLargeTablet;
}

bool isTablet(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return isTabletFromWidth(value);
}

bool isDesktop(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value >= kDesktopWidth;
}

EdgeInsets getSuggestionPadding(double width) {
  double defualPadding =
      isMobileFromWidth(width) ? kDefaultPadding * 2 : kDefaultPadding;
//1920 -900
  double horizontalPadding = max(
      (width - (isTabletFromWidth(width) ? kLargeTablet : kDesktopWidth)) / 4,
      0);

  debugPrint("getSuggetionPadding horizontalPadding : $horizontalPadding");

  return EdgeInsets.symmetric(
      vertical: defualPadding,
      horizontal: horizontalPadding > defualPadding
          ? horizontalPadding
          : defualPadding);
}

enum MainAxisType {
  ListHorizontal,
  Chart,
}

@Deprecated("Move to Current Screen Size")
class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;

  void init(BoxConstraints constraints) {
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;
  }

  // Get the height, proportionally to screen height
  static double getScreenPropotionHeight(double actualHeight) {
    // 812 is the artboard height that designer use
    return (actualHeight / 900.0) * screenHeight;
  }

  // Get the width, proportionally to screen width
  static double getScreenPropotionWidth(double actualWidth) {
    // 375 is the artboard width that designer use
    return (actualWidth / 375.0) * screenWidth;
  }

  static double getPaneProportion(BuildContext context,
      {Orientation? orientation}) {
    if (MediaQuery.of(context).hinge != null) return 0.5;
    if (SizeConfig.isMediumFromScreenSize(context)) {
      return 0.5;
    } else {
      return 0.3;
    }
  }

  static bool hasPointer(BuildContext context) {
    return isDesktopOrWebPlatform(context);
  }

  static bool isLargeScreenGeneral(BuildContext context) {
    return isLargeScreen(context) || isSoLargeScreen(context);
  }

  static bool isSoLargeScreen(BuildContext context) {
    debugSize(context);
    if (MediaQuery.of(context).size.width >= kLargeTablet) return true;
    bool isSupported = isDesktopOrWebPlatform(context) ||
        isFoldableWithOpenDualScreen(context);
    if (!isSupported) return false;
    return MediaQuery.of(context).size.width >= kLargeTablet;
  }

  static bool isLargeScreen(BuildContext context) {
    debugSize(context);
    if (MediaQuery.of(context).size.width >= 500) return true;
    bool isSupported = isDesktopOrWebPlatform(context) ||
        isFoldableWithOpenDualScreen(context);
    if (!isSupported) return false;
    bool hasSpace = MediaQuery.of(context).size.width >= 500;
    return hasSpace;
  }

  static bool isFoldableWithSingleScreen(BuildContext context) {
    return MediaQuery.of(context).hinge == null && isSingleScreen(context);
  }

  static bool isFoldableWithOpenDualScreen(BuildContext context) {
    return isFoldable(context) && !isSingleScreen(context);
  }

  static num getMainAxisCellCount(BuildContext context,
      {MainAxisType? mainAxisType}) {
    bool isLargeScreenAS = isLargeScreen(context) || isSoLargeScreen(context);
    if (isLargeScreenAS) {
      return mainAxisType == null
          ? 1
          : getMainAxisCellPassedOnType(isLargeScreenAS, mainAxisType);
    }
    return mainAxisType == null
        ? 1.5
        : getMainAxisCellPassedOnType(isLargeScreenAS, mainAxisType);
  }

  static num getMainAxisCellPassedOnType(
      bool isLargeScreen, MainAxisType mainAxisType) {
    switch (mainAxisType) {
      case MainAxisType.ListHorizontal:
        return isLargeScreen ? 0.9 : 1.4;
      case MainAxisType.Chart:
        return 1;
    }
  }

  static void debugSize(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // debugPrint(
    //     "debugSize screenWidth ${size.width} screenHeight ${size.height}");

    // debugPrint(
    //     "debugSize displayFeatures ${MediaQuery.of(context).displayFeatures}");
  }

  static bool isSingleScreen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width < 500;
  }

  static bool isFoldable(BuildContext context) {
    bool isFold = MediaQuery.of(context).displayFeatures.firstWhereOrNull(
            (element) => element.type == DisplayFeatureType.fold) !=
        null;

    return MediaQuery.of(context).hinge != null || isFold;
  }

  static double? getDrawerWidth(BuildContext context) {
    if (kIsWeb) return 256;
    if (SizeConfig.isMobile(context) ||
        SizeConfig.isFoldableWithSingleScreen(context)) {
      return MediaQuery.of(context).size.width * .75;
    } else if (SizeConfig.isFoldableWithOpenDualScreen(context)) {
      return MediaQuery.of(context).size.width * .40;
    }
    if (SizeConfig.isDesktop(context)) {
      return 256;
    }
    if (SizeConfig.isTablet(context)) {
      return MediaQuery.of(context).size.width * .25;
    }
    return MediaQuery.of(context).size.width * .75;
  }

  static bool isMobile(BuildContext context) {
    if (kIsWeb) return false;
    return Device.get().isPhone || isFoldableWithSingleScreen(context);
  }

  static bool isTablet(BuildContext context) => Device.get().isTablet;

  static bool hasSecondScreen(BuildContext context) {
    return isDesktopOrWebPlatform(context) || isFoldable(context);
  }

  static bool isDesktopFromScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.width > kLargeTablet;
  }

  static bool isSmallTabletFromScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > kFoldableSmallTablet;
  }

  static bool isMediumFromScreenSize(BuildContext context, {double? width}) {
    width = width ?? MediaQuery.of(context).size.width;
    return isSmallTablet(context, maxWidth: width);
  }

  static bool isMobileFromScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.width < kMobileWidth;
  }

  static bool isWeb() => kIsWeb;

  static bool isDesktopOrWebPlatform(BuildContext context) {
    if (isWeb()) return true;
    return isDesktop(context);
  }

  static bool isDesktop(BuildContext context) =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

class Device {
  static double devicePixelRatio = ui.window.devicePixelRatio;
  static ui.Size size = ui.window.physicalSize;
  static double width = size.width;
  static double height = size.height;
  static double screenWidth = width / devicePixelRatio;
  static double screenHeight = height / devicePixelRatio;
  static ui.Size screenSize = ui.Size(screenWidth, screenHeight);
  final bool isTablet, isPhone, isIos, isAndroid, isIphoneX, hasNotch;
  static Device? _device;
  static Function? onMetricsChange;

  Device(
      {required this.isTablet,
      required this.isPhone,
      required this.isIos,
      required this.isAndroid,
      required this.isIphoneX,
      required this.hasNotch});

  factory Device.get() {
    if (_device != null) return _device!;

    if (onMetricsChange == null) {
      onMetricsChange = ui.window.onMetricsChanged;
      ui.window.onMetricsChanged = () {
        _device = null;

        size = ui.window.physicalSize;
        width = size.width;
        height = size.height;
        screenWidth = width / devicePixelRatio;
        screenHeight = height / devicePixelRatio;
        screenSize = ui.Size(screenWidth, screenHeight);

        onMetricsChange!();
      };
    }

    bool isTablet;
    bool isPhone;
    bool isIos = Platform.isIOS;
    bool isAndroid = Platform.isAndroid;
    bool isIphoneX = false;
    bool hasNotch = false;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }

    // Recalculate for Android Tablet using device inches
    if (isAndroid) {
      final adjustedWidth = _calWidth() / devicePixelRatio;
      final adjustedHeight = _calHeight() / devicePixelRatio;
      final diagonalSizeInches = (Math.sqrt(
              Math.pow(adjustedWidth, 2) + Math.pow(adjustedHeight, 2))) /
          _ppi;
      //print("Dialog size inches is $diagonalSizeInches");
      if (diagonalSizeInches >= 7) {
        isTablet = true;
        isPhone = false;
      } else {
        isTablet = false;
        isPhone = true;
      }
    }

    if (isIos &&
        isPhone &&
        (screenHeight == 812 ||
            screenWidth == 812 ||
            screenHeight == 896 ||
            screenWidth == 896 ||
            // iPhone 12 pro
            screenHeight == 844 ||
            screenWidth == 844 ||
            // Iphone 12 pro max
            screenHeight == 926 ||
            screenWidth == 926)) {
      isIphoneX = true;
      hasNotch = true;
    }

    if (_hasTopOrBottomPadding()) hasNotch = true;

    return _device = Device(
        isTablet: isTablet,
        isPhone: isPhone,
        isAndroid: isAndroid,
        isIos: isIos,
        isIphoneX: isIphoneX,
        hasNotch: hasNotch);
  }

  static double _calWidth() {
    if (width > height) {
      return (width +
          (ui.window.viewPadding.left + ui.window.viewPadding.right) *
              width /
              height);
    }
    return (width + ui.window.viewPadding.left + ui.window.viewPadding.right);
  }

  static double _calHeight() {
    return (height +
        (ui.window.viewPadding.top + ui.window.viewPadding.bottom));
  }

  static int get _ppi => Platform.isAndroid
      ? 160
      : Platform.isIOS
          ? 150
          : 96;

  static bool _hasTopOrBottomPadding() {
    final padding = ui.window.viewPadding;
    //print(padding);
    return padding.top > 0 || padding.bottom > 0;
  }
}

class ResponsiveWebBuilderSliver extends StatelessWidget {
  final Widget Function(BuildContext context, double width) builder;

  const ResponsiveWebBuilderSliver({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      largeTablet: _buildUi(context, kDesktopMaxWidth),
      smallTablet: _buildUi(context, kTabletMaxWidth),
      mobile: _buildUi(context, getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    return MaxWidthBox(
        maxWidth: width,
        // minWidth: width,
        // defaultScale: false,
        child: builder.call(context, width));
  }
}

class ResponsiveWebBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, double width) builder;

  const ResponsiveWebBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      largeTablet: _buildUi(context, kDesktopMaxWidth),
      smallTablet: _buildUi(context, kTabletMaxWidth),
      mobile: _buildUi(context, getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return MaxWidthBox(
            maxWidth: width,
            // minWidth: width,
            // defaultScale: false,
            child: builder.call(context, width));
      }),
    );
  }
}

class ScreenHelperSliver extends StatelessWidget {
  final Widget Function(double width, double height) mobile;
  final Widget Function(double width, double height) smallTablet;
  final Widget Function(double width, double height) largeTablet;
  final Widget Function(double width, double height) desktop;
  final bool forceSmallView;
  final Function(double width, double height, CurrentScreenSize c)?
      onChangeLayout;

  final bool? requireAutoPadding;

  const ScreenHelperSliver(
      {super.key,
      this.requireAutoPadding,
      required this.largeTablet,
      required this.mobile,
      required this.smallTablet,
      required this.desktop,
      this.forceSmallView = false,
      this.onChangeLayout});

  Widget getPadding(BuildContext context, double width, Widget widget) {
    double defualPadding = isMobile(context, maxWidth: width)
        ? kDefaultPadding * 2
        : kDefaultPadding;

    double horizontalPadding = max(
        (width -
                (isDesktop(context, maxWidth: width)
                    ? kFoldableSmallTablet
                    : kDesktopWidth)) /
            2,
        0);
    debugPrint(
        "ScreenHelperSliver getPadding vertical: $defualPadding horizontal: $horizontalPadding");
    int padd = 2;
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: max((width - 1200) / padd, 0) > kDefaultPadding
                ? max((width - 1200) / padd, 0)
                : kDefaultPadding),
        child: widget);
  }

  void addFramPost(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget currentWidget;
        double maxWidth = constraints.maxWidth;
        double maxLength = constraints.maxHeight;
        // if (maxWidth == null || maxLength == null) return SizedBox();
        debugPrint(
            "layoutBuilder width $maxWidth height $maxLength currentScreenSize ${findCurrentScreenSize(context, width: maxWidth)}");

        onChangeLayout?.call(
            maxWidth,
            maxLength,
            forceSmallView
                ? CurrentScreenSize.MOBILE
                : findCurrentScreenSize(context, width: maxWidth));

        if (forceSmallView) {
          currentWidget = mobile.call(maxWidth, maxLength);
        } else {
          if (isMobile(context, maxWidth: maxWidth)) {
            currentWidget = mobile.call(maxWidth, maxLength);
          } else if (isSmallTablet(context, maxWidth: maxWidth)) {
            currentWidget = smallTablet.call(maxWidth, maxLength);
          } else if (isTablet(context, maxWidth: maxWidth)) {
            currentWidget = largeTablet.call(maxWidth, maxLength);
          } else {
            currentWidget = desktop.call(maxWidth, maxLength);
          }
        }
        bool padding = requireAutoPadding ?? false;
        if (padding) {
          debugPrint("ScreenHelperSliver => padding $padding");
          return getPadding(context, maxWidth, currentWidget);
        } else {
          return currentWidget;
        }
      },
    );
  }
}

enum CurrentScreenSize { MOBILE, SMALL_TABLET, LARGE_TABLET, DESKTOP }

class ScreenHelper extends StatelessWidget {
  final Widget mobile;

  final Widget smallTablet;
  final Widget largeTablet;

  const ScreenHelper(
      {super.key,
      required this.largeTablet,
      required this.mobile,
      required this.smallTablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 1200.0) {
          return largeTablet;
        } else if (constraints.maxWidth >= 800 &&
            constraints.maxWidth < 1200.0) {
          return smallTablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
