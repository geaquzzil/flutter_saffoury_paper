import 'package:flutter/material.dart';
import 'package:flutter_view_controller/customs_widget/popup_widget.dart';
import 'package:flutter_view_controller/new_screens/actions/view/view_view_main_page.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

import 'ext.dart';

class DrawerSettingButton extends StatelessWidget {
  const DrawerSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupWidget(
      child: const Icon(Icons.settings),
      menuBuilder: () => BaseViewNewPage(
          viewAbstract: context.read<DrawerMenuControllerProvider>().getObject),
    );
    return buildColapsedIcon(
      context,
      Icons.settings,
      () {
        Navigator.of(context).pushNamed("/settings");
      },
    );
  }
}
