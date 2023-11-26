import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ProductCardBottom<T extends ViewAbstract> extends StatelessWidget {
  const ProductCardBottom({
    Key? key,
    required this.object,
  }) : super(key: key);

  final T object;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'product.price',
            style: TextStyle(
              color: kWhite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          // RatingBar.builder(
          //   initialRating: 2,
          //   allowHalfRating: false,
          //   itemCount: 5,
          //   ignoreGestures: true, // this disables the change star rating
          //   itemSize: 20,
          //   itemBuilder: (context, _) => const Icon(
          //     Icons.star,
          //     color: kWhite,
          //   ),
          //   onRatingUpdate: (rating) {},
          // )
        ],
      ),
    );
  }
}
