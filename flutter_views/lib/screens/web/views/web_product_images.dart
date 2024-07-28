import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';

class WebProductImages extends StatelessWidget {
  final ViewAbstract item;
  WebProductImages({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    String? url = item.getImageUrl(context);
    bool hasImage = url != null;
    return item.getHeroTag(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: hasImage
                  ? FastCachedImage(
                      url: url,
                      fit: BoxFit.contain,
                    )
                  : item.getIcon(),
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
