import 'package:flutter/material.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

/// Extra scroll offset to be added while the scroll is happened
/// Default value is 10
const int defaultScrollOffset = 10;

/// Duration/length for how long the animation should go
/// after the scroll has happened
/// Default value is 600ms
const int defaultAnimationDuration = 600;

class ResponsiveScroll extends StatelessWidget {
  /// Scroll Controller for controlling the scroll behaviour manually
  /// so we can animate to next scrolled position and avoid the jerky movement
  /// of default scroll
  final ScrollController controller;

  /// Child scrollable widget.
  final Widget child;

  /// Extra scroll offset to be added while the scroll is happened
  /// Default value is 100
  /// You can try it for a range of 10 - 300 or keep it 0
  final int scrollOffset;

  /// Duration/length for how long the animation should go
  /// after the scroll has happened
  /// Default value is 600ms
  final int animationDuration;

  /// Curve of the animation.
  final Curve curve;
  const ResponsiveScroll({
    super.key,
    required this.controller,
    required this.child,
    this.scrollOffset = defaultScrollOffset,
    this.animationDuration = defaultAnimationDuration,
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktopPlatform()) {
      return WebSmoothScroll(
          animationDuration: animationDuration,
          curve: curve,
          scrollOffset: scrollOffset,
          controller: controller,
          child: child);
    }
    return child;
  }
}
