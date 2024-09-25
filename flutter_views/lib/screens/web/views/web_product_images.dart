import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';

class WebProductImages extends StatelessWidget {
  final ViewAbstract item;
  const WebProductImages({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    String? url = item.getImageUrl(context);
    bool hasImage = url != null;
    hasImage = false;
    return item.getHeroTag(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: hasImage
                    ? FastCachedImage(
                        url: url!,
                        fit: BoxFit.cover,
                      )
                    : item.getIcon(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ActionsOnHeaderWidget(
              viewAbstract: item,
              useRoundedIcon: true,
              serverActions: ServerActions.view,
            ),
          ]),
        ));
  }
}
