import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:getwidget/getwidget.dart';

import '../cards/card_clicked.dart';

class ListCardItemHorizontal<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function()? onPress;
  final bool useOutlineCard;
  const ListCardItemHorizontal({
    Key? key,
    required this.object,
    this.onPress,
    this.useOutlineCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 60 / 2.0,
            bottom: 60 / 2,
          ),
          child: useOutlineCard
              ? OutlinedCard(
                  onPress: onPress ?? () => object.onCardClicked(context),
                  child: getCardBody(context))
              : CardClicked(
                  onPress:  onPress ?? () => object.onCardClicked(context),
                  child: getCardBody(context),
                ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: DecoratedBox(
              child: object.getCardLeading(context,
                  addCustomHeroTag: "horizontal"),
              decoration: const ShapeDecoration(
                shape: CircleBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container getCardBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 60 / 2,
          ),

          object.getHorizontalCardTitle(context),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          // Spacer(),
          object.getHorizontalCardMainHeader(context),
          // const Spacer(),
          object.getHorizontalCardSubtitle(context),
        ],
      ),
    );
  }
}
