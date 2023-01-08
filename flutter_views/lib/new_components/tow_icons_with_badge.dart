import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

class TowIcons extends StatelessWidget {
  Widget largChild;
  IconData smallIcon;
  TowIcons({
    Key? key,
    required this.largChild,
    required this.smallIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeColor: Theme.of(context).colorScheme.background,
      animationDuration: const Duration(milliseconds: 200),
      badgeContent: DecoratedIcon(
        icon: Icon(
          smallIcon,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        // decoration: IconDecoration(border: IconBorder()),
      ),
      position: BadgePosition.bottomEnd(bottom: -12, end: -12),
      toAnimate: false,
      animationType: BadgeAnimationType.scale,
      alignment: Alignment.bottomLeft,
      elevation: 2,
      child: largChild,
    );
  }
}
