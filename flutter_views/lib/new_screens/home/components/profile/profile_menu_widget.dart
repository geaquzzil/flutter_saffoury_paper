import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfileMenuWidget extends StatelessWidget {
  CustomPopupMenuController controller;
  bool showHeader;
  List<ItemModel> menuItems = [];
  ProfileMenuWidget(
      {super.key, required this.controller, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHeader) const ProfileHeaderListTileWidget(),
              if (showHeader) const Divider(),
              ...menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: item.onPress,
                      child: popMenuItem(context, item),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget popMenuItem(BuildContext context, ItemModel item) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 15,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect popMenuBuilder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: menuItems
              .map(
                (item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    debugPrint("onTap tot");
                    controller.hideMenu();
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 15,
                          color: Colors.black87,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void init(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider>();
    if (authProvider.hasSavedUser) {
      menuItems = [
        ItemModel(authProvider.getUserName, Icons.chat_bubble),
        ItemModel(
            "${AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.profile}",
            Icons.account_box_outlined),
        ItemModel('Tasks', Icons.task),
        ItemModel('Chat', Icons.chat_bubble),
        ItemModel(AppLocalizations.of(context)!.logout, Icons.logout),
      ];
    } else {
      menuItems = [
        ItemModel(
            AppLocalizations.of(context)!.action_sign_in_short, Icons.login,
            onPress: () {
          debugPrint("onPress sing_in");
          controller.hideMenu();
          Navigator.pushNamed(context, '/sign_in');
        }),
      ];
    }
  }
}
