import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/header_description.dart';

class CardBackgroundWithTitle extends StatelessWidget {
  String title;
  IconData? leading;
  bool useHorizontalPadding;
  bool useVerticalPadding;
  bool centerTitle;
  Widget child;

  CardBackgroundWithTitle(
      {super.key,
      required this.title,
      this.leading,
      this.centerTitle = false,
      this.useHorizontalPadding = true,
      this.useVerticalPadding = true,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (centerTitle)
          Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        else
          HeaderDescription(
            title: title,
            iconData: leading,
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: useHorizontalPadding ? kDefaultPadding * 2 : 0,
            vertical: useVerticalPadding ? kDefaultPadding * .3 : 0,
          ),
          child: child,
        )
      ],
    ));
  }
}
