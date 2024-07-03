import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ProductImages<T extends ViewAbstract> extends StatelessWidget {
  const ProductImages({
    super.key,
    required this.product,
  });

  final T product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Image.network(product.getImageUrl(context) ?? ""));
        },
        itemCount: 3,
      ),
    );
  }
}
