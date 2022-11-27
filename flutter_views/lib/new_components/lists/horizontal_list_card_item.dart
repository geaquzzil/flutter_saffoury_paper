import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:getwidget/getwidget.dart';

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
    return SizedBox(
      width: 210,
      // height: 10,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 60 / 2.0, bottom: 60 / 2),
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
              //replace this Container with your Card
              // color: Colors.white,
              height: 200.0,
              width: 200,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 30 / 2,
                    ),

                    object.getHorizontalCardTitle(context),
                    // Spacer(),
                    object.getHorizontalCardMainHeader(context),
                    // const Spacer(),
                    object.getHorizontalCardSubtitle(context),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(1),
              child: DecoratedBox(
                child: object.getCardLeading(context),
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Card(
      child: SizedBox(
        width: 500,
        // height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: 70,
              height: 70,
              child: object.getCardLeading(context),
            ),
            object.getMainHeaderText(context),
            // const Spacer(),
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
