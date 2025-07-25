import 'package:animations/animations.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:palette_generator/palette_generator.dart';

import '../cards/card_clicked.dart';

class ListCardItemHorizontal<T extends ViewAbstract> extends StatefulWidget {
  final T object;
  final Function()? onPress;
  final bool useOutlineCard;
  bool useImageAsBackground;

  ListCardItemHorizontal({
    super.key,
    required this.object,
    this.onPress,
    this.useImageAsBackground = false,
    this.useOutlineCard = false,
  });

  @override
  State<ListCardItemHorizontal<T>> createState() =>
      _ListCardItemHorizontalState<T>();
}

class _ListCardItemHorizontalState<T extends ViewAbstract>
    extends State<ListCardItemHorizontal<T>>
    with TickerProviderStateMixin {
  PaletteGenerator? color;

  final ColorTween _borderColorTween = ColorTween();
  late Animation<Color?> _borderColor;
  late AnimationController _controller;
  static final Animatable<double> _easeOutTween = CurveTween(
    curve: Curves.easeOut,
  );
  String? imgUrl;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    if (widget.useImageAsBackground) {
      if (imgUrl != null) {
        return FutureBuilder<PaletteGenerator>(
          future: PaletteGenerator.fromImageProvider(
            FastCachedImageProvider(imgUrl!),
          ),
          builder: (context, snapshot) {
            color = snapshot.data;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _borderColorTween
                ..begin = Theme.of(context).colorScheme.onPrimaryContainer
                ..end = color?.darkMutedColor?.color;
              _controller.forward();
            });
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
          child: widget.useOutlineCard
              ? Cards(
                  type: CardType.outline,
                  colorWithOverlay: color?.paletteColors.first.color,

                  child: (_) => getCardAsBackgroundBody(context),
                )
              : Card(child: getCardAsBackgroundBody(context)),
        ),
        widget.object.getHorizontalCardMainHeader(context),
        // const Spacer(),
        widget.object.getHorizontalCardSubtitle(context),
      ],
    );
  }

  Stack getCardAsBackgroundBody(BuildContext context) {
    return Stack(
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
                    image: FastCachedImageProvider(imgUrl!),
                    fit: BoxFit.contain,
                  ),
            color: imgUrl == null ? null : color?.darkVibrantColor?.color,
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
        ),
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
                      Colors.black87,
                    ],
                  ),
            color: imgUrl == null
                ? null
                : color?.darkVibrantColor?.titleTextColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          // height: 50,
          padding: const EdgeInsets.all(kDefaultPadding * .3),

          // width: double.infinity,
          child: widget.object.getHorizontalCardTitleSameLine(
            context,
            isImageAsBackground: true,
            color: color,
            animatedColor: _borderColor,
          ),
        ),
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
          BaseViewNewPage(viewAbstract: widget.object),
    );
  }

  Stack getNormalCard(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 60 / 2.0, bottom: 60 / 2),
          child: widget.useOutlineCard
              ? Cards(
                  type: CardType.outline,
                  onPress:
                      widget.onPress ??
                      () => widget.object.onCardClicked(context),
                  child: (v) => getCardBody(context),
                )
              : CardClicked(
                  onPress:
                      widget.onPress ??
                      () => widget.object.onCardClicked(context),
                  child: getCardBody(context),
                ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: DecoratedBox(
              decoration: const ShapeDecoration(shape: CircleBorder()),
              child: widget.object.getCardLeading(
                context,
                addCustomHeroTag: "horizontal",
              ),
            ),
          ),
        ),
      ],
    );
  }

  void init(BuildContext context) async {
    imgUrl = widget.object.getImageUrlAddHost(context);
    if (imgUrl == null) return;
  }

  Container getCardBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 60 / 2),

          widget.object.getHorizontalCardTitleSameLine(context),
          const SizedBox(height: kDefaultPadding / 2),
          // Spacer(),
          widget.object.getHorizontalCardMainHeader(context),
          // const Spacer(),
          widget.object.getHorizontalCardSubtitle(context),
        ],
      ),
    );
  }
}
