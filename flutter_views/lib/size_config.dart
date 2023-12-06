import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as Math;

import 'package:flutter_view_controller/ext_utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'constants.dart';

const kMobileWidth = 599;
const kFoldableSmallTablet = 839;
const kLargeTablet = 840;
const kDesktopWidth = 1200;

bool isMobile(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value < kMobileWidth;
}

bool isSmallTablet(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value >= kFoldableSmallTablet && value < kLargeTablet;
}

bool isTablet(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value >= kLargeTablet && value < kDesktopWidth;
}

bool isDesktop(BuildContext context, {double? maxWidth}) {
  double value = maxWidth ?? MediaQuery.of(context).size.width;
  return value >= kDesktopWidth;
}

enum MainAxisType {
  ListHorizontal,
  Chart,
}

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
    return isDesktopOrWeb(context);
  }

  static bool isLargeScreenGeneral(BuildContext context) {
    return isLargeScreen(context) || isSoLargeScreen(context);
  }

  static bool isSoLargeScreen(BuildContext context) {
    debugSize(context);
    if (MediaQuery.of(context).size.width >= kLargeTablet) return true;
    bool isSupported =
        isDesktopOrWeb(context) || isFoldableWithOpenDualScreen(context);
    if (!isSupported) return false;
    return MediaQuery.of(context).size.width >= kLargeTablet;
  }

  static bool isLargeScreen(BuildContext context) {
    debugSize(context);
    if (MediaQuery.of(context).size.width >= 500) return true;
    bool isSupported =
        isDesktopOrWeb(context) || isFoldableWithOpenDualScreen(context);
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
    return isDesktopOrWeb(context) || isFoldable(context);
  }

  static bool isDesktopFromScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.width > kLargeTablet;
  }

  static bool isSmallTabletFromScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > kFoldableSmallTablet;
  }

  static bool isMediumFromScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 600 && width < 839;
  }

  static bool isMobileFromScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.width < kMobileWidth;
  }

  static bool isWeb() => kIsWeb;

  static bool isDesktopOrWeb(BuildContext context) {
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
  static ui.Size screenSize = new ui.Size(screenWidth, screenHeight);
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
        screenSize = new ui.Size(screenWidth, screenHeight);

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

    return _device = new Device(
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

  final bool? requireAutoPadding;

  const ScreenHelperSliver(
      {super.key,
      this.requireAutoPadding,
      required this.largeTablet,
      required this.mobile,
      required this.smallTablet,
      required this.desktop});

  Widget getPadding(BuildContext context, double width, Widget widget) {
    double defualPadding = isMobile(context, maxWidth: width)
        ? kDefaultPadding * 2
        : kDefaultPadding;

    double horizontalPadding = max(
        (width -
                (isTablet(context, maxWidth: width)
                    ? kLargeTablet
                    : kDesktopWidth)) /
            2,
        0);
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: defualPadding,
            horizontal: horizontalPadding > defualPadding
                ? horizontalPadding
                : defualPadding),
        child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget currentWidget;
        double maxWidth = constraints.maxWidth;
        double maxLength = constraints.maxHeight;
        if (isMobile(context, maxWidth: maxWidth)) {
          currentWidget = mobile.call(maxWidth, maxLength);
        } else if (isSmallTablet(context, maxWidth: maxWidth)) {
          currentWidget = smallTablet.call(maxWidth, maxLength);
        } else if (isTablet(context, maxWidth: maxWidth)) {
          currentWidget = largeTablet.call(maxWidth, maxLength);
        } else {
          currentWidget = desktop.call(maxWidth, maxLength);
        }
        bool padding = requireAutoPadding ?? false;
        if (padding) {
          return getPadding(context, maxWidth, currentWidget);
        } else {
          return currentWidget;
        }
      },
    );
  }
}

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
