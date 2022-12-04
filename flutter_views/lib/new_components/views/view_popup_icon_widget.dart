import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/screens/view/view_view_main_page.dart';

import '../../screens/on_hover_button.dart';

class ViewPopupIconWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ViewAbstract viewAbstract;
  ViewPopupIconWidget({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
        arrowSize: 20,
        arrowColor: Theme.of(context).colorScheme.secondaryContainer,
        menuBuilder: () => getWidget(context),
        pressType: PressType.singleClick,
        // verticalMargin: -15,
        controller: _controller,
        child: buildColapsedIcon(context, Icons.view_agenda, null));
  }

  Widget getWidget(BuildContext context) => OutlinedCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: IntrinsicWidth(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.height * .5,
                child: BaseViewNewPage(
                  viewAbstract: viewAbstract,
                )),
          ),
        ),
      );

  OnHoverWidget buildColapsedIcon(
      BuildContext context, IconData data, VoidCallback? onPress) {
    return OnHoverWidget(
        scale: false,
        builder: (onHover) {
          return IconButton(
              // padding: EdgeInsets.all(4),
              onPressed: onPress,
              iconSize: 25,
              icon: Icon(data),
              color: onHover
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary);
        });
  }
}
