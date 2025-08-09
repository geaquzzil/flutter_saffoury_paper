import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/stylings.dart';
import 'package:flutter_view_controller/new_components/lists/skeletonizer/widgets.dart';

class LoadingScreen extends StatelessWidget {
  final bool isPage;
  final bool isSliver;
  final double width;
  const LoadingScreen({
    super.key,
    required this.isPage,
    required this.width,
    required this.isSliver,
  });

  @override
  Widget build(BuildContext context) {
    Widget w;
    if (isPage) {
      w = SkeletonPage();
    } else {
      w = SkeletonParagraph(
        style: SkeletonParagraphStyle(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 2,
            vertical: kDefaultPadding,
          ),
          lineStyle: SkeletonLineStyle(
            randomLength: true,
            maxLength: width,
            minLength: width * .7,
          ),
          lines: 10,
          spacing: kDefaultPadding,
        ),
      );
    }
    if (isSliver) {
      return SliverFillRemaining(child: w);
    }
    return w;
  }
}
