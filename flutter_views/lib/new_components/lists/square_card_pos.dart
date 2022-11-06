import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/posable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';

class SquareCardPOS<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  final Function? press;
  const SquareCardPOS({
    Key? key,
    required this.object,
    this.press,
  }) : super(key: key);

  @override
  State<SquareCardPOS<T>> createState() => _SquareCardPOSState<T>();
}

class _SquareCardPOSState<T extends ViewAbstract>
    extends State<SquareCardPOS<T>> {
  TextEditingController _textFieldController = TextEditingController();

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
                widget.object.getCardLeading(context),
                IconButton(
                    onPressed: () async {
                      _showDialog(context);
                    },
                    icon: Icon(Icons.add_shopping_cart))
              ],
            ),
            // object.getCardLeading(context),
            widget.object.getMainHeaderText(context),
            if (widget.object.getMainSubtitleHeaderText(context) != null)
              widget.object.getMainSubtitleHeaderText(context)!,
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return (widget.object as PosableInterface)
              .getPosableOnAddWidget(context);
        });
  }
}
