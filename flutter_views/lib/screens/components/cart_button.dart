import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/screens/shopping_cart_page.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';

class CartButton extends StatefulWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return IconBadge(
      icon: const Icon(Icons.shopping_cart_outlined),
      itemCount: context.watch<CartProvider>().getCount,
      badgeColor: Colors.red,
      itemColor: Colors.white,
      maxCount: 99,
      hideZero: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ShoppingCartPage(),
          ),
        );
      },
    );
  }
}
