import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button_network.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ProfileListTileWidget extends StatelessWidget {
  const ProfileListTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();

    return SizedBox(
      width: 300,
      child: ListTile(
        leading: RoundedIconButtonNetwork(
            onTap: () {},
            imageUrl: context.read<AuthProvider>().getUserImageUrl),
        title: Text(
          auth.hasSavedUser
              ? auth.getUserName
              : AppLocalizations.of(context)!.hiThere,
        ),
        subtitle: Text(auth.hasSavedUser
            ? auth.getUserPermission
            : AppLocalizations.of(context)!.guest),
      ),
    );
  }
}
