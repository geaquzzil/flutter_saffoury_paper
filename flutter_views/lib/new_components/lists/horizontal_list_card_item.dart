import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:getwidget/getwidget.dart';
import 'package:palette_generator/palette_generator.dart';

import '../cards/card_clicked.dart';

class ListCardItemHorizontal<T extends ViewAbstract> extends StatelessWidget {
  final T object;
  final Function()? onPress;
  final bool useOutlineCard;
  bool useImageAsBackground;
  PaletteGenerator? color;
  String? imgUrl;
  ListCardItemHorizontal({
    Key? key,
    required this.object,
    this.onPress,
    this.useImageAsBackground = false,
    this.useOutlineCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    init(context);
    if (useImageAsBackground) {
      if (imgUrl != null) {
        return FutureBuilder<PaletteGenerator>(
          future: PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(imgUrl!),
          ),
          builder: (context, snapshot) {
            color = snapshot.data;
            return openContainer(context);
          },
        );
      }

      return openContainer(context);
    }
    return getNormalCard(context);
  }

  Widget getCardAsBackground(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
              child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            fit: StackFit.loose,
            children: [
              Container(
                  // width: 150,
                  // height: 100,
                  decoration: BoxDecoration(
                      image: imgUrl == null
                          ? null
                          : DecorationImage(
                              image: CachedNetworkImageProvider(imgUrl!),
                              fit: BoxFit.contain),
                      color: imgUrl == null
                          ? null
                          : color?.darkVibrantColor?.color,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)))),
              Container(
                // padding: const EdgeInsets.all(5.0),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    gradient: imgUrl == null
                        ? null
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withAlpha(0),
                              Colors.black12,
                              Colors.black87
                            ],
                          ),
                    color: imgUrl == null
                        ? null
                        : color?.darkVibrantColor?.titleTextColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18))),
                // height: 50,
                padding: const EdgeInsets.all(kDefaultPadding * .3),
                // width: double.infinity,

                child: object.getHorizontalCardTitleSameLine(context,
                    isImageAsBackground: true, color: color),
              )
            ],
          )),
        ),
        object.getHorizontalCardMainHeader(context),
        // const Spacer(),
        object.getHorizontalCardSubtitle(context),
      ],
    );
  }

  Widget openContainer(BuildContext context) {
    return OpenContainer(
        closedColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 500),
        transitionType: ContainerTransitionType.fade,
        
        closedBuilder: (context, action) => getCardAsBackground(context),
        openBuilder: (context, action) =>
            BaseViewNewPage(viewAbstract: object));
  }

  Stack getNormalCard(BuildContext context) {
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
                  onPress: onPress ?? () => object.onCardClicked(context),
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

  void init(BuildContext context) async {
    imgUrl = object.getImageUrl(context);
    if (imgUrl == null) return;
  }

  Container getCardBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
