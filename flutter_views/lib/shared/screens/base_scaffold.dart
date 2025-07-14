import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  Widget body;
  bool automaticallyImplyLeading = false;
  AppBar? appBar;
  BaseScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<DrawerMenuControllerProvider>().getStartDrawableKey,
      appBar: appBar,
      body: body,
    );
  }
}
