import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfileHeaderListTileWidget extends StatelessWidget {
  const ProfileHeaderListTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider<AuthUser>>();

    return ListTile(
      leading: RoundedIconButtonNetwork(
          onTap: () {},
          imageUrl: context.read<AuthProvider<AuthUser>>().getUserImageUrl),
      title: Text(
        auth.hasSavedUser
            ? auth.getUserName
            : AppLocalizations.of(context)!.hiThere,
      ),
      subtitle: Text(auth.hasSavedUser
          ? auth.getUserPermission
          : AppLocalizations.of(context)!.guest),
    );
  }
}
