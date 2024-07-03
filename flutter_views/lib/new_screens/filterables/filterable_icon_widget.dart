import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/size_config.dart';

import '../../screens/on_hover_button.dart';
import 'base_filterable_main.dart';

class FilterablePopupIconWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  FilterablePopupIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
        // arrowSize: 20,
        // arrowColor: Theme.of(context).colorScheme.secondaryContainer,
        menuBuilder: () => getWidget(context),
        enablePassEvent: true,

        // barrierColor: Colors.red,
        // arrowColor: Colors.red,
        pressType: PressType.singleClick,
        showArrow: true,
        verticalMargin: -100,
        controller: _controller,
        child: buildColapsedIcon(context, Icons.filter_alt_rounded, null));
  }

  Widget getWidget(BuildContext context) => OutlinedCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            // color: Theme.of(context).colorScheme.secondaryContainer,
            child: IntrinsicWidth(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      (SizeConfig.isTablet(context) ? 0.5 : 0.25),
                  height: MediaQuery.of(context).size.height * .8,
                  child: BaseFilterableMainWidget()),
            ),
          ),
        ),
      );

  Widget buildColapsedIcon(
      BuildContext context, IconData data, VoidCallback? onPress) {
    // return Icon(data);
    return IconButton(
      color: Theme.of(context).indicatorColor,
      // padding: EdgeInsets.all(4),
      onPressed: onPress,
      icon: Icon(
        data,
        color: Theme.of(context).indicatorColor,
      ),
    );
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
