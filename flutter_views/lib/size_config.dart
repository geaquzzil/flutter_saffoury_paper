import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  static const mobileWidth = 599;
  static const foldableSmallTablet = 839;
  static const largeTablet = 840;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < foldableSmallTablet &&
      MediaQuery.of(context).size.width > mobileWidth;

  static bool isWeb() => kIsWeb;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > largeTablet;
}

class ScreenHelper extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ScreenHelper({Key? key, required this.desktop, required this.mobile, required this.tablet})
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
