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
      badgeColor: Colors.white,
      child: largChild,
      animationDuration: Duration(milliseconds: 200),
      badgeContent: Icon(
        smallIcon,
        size: 20,
        color: Colors.black,
      ),
      position: BadgePosition.bottomEnd(),
      padding: const EdgeInsets.all(5),
      toAnimate: false,
      animationType: BadgeAnimationType.scale,
      alignment: Alignment.bottomLeft,
      elevation: 2,
    );
  }
}
