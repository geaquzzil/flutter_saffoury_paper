import 'package:flutter/material.dart';

@Deprecated("Use themData")
class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(
      {super.key,
      this.color,
      required this.child,
      this.useCard = true,
      this.cornersIfCard});
  bool useCard;
  double? cornersIfCard;
  @override
  final Color? color;
  @override
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
