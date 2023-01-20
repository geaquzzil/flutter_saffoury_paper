import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';

class CardBackgroundWithTitle extends StatelessWidget {
  String title;
  IconData? leading;
  bool useHorizontalPadding;
  Widget child;
  CardBackgroundWithTitle(
      {super.key,
      required this.title,
      this.leading,
      this.useHorizontalPadding = true,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderDescription(
          title: title,
          iconData: leading,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: useHorizontalPadding ? kDefaultPadding * 2 : 0,
            vertical: kDefaultPadding * .3,
          ),
          child: child,
        )
      ],
    ));
  }
}
