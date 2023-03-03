import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class WebProductImages extends StatelessWidget {
  final ViewAbstract item;
  const WebProductImages({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return item.getHeroTag(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child:
                  CachedNetworkImage(imageUrl: item.getImageUrl(context) ?? ""),
            )
          ]),
        ));
  }
}
