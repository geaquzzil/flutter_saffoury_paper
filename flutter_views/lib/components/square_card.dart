import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class SquareCard<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function? press;
  const SquareCard({
    Key? key,
    required this.object,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => object.onCardClicked(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: object.getColor(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "product.id",
                child: object.getCardLeadingImage(context),
              ),
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: object.getHeaderText(context)),
          object.getSubtitleHeaderText(context)!,
          // Text(
          //   "product.price",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }
}
