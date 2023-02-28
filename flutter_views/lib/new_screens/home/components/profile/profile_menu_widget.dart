import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/card_clicked.dart';
import 'package:flutter_view_controller/new_components/cards/clipper_card.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfileMenuWidget extends StatelessWidget {
  CustomPopupMenuController? controller;
  bool showHeader;
  List<ItemModel> menuItems = [];
  ValueNotifier<ItemModel?>? selectedValue;
  ProfileMenuWidget(
      {super.key, this.controller, this.showHeader = true, this.selectedValue});

  @override
  Widget build(BuildContext context) {
    init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Theme.of(context).cardColor,
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
                      onTap: () {
                        if (selectedValue != null) {
                          selectedValue!.value = item;
                        } else {
                          item.onPress?.call();
                        }
                      },
                      child: OnHoverWidget(
                          scale: false,
                          builder: (isHovered) {
                            Widget child = popMenuItem(context, item);

                            if (selectedValue != null) {
                              return ValueListenableBuilder<ItemModel?>(
                                builder: (context, value, _) {
                                  if (value == null) {
                                    child = isHovered
                                        ? Card(
                                            child: child,
                                          )
                                        : child;
                                    return child;
                                  }
                                  child = isHovered && value.title != item.title
                                      ? Card(
                                          child: child,
                                        )
                                      : child;
                                  if (value.title == item.title) {
                                    return ClippedCard(
                                        color: kPrimaryColor, child: child);
                                  } else {
                                    return child;
                                  }
                                },
                                valueListenable: selectedValue!,
                              );
                            }
                            child = isHovered
                                ? Card(
                                    child: child,
                                  )
                                : child;
                            return child;
                          }),
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
                    controller?.hideMenu();
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
    AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
    if (authProvider.hasSavedUser) {
      menuItems = [
        ItemModel(authProvider.getUserName, Icons.chat_bubble),
        ItemModel(
            "${AppLocalizations.of(context)!.edit} ${AppLocalizations.of(context)!.profile}",
            Icons.account_box_outlined),
        ItemModel(AppLocalizations.of(context)!.orders,
            Icons.shopping_basket_rounded),
        ItemModel('Chat', Icons.chat_bubble),
        ItemModel("Help", Icons.help_outline_rounded),
        ItemModel(AppLocalizations.of(context)!.logout, Icons.logout),
      ];
    } else {
      menuItems = [
        ItemModel(
            AppLocalizations.of(context)!.action_sign_in_short, Icons.login,
            onPress: () {
          debugPrint("onPress sing_in");
          controller?.hideMenu();
          context.goNamed(loginRouteName);
        }),
      ];
    }
  }
}
