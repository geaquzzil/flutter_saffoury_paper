import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class SquareCard<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function? press;
  const SquareCard({
    super.key,
    required this.object,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            object.getCardLeading(context),
            object.getMainHeaderText(context),
            if (object.getMainSubtitleHeaderText(context) != null)
              object.getMainSubtitleHeaderText(context)!,


          ],
        ),
      ),
    );
  }
}
