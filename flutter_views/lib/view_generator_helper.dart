import 'package:flutter/material.dart';

import 'models/view_abstract.dart';

class ViewHelper {
  static SafeArea getDrawerSafeArea<T extends ViewAbstract>(
      BuildContext context, List<T> list) {
    return SafeArea(
        child: Container(
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

  static Drawer getDrawer<T extends ViewAbstract>(
      BuildContext context, List<T> list) {
    return Drawer(
      child: getDrawableListView(context, list),
    );
  }

  static List<Widget> getDrawableListTile<T extends ViewAbstract>(
      BuildContext context, List<T> list) {
    return List<Widget>.from(
        list.map((model) => model.getDrawerListTitle(context)));
  }

  static ListView getDrawableListView<T extends ViewAbstract>(
      BuildContext context, List<T> list) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: getDrawableListTile(context, list));
  }
}
