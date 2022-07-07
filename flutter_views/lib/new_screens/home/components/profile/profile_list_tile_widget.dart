import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_pic_popup_menu.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileListTileWidget extends StatelessWidget {
  const ProfileListTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: ListTile(
        leading:RoundedIconButtonNetwork(
          onTap: () {}, imageUrl: context.read<AuthProvider>().getUserImageUrl),
        title: Text(context.read<AuthProvider>().getUserName),
        subtitle: Text(context.read<AuthProvider>().getUserPermission),
      ),
    );
  }
}
