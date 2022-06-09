import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/screens/web/sign_in.dart';

class HeaderItem {
  final String title;
  final bool isButton;

  HeaderItem({
    required this.title,
    this.isButton = false,
  });

  void onHeaderItemClick(BuildContext context) {
    if (title == "OUR PRODUCTS") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProductWebPage()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignIn(),
      ),
    );
  }
}
