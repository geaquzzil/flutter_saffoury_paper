import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/notification_interface.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_static_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_view_abstract_new.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/notifications/notification_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class NotificationPopupWidget extends StatelessWidget {
  NotificationPopupWidget({super.key});
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = isLargeScreenFromCurrentScreenSize(context);
    return CustomPopupMenu(
        barrierColor: isLargeScreen ? Colors.black54 : Colors.black26,
        // arrowSize: 20,
        arrowColor: Theme.of(context).colorScheme.surface,
        menuBuilder: () => NotificationWidget(),
        pressType: PressType.singleClick,
        // verticalMargin: -15,
        controller: _controller,
        child: Icon(Icons.notifications)

        // buildColapsedIcon(context, Icons.notifications, null)

        );
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
}

class NotificationWidget extends StatelessWidget {
  NotificationWidget({
    super.key,
  });

  String title = "No New Notifications";
  String subtitle =
      "Check this section for updates exclusively offer and general notifications";
  String notifiactionLottie =
      "https://assets6.lottiefiles.com/packages/lf20_heejrebm.json";
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: IntrinsicWidth(
          child: SizedBox(
              width: 400,
              height: 400,
              child: SliverApiMixinViewAbstractWidget(
                enableSelection: false,
                hasCustomSeperater: Divider(),
                isSliver: false,
                toListObject: context
                    .read<AuthProvider<AuthUser>>()
                    .getNotificationHandler(),
                hasCustomCardBuilder: (index,item) {
                  ViewAbstract v =
                      (item as NotificationHandlerInterface).getObject(context);

                  return ListCardItem(object: v);
                },
              )

              // ListStaticWidget(
              //     list: context.watch<NotificationProvider>().getList,
              //     emptyWidget: EmptyWidget(
              //         lottiUrl: notifiactionLottie,
              //         title: title,
              //         subtitle: subtitle)),
              ),
        ),
      ),
    );
  }
}
