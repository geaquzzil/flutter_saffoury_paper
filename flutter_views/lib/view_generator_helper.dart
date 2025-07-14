import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'models/view_abstract.dart';

class ViewHelper {
  static SafeArea getDrawerSafeArea(
      BuildContext context, List<ViewAbstract> list) {
    return SafeArea(
        child: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints.expand(height: double.infinity),
            child: ListTileTheme(
              // textColor: Colors.white,
              // iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 128.0,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 64.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'assets/images/flutter_logo.png',
                    ),
                  ),
                  getDrawableListView(context, list),
                  const Spacer(),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: const Text('Terms of Service | Privacy Policy'),
                    ),
                  ),
                ],
              ),
            )));
  }

  static Drawer getDrawer(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    return Drawer(
      child: getDrawableListView(context, authProvider.getDrawerItems),
    );
  }

  static List<Widget> getDrawableListTile(
      BuildContext context, List<ViewAbstract> list) {
    return List<Widget>.from(
        list.map((model) => model.getDrawerListTitle(context)));
  }

  static ListView getDrawableListView(
      BuildContext context, List<ViewAbstract> list) {
    return ListView(
        padding: EdgeInsets.zero, children: getDrawableListTile(context, list));
  }
}
