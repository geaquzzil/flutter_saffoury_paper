import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 100,
      child: ListTile(
        leading: Icon(Icons.account_box_outlined),
        title: Text(context.read<AuthProvider>().getUserName),
        subtitle: Text(context.read<AuthProvider>().getUserPermission),
        trailing: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
