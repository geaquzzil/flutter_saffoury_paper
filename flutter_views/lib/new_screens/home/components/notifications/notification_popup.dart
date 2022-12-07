import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

class NotificationPopupWidget extends StatelessWidget {
  String notifiactionLottie =
      "https://assets6.lottiefiles.com/packages/lf20_heejrebm.json";
  NotificationPopupWidget({Key? key}) : super(key: key);
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    String title = "No New Notifications";
    String subtitle =
        "Check this section for updates exclusively offer and general notifications";
    return CustomPopupMenu(
      
        arrowSize: 20,
        arrowColor: Theme.of(context).colorScheme.secondaryContainer,
        menuBuilder: () => popMenuBuilder(context, title, subtitle),
        pressType: PressType.singleClick,
        verticalMargin: -15,
        controller: _controller,
        child: buildColapsedIcon(context, Icons.notifications, null));
  }

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

  Widget popMenuBuilder(BuildContext context, String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: IntrinsicWidth(
          child: SizedBox(
            width: 400,
            height: 400,
            child: ListStaticWidget(
                list: context.watch<NotificationProvider>().getList,
                emptyWidget: EmptyWidget(
                    lottiUrl: notifiactionLottie,
                    title: title,
                    subtitle: subtitle)),
          ),
        ),
      ),
    );
  }
}
