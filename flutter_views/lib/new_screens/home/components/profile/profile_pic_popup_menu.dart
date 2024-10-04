import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile_new.dart';

class ItemModel {
  String title;
  IconData icon;
  GestureTapCallback? onPress;

  ItemModel(this.title, this.icon, {this.onPress});
}

class ProfilePicturePopupMenu extends StatefulWidget {
  const ProfilePicturePopupMenu({super.key});

  @override
  State<ProfilePicturePopupMenu> createState() =>
      _ProfilePicturePopupMenuState();
}

class _ProfilePicturePopupMenuState extends State<ProfilePicturePopupMenu> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      barrierColor: Colors.black26,
      menuBuilder: () => SizedBox(
          width: 700,
          height: 600,
          child: SettingPageNew(
            isFromMenu: true,
              isFirstToSecOrThirdPane: true,
              )),
      pressType: PressType.singleClick,
      arrowColor: Theme.of(context).scaffoldBackgroundColor,
      controller: _controller,
      child: const Icon(Icons.person),
    );
  }
}
