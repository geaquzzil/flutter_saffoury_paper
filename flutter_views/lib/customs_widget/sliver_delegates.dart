import 'dart:math';

import 'package:flutter/material.dart';

class SliverPersistantContainer extends StatelessWidget {
  final Widget child;
  final double minExtent;
  final double maxExtent;
  final bool pinned;
  final bool floating;

  const SliverPersistantContainer({
    super.key,
    this.minExtent = 0.0,
    required this.maxExtent,
    this.pinned = true,
    this.floating = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: SliverPersistantContainerHeaderDelegate(
        child: child,
        minExtent: minExtent,
        maxExtent: maxExtent,
      ),
      floating: floating,
      pinned: pinned,
    );
  }
}

class SliverPersistantContainerHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  @override
  final double maxExtent;
  @override
  final double minExtent;

  SliverPersistantContainerHeaderDelegate({
    required this.child,
    required this.maxExtent,
    this.minExtent = 0.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedOverflowBox(
      alignment: Alignment.topCenter,
      size: Size.fromHeight(
          (maxExtent - shrinkOffset).clamp(minExtent, maxExtent).toDouble()),
      child: child,
    );
  }

  @override
  bool shouldRebuild(SliverPersistantContainerHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent;
  }
}

class SliverAppBarDelegatePreferedSize extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;
  final bool shouldRebuildWidget;
  final bool wrapWithSafeArea;
  SliverAppBarDelegatePreferedSize({
    this.shouldRebuildWidget = false,
    this.wrapWithSafeArea = false,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (wrapWithSafeArea) {
      return SafeArea(bottom: false, child: SizedBox.expand(child: child));
    }

    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverAppBarDelegatePreferedSize oldDelegate) {
    if (wrapWithSafeArea) {
      //todo
      if (oldDelegate.child != child) {
        return true;
      }
      return false;
    } else {
      return shouldRebuildWidget;
    }
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  // 2
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  // 3
  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
