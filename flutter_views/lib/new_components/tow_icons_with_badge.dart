import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

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
      badgeColor: Theme.of(context).colorScheme.onBackground,
      animationDuration: const Duration(milliseconds: 200),
      badgeContent: Icon(
        smallIcon,
        size: 20,
        color: Theme.of(context).colorScheme.background,
      ),
      position: BadgePosition.bottomEnd(),
      padding: const EdgeInsets.all(5),
      toAnimate: false,
      animationType: BadgeAnimationType.scale,
      alignment: Alignment.bottomLeft,
      elevation: 2,
      child: largChild,
    );
  }
}
