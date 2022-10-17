import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_list_tile_widget.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ItemModel {
  String title;
  IconData icon;
  GestureTapCallback? onPress;

  ItemModel(this.title, this.icon, {this.onPress});
}

class ProfilePicturePopupMenu extends StatefulWidget {
  const ProfilePicturePopupMenu({Key? key}) : super(key: key);

  @override
  State<ProfilePicturePopupMenu> createState() =>
      _ProfilePicturePopupMenuState();
}

class _ProfilePicturePopupMenuState extends State<ProfilePicturePopupMenu> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  bool loading = true;
  List<ItemModel> menuItems = [];

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
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
          _controller.hideMenu();
          Navigator.pushNamed(context, '/sign_in');
        }),
      ];
    }

    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      duration: const Duration(milliseconds: 1000),
      child: CustomPopupMenu(
        arrowSize: 20,
        arrowColor: Colors.white,
        menuBuilder: () => popMenuBuilderListTile(),
        pressType: PressType.singleClick,
        verticalMargin: -15,
        controller: _controller,
        child: RoundedIconButtonNetwork(
            onTap: () {}, imageUrl: authProvider.getUserImageUrl),
      ),
    );
  }

  Widget popMenuBuilderListTile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileListTileWidget(),
              const Divider(),
              ...menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: item.onPress,

                      // {
                      //   debugPrint("onTap toto");

                      //   _controller.hideMenu();
                      // }
                      // ,
                      child: popMenuItem(item),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget popMenuItem(ItemModel item) {
    return Container(
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
    );
  }

  ClipRRect popMenuBuilder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: menuItems
                .map(
                  (item) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      debugPrint("onTap tot");
                      _controller.hideMenu();
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
      ),
    );
  }
}
