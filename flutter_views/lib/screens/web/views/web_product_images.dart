import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/new_screens/actions/components/action_on_header_widget.dart';

class WebProductImages extends StatelessWidget {
  final ViewAbstract item;
  const WebProductImages({super.key, required this.item});


// 139 x 70 x45
// 35 => 70
// 69 => 100
// 100 => 70

// 102 =>60

// 72 => 100



// adnan al asdi 
//   143  =>52  => 90 330g
//     52 => 100  1750 sheet 
//     90 => 100  1750 sheet 
// 

  @override
  Widget build(BuildContext context) {
    return item.getHeroTag(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: FastCachedImage(
                url: item.getImageUrl(context) ?? "",
                fit: BoxFit.contain,
              ),
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
