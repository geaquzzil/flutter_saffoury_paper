import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'profile_menu_widget.dart';

class ProfileOnOpenDrawerWidget extends StatelessWidget {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ProfileOnOpenDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider<AuthUser>>();
    return CustomPopupMenu(
        showArrow: false,
        position: PreferredPosition.top,
        menuBuilder: () => ProfileMenuWidget(controller: _controller),
        pressType: PressType.singleClick,
        controller: _controller,
        child: const ProfileHeaderListTileWidget());
  }
}
