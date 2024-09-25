import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/size_config.dart';

class PopupWidgetBuilder extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  IconData icon;
  Widget builder;
  PopupWidgetBuilder({super.key, required this.builder, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
        menuBuilder: () => builder,
        enablePassEvent: true,
        pressType: PressType.singleClick,
        showArrow: true,
        controller: _controller,
        child: Icon(icon));
  }

  Widget getWidget(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: IntrinsicWidth(
          child: SizedBox(
              width: MediaQuery.of(context).size.width *
                  (isTablet(context) ? 0.5 : 0.25),
              height: MediaQuery.of(context).size.height * .8,
              child: builder),
        ),
      );
}
