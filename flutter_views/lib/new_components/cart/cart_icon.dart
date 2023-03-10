import 'package:badges/badges.dart' as customBadges;
import 'package:flutter/material.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';

import '../../providers/cart/cart_provider.dart';

class CartIconWidget extends StatelessWidget {
  Function()? onPressed;
  bool returnNillIfZero;
  CartIconWidget({super.key, this.onPressed, this.returnNillIfZero = true});

  @override
  Widget build(BuildContext context) {
    return Selector<CartProvider, int>(
      builder: ((_, value, __) {
        bool hideButton = value == 0 && returnNillIfZero;
        return AnimatedScale(
          duration: const Duration(milliseconds: 275),
          scale: hideButton ? 0 : 1,
          child: hideButton
              ? SizedBox()
              : Badge(
                  isLabelVisible: value > 0,
                  smallSize: 4,
                  label: Text(
                    "$value",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  // badgeColor: Theme.of(context).colorScheme.primary,
                  // badgeContent: Text(
                  //   "$value",
                  //   style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  //       color: Theme.of(context).colorScheme.onPrimary),
                  // ),
                  // // padding: EdgeInsets.zero,
                  // position: BadgePosition.topEnd(top: -4, end: -5),
                  // // stackFit: StackFit.passthrough,
                  // toAnimate: true,
                  // animationType: BadgeAnimationType.scale,
                  // animationDuration: const Duration(milliseconds: 50),
                  // showBadge: value > 0,
                  child: IconButton(
                      // padding: EdgeInsets.all(4),
                      onPressed: onPressed,
                      iconSize: 25,
                      icon: const Icon(Icons.shopping_cart_rounded),
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
        );
      }),
      selector: (p0, p1) => p1.getCount,
    );
  }
}
