import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

class TowIconsWithTextBadge extends StatelessWidget {
  Widget largChild;
  String text;
  TowIconsWithTextBadge({
    super.key,
    required this.largChild,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.square,
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.surface, width: 1),
        badgeColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
      badgeContent: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.onSurface)),
      position: badges.BadgePosition.topEnd(
          // top: -10,
          ),
      badgeAnimation: const badges.BadgeAnimation.size(toAnimate: true),
      onTap: () {
        print('asdfsadfs');
      },
      child: largChild,
    );
  }
}

class TowIcons extends StatelessWidget {
  Widget largChild;
  IconData smallIcon;
  TowIcons({
    super.key,
    required this.largChild,
    required this.smallIcon,
  });

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      // showBadge: ,
      // badgeAnimation: ,
      // badgeColor: Theme.of(context).colorScheme.background,
      // animationDuration: const Duration(milliseconds: 200),
      badgeContent: DecoratedIcon(
        icon: Icon(
          smallIcon,
          size: 10,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        // decoration: IconDecoration(border: IconBorder()),
      ),
      position: badges.BadgePosition.bottomEnd(bottom: -12, end: -12),
      // toAnimate: false,
      // badgeAnimation: customBadges.BadgeAnimationType.scale,
      // alignment: Alignment.bottomLeft,
      // elevation: 2,
      child: largChild,
    );
  }
}
