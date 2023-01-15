import 'package:flutter/material.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(
      {this.color,
      required this.child,
      this.useCard = true,
      this.cornersIfCard});
  bool useCard;
  double? cornersIfCard;
  final Color? color;
  final TabBar child;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    if (useCard) {
      return Card(
        shape: cornersIfCard == null
            ? null
            : RoundedRectangleBorder(
                // side: BorderSide(
                //   color: color != null
                //       ? color!.darkMutedColor?.color ??
                //           Theme.of(context).colorScheme.outline.withOpacity(.8)
                //       : Theme.of(context).colorScheme.outline.withOpacity(.8),
                // ),
                borderRadius: BorderRadius.all(Radius.circular(cornersIfCard!)),
              ),
        color: color,
        child: child,
      );
    } else {
      return Container(
        color: color,
        child: child,
      );
    }
  }
}
