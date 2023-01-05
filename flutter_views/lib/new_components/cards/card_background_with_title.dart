import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class CardBackgroundWithTitle extends StatelessWidget {
  String title;
  IconData? leading;
  Widget child;
  CardBackgroundWithTitle(
      {super.key, required this.title, this.leading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: leading == null ? null : Icon(leading),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 2,
            vertical: kDefaultPadding / 2,
          ),
          child: child,
        )
      ],
    ));
  }
}
