import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListCardItemHorizontal<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function? press;
  const ListCardItemHorizontal({
    Key? key,
    required this.object,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => object.onCardClicked(context),
      child: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 70,
              height: 70,
              child: object.getCardLeading(context),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                child: object.getMainHeaderText(context)),
            const Spacer(),
            object.getMainSubtitleHeaderText(context)!,
            // Text(
            //   "product.price",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // )
          ],
        ),
      ),
    );
  }
}
