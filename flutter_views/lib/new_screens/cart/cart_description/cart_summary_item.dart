import 'package:flutter/material.dart';

class CartSummaryItem extends StatelessWidget {
  double fontSize;
  String title;
  String? description;
  CartSummaryItem(
      {super.key, required this.title, this.description, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
            ),
        ],
      ),
    );
  }
}
