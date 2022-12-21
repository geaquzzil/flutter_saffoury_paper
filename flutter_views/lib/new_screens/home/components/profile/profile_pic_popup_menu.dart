import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_menu_widget.dart';
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
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.read<AuthProvider>();
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      duration: const Duration(milliseconds: 1000),
      child: CustomPopupMenu(
        menuBuilder: () => ProfileMenuWidget(controller: _controller),
        pressType: PressType.singleClick,
        controller: _controller,
        child: RoundedIconButtonNetwork(
            onTap: () {}, imageUrl: authProvider.getUserImageUrl),
      ),
    );
  }
}
