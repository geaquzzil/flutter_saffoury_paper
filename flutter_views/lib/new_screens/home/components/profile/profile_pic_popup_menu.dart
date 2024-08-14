import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';

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
    bool isLargeScreen = isLargeScreenFromCurrentScreenSize(context);
    AuthProvider authProvider = context.read<AuthProvider<AuthUser>>();
    return CustomPopupMenu(
      barrierColor: isLargeScreen ? Colors.black54 : Colors.black26,
      menuBuilder: () => isLargeScreen
          ? SizedBox(width: 700, height: 600, child: SettingAndProfileWeb())
          : ProfileMenuWidget(controller: _controller),
      pressType: PressType.singleClick,
      arrowColor: isLargeScreen
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFF4C4C4C),
      controller: _controller,
      child: Icon(Icons.person),
    );
  }
}
