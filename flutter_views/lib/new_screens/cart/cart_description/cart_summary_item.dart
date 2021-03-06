import 'package:flutter/material.dart';

class CartSummaryItem extends StatelessWidget {
  double fontSize;
  String title;
  String description;
  CartSummaryItem(
      {Key? key,
      required this.title,
      required this.description,
      this.fontSize = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: fontSize,
                fontWeight: FontWeight.normal),
          ),
          Text(
            description,
            style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
