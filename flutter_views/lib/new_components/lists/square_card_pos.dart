import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

class SquareCardPOS<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function? press;
  const SquareCardPOS({
    Key? key,
    required this.object,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                object.getCardLeading(context),
                IconButton(
                    onPressed: () {
                      context
                          .read<CartProvider>()
                          .onCartItemAdded(context,-1, object as CartableProductItemInterface,null);
                    },
                    icon: Icon(Icons.add_shopping_cart))
              ],
            ),
            // object.getCardLeading(context),
            object.getMainHeaderText(context),
            if (object.getMainSubtitleHeaderText(context) != null)
              object.getMainSubtitleHeaderText(context)!,
          ],
        ),
      ),
    );
  }
}
