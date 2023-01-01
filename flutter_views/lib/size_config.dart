import 'dart:io';

import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as Math;

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static const mobileWidth = 599;
  static const foldableSmallTablet = 839;
  static const largeTablet = 840;

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
    if (SizeConfig.isDesktopOrWeb(context)) return 0.4;
    if (SizeConfig.isTablet(context)) return 0.4;
    return 0.4;
  }

  static bool isLargeScreen(BuildContext context) {
    return isDesktop(context) || isFoldableWithOpenDualScreen(context);
  }

  static bool isFoldableWithSingleScreen(BuildContext context) {
    return MediaQuery.of(context).hinge == null && isSingleScreen(context);
  }

  static bool isFoldableWithOpenDualScreen(BuildContext context) {
    return MediaQuery.of(context).hinge != null && !isSingleScreen(context);
  }

  static bool isSingleScreen(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    debugPrint("isSingleScreen screenWidth $width");
    return width < 500;
  }

  static bool isFoldable(BuildContext context) {
    return MediaQuery.of(context).hinge != null;
  }

  static double? getDrawerWidth(BuildContext context) {
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
    return isDesktop(context) || isFoldable(context);
  }

  static bool isWeb() => kIsWeb;

  static bool isDesktopOrWeb(BuildContext context) =>
      isDesktop(context) || isWeb();
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
    if (width > height)
      return (width +
          (ui.window.viewPadding.left + ui.window.viewPadding.right) *
              width /
              height);
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

class ScreenHelper extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ScreenHelper(
      {Key? key,
      required this.desktop,
      required this.mobile,
      required this.tablet})
      : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800.0;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800.0 &&
      MediaQuery.of(context).size.width < 1200.0;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 1200.0) {
          return desktop;
        } else if (constraints.maxWidth >= 800 &&
            constraints.maxWidth < 1200.0) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
